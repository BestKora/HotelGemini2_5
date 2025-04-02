//
//  TouristInfoView.swift
//  HotelGoogleStudio Gemini 2.5
//
//  Created by Tatiana Kornilova on 31.03.2025.
//

import SwiftUI

// MARK: - Data Models

struct Tourist: Identifiable {
    let id = UUID() // Necessary for ForEach
    var isExpanded: Bool = true // State for collapsing/expanding

    // Form fields
    var firstName: String = ""
    var lastName: String = ""
    var dateOfBirth: String = "" // Could use Date type later
    var citizenship: String = ""
    var passportNumber: String = ""
    var passportExpiry: String = "" // Could use Date type later
}

struct PricingInfo {
    let tourPrice: Int
    let fuelSurcharge: Int
    let serviceCharge: Int

    var totalPrice: Int {
        tourPrice + fuelSurcharge + serviceCharge
    }
}

// MARK: - Main View

struct TouristInfoView: View {
    // --- State Variables ---
    @State private var tourists: [Tourist] = [Tourist()] // Start with one tourist
    @State private var pricing = PricingInfo(
        tourPrice: 186600,
        fuelSurcharge: 9300,
        serviceCharge: 2136
    )

    var body: some View {
    
        VStack {
            ScrollView {
                VStack(spacing: 8) { // Spacing between blocks

                    // --- Tourist Information Block ---
                    TouristListBlock(tourists: $tourists)

                    // --- Add Tourist Button ---
                    AddTouristButton {
                        addNewTourist()
                    }

                    // --- Price Summary Block ---
                    PriceSummaryBlock(pricing: pricing)
                    PaymentButton(totalAmount: pricing.totalPrice) {
                        // Action for payment
                        print("Proceeding to pay \(formattedPrice(pricing.totalPrice))")
                    }

                }
                .padding(.horizontal) // Padding for the whole content stack
                .padding(.top)
            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea()) // Background for the whole screen
        }
    }

    // --- Helper Functions ---

    private func addNewTourist() {
        withAnimation { // Animate the addition
             tourists.append(Tourist())
        }
    }

     private func formattedPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " " // Use space as separator
        return (formatter.string(from: NSNumber(value: price)) ?? "\(price)") + " ₽"
    }
}

// MARK: - Child Views / Blocks

struct TouristListBlock: View {
    @Binding var tourists: [Tourist]

    var body: some View {
        VStack(spacing: 8) { // Consistent spacing
             ForEach($tourists) { $tourist in // Use $ for bindings
                // Find the index for displaying the correct number
                 if let index = tourists.firstIndex(where: { $0.id == tourist.id }) {
                    TouristEntryView(
                        tourist: $tourist,
                        touristNumber: index + 1 // Pass the 1-based index
                    )
                 }
            }
        }
        // No background/cornerRadius here, apply it to TouristEntryView itself
    }
}

struct TouristEntryView: View {
    @Binding var tourist: Tourist
    let touristNumber: Int

    // Helper to get ordinal string ("Первый", "Второй", etc.)
    private func ordinal(number: Int) -> String {
        // Basic implementation, expand for more numbers if needed
        switch number {
        case 1: return "Первый"
        case 2: return "Второй"
        case 3: return "Третий"
        case 4: return "Четвертый"
        case 5: return "Пятый"
        default: return "\(number)-й"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) { // No spacing for header/content separation
            // --- Header ---
            HStack {
                Text("\(ordinal(number: touristNumber)) турист")
                    .font(.system(size: 22, weight: .medium))
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { // Animate expand/collapse
                        tourist.isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: tourist.isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                        .padding(8) // Increase tappable area
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
            .padding() // Padding for the header itself

            // --- Form Fields (Conditional) ---
            if tourist.isExpanded {
                VStack { // Spacing between fields
                    StylizedTextField(placeholder: "Имя", text: $tourist.firstName)
                    StylizedTextField(placeholder: "Фамилия", text: $tourist.lastName)
                    StylizedTextField( placeholder: "Дата рождения", text: $tourist.dateOfBirth)
                    StylizedTextField( placeholder: "Гражданство", text: $tourist.citizenship)
                    StylizedTextField(placeholder: "Номер загранпаспорта", text: $tourist.passportNumber)
                    StylizedTextField(placeholder: "Срок действия загранпаспорта", text: $tourist.passportExpiry)
                }
                .padding(.horizontal) // Padding for the form fields container
                .padding(.bottom)    // Add padding at the bottom of the form
                // Smooth transition for appearing fields
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

// Reusable TextField with placeholder label
struct StylizedTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay (alignment: .top) {
                if !text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, 12) // Indent title slightly
                        .padding(.bottom, -2) // Pull textfield up a bit
                        .zIndex(1) // Ensure title is above TextField background
                }
            }
    }
}

struct AddTouristButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Text("Добавить туриста")
                .font(.system(size: 22, weight: .medium))
            Spacer()
            Button(action: action) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct PriceSummaryBlock: View {
    let pricing: PricingInfo

    private func formattedPrice(_ price: Int) -> String {
        // Duplicated formatting logic for self-containment, could be centralized
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return (formatter.string(from: NSNumber(value: price)) ?? "\(price)") + " ₽"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PriceRow(label: "Тур", amount: pricing.tourPrice)
            PriceRow(label: "Топливный сбор", amount: pricing.fuelSurcharge)
            PriceRow(label: "Сервисный сбор", amount: pricing.serviceCharge)
            PriceRow(label: "К оплате", amount: pricing.totalPrice, isTotal: true)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// Helper for rows in the price summary
struct PriceRow: View {
    let label: String
    let amount: Int
    var isTotal: Bool = false

    private func formattedPrice(_ price: Int) -> String {
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.groupingSeparator = " "
         return (formatter.string(from: NSNumber(value: price)) ?? "\(price)") + " ₽"
     }

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.secondary)

            Spacer()

            Text(formattedPrice(amount))
                .font(.system(size: 16, weight: isTotal ? .semibold : .regular))
                .foregroundColor(isTotal ? .blue : .primary) // Highlight total price
        }
    }
}


struct PaymentButton: View {
    let totalAmount: Int
    let action: () -> Void

    private func formattedPrice(_ price: Int) -> String {
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.groupingSeparator = " "
         return (formatter.string(from: NSNumber(value: price)) ?? "\(price)") + " ₽"
     }

    var body: some View {
        Button(action: action) {
            Text("Оплатить \(formattedPrice(totalAmount))")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(15)
        }
        .padding(.horizontal)
        .padding(.vertical, 8) // Add some vertical padding
        .background( // Add a white background behind the button area
            Color.white
                .ignoresSafeArea(edges: .bottom) // Extend white to screen bottom edge
                .shadow(radius: 1) // Optional subtle shadow above button
        )
    }
}


// MARK: - Preview

#Preview {
        TouristInfoView()
}

