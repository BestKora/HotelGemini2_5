//
//  BookingInfoView.swift
//  HotelGoogleStudio Gemini 2.5
//
//  Created by Tatiana Kornilova on 30.03.2025.
//

import SwiftUI
import Combine // Needed for keyboard observers if we wanted more advanced focus handling

// MARK: - Data Models (Simple representations for the example)

struct HotelBookingInfo {
    let ratingValue: Int = 5
    let ratingName: String = "Превосходно"
    let hotelName: String = "Steigenberger Makadi"
    let hotelAddress: String = "Madinat Makadi, Safaga Road, Makadi Bay, Египет"
}

struct BookingDetails {
    let departureCity: String = "Санкт-Петербург"
    let countryCity: String = "Египет, Хургада"
    let dates: String = "19.09.2023 - 27.09.2023"
    let nights: String = "7 ночей"
    let hotelName: String = "Steigenberger Makadi"
    let roomType: String = "Стандартный с видом на бассейн или сад"
    let mealPlan: String = "Все включено"
}

// MARK: - Main Booking Info View

struct BookingInfoView: View {
    // --- State Variables ---
    @State private var phoneNumber: String = "" // Stores the RAW digits (max 10)
  //  @State private var displayedPhoneNumber: String = "+7 " // What the user sees/edits
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true // Assume valid initially or until typed

    // --- Data ---
    let hotelInfo = HotelBookingInfo()
    let bookingDetails = BookingDetails()

    // --- Environment ---
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
     //   NavigationView {
                ScrollView {
                    VStack(spacing: 8) { // Spacing between blocks
                        HotelInfoBlock(info: hotelInfo)
                        BookingDetailsBlock(details: bookingDetails)
                        BuyerInfoBlock(
                            phoneNumber: $phoneNumber,
                            email: $email,
                            isEmailValid: $isEmailValid
                        )
                        
                            Spacer() // Pushes content up if screen is tall
                      //  TouristInfoView()
                    }// VStack
                    .padding(.horizontal) // Padding for the whole content stack
                    .padding(.top)      // Padding from the navigation bar
                    TouristInfoView()
                } // scroll
            .background(Color(UIColor.systemGray6)) // Background for the whole screen
            .navigationTitle("Бронирование")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Номера")
                            .foregroundColor(.secondary)
                        }
                    }
                    .tint(.primary) // Ensure back button has default color
                } //ToolbarItem
            } // toolbar
      //  } // NavigationView
    } // body
} // struct

// MARK: - Block Views

struct HotelInfoBlock: View {
    let info: HotelBookingInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                Text("\(info.ratingValue) \(info.ratingName)")
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.orange)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.orange.opacity(0.15))
            .cornerRadius(5)

            Text(info.hotelName)
                .font(.system(size: 22, weight: .medium))

            Text(info.hotelAddress)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.blue) // Link-like appearance
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // Take full width
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct BookingDetailsBlock: View {
    let details: BookingDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 16) { // Increased spacing between rows
            BookingDetailRow(label: "Вылет из", value: details.departureCity)
            BookingDetailRow(label: "Страна, город", value: details.countryCity)
            BookingDetailRow(label: "Даты", value: details.dates)
            BookingDetailRow(label: "Кол-во ночей", value: details.nights)
            BookingDetailRow(label: "Отель", value: details.hotelName)
            BookingDetailRow(label: "Номер", value: details.roomType)
            BookingDetailRow(label: "Питание", value: details.mealPlan)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// Helper for Booking Details rows
struct BookingDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) { // Align top for potentially multi-line values
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading) // Fixed width for labels

            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading) // Take remaining space
        }
    }
}

struct BuyerInfoBlock: View {
    @Binding var phoneNumber: String // Raw digits
  //  @Binding var displayedPhoneNumber: String // Formatted for display/edit
    @Binding var email: String
    @Binding var isEmailValid: Bool
    
    @State var isValid: Bool = false
    let phoneRegex = try! NSRegularExpression(pattern: #"^\+7 \(\d{3}\) \d{3}-\d{2}-\d{2}$"#)

    var body: some View {
        VStack(alignment: .leading, spacing: 20) { // Space between title and fields
            Text("Информация о покупателе")
                .font(.system(size: 22, weight: .medium))

            VStack(alignment: .leading, spacing: 8) { // Space within the fields group
                Text("Номер телефона")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.leading, 12) // Indent label slightly

                TextField("", text: $phoneNumber, prompt: Text("+7 (***) *** - ** - **").foregroundColor(.gray))
                    .keyboardType(.numberPad)
                    .onReceive(Just(phoneNumber)) { newValue in
                        if !phoneNumber.isEmpty {
                            phoneNumber = formatPhoneNumber(newValue)
                            validatePhoneNumber(newValue)
                        }
                    }
                    .onAppear{
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                if !isValid {
                    Text("Invalid format. Example: +7 (901) 555-66-77")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Text("Почта")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.leading, 12)

                TextField("example@mail.ru", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(isEmailValid ? Color(UIColor.systemGray6) : Color.red.opacity(0.15)) // Visual validation feedback
                    .cornerRadius(10)
                    .overlay( // Optional: Add border for invalid state
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isEmailValid ? Color.clear : Color.red, lineWidth: 1)
                    )
                    .onChange(of: email) { _, newValue in
                        // Validate only if email is not empty
                        if !newValue.isEmpty {
                             isEmailValid = isValidEmail(newValue)
                        } else {
                            isEmailValid = true // Consider empty as valid or neutral
                        }
                    }
            }

            Text("Эти данные никому не передаются. После оплаты мы вышли чек на указанный вами номер и почту")
                .font(.system(size: 14))
                .foregroundColor(.secondary)

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }

    // MARK: Phone Masking Logic
    // Formats the input string to the template: +7 (XXX) XXX-XX-XX.
    private  func formatPhoneNumber(_ number: String) -> String {
            // Remove any non-digit characters.
            let digitsOnly = number.filter { $0.isNumber }
            var cleanedNumber = digitsOnly
            
            // If the first digit is 7 or 8, remove it.
            if let first = cleanedNumber.first, first == "7" || first == "8" {
                cleanedNumber.removeFirst()
            }
            
            // Limit to 10 digits.
            if cleanedNumber.count > 10 {
                cleanedNumber = String(cleanedNumber.prefix(10))
            }
            
            // Start with the fixed +7 prefix.
            var formatted = "+7 "
            
            // Create the area code part.
            if !cleanedNumber.isEmpty {
                formatted += "("
                let areaCodeEnd = min(3, cleanedNumber.count)
                let areaCode = cleanedNumber.prefix(areaCodeEnd)
                formatted += areaCode
                if areaCode.count == 3 {
                    formatted += ") "
                }
            }
            
            // Next 3 digits.
            if cleanedNumber.count > 3 {
                let startIndex = cleanedNumber.index(cleanedNumber.startIndex, offsetBy: 3)
                let endIndex = cleanedNumber.index(startIndex, offsetBy: min(3, cleanedNumber.count - 3))
                let firstThree = cleanedNumber[startIndex..<endIndex]
                formatted += firstThree
                if firstThree.count == 3 {
                    formatted += "-"
                }
            }
            
            // Next 2 digits.
            if cleanedNumber.count > 6 {
                let startIndex = cleanedNumber.index(cleanedNumber.startIndex, offsetBy: 6)
                let endIndex = cleanedNumber.index(startIndex, offsetBy: min(2, cleanedNumber.count - 6))
                let nextTwo = cleanedNumber[startIndex..<endIndex]
                formatted += nextTwo
                if nextTwo.count == 2 {
                    formatted += "-"
                }
            }
            
            // Last 2 digits.
            if cleanedNumber.count > 8 {
                let startIndex = cleanedNumber.index(cleanedNumber.startIndex, offsetBy: 8)
                let endIndex = cleanedNumber.index(startIndex, offsetBy: min(2, cleanedNumber.count - 8))
                let lastTwo = cleanedNumber[startIndex..<endIndex]
                formatted += lastTwo
            }
            
            return formatted
        }
    
    private func validatePhoneNumber(_ number: String) {
        let range = NSRange(location: 0, length: number.utf16.count)
        // Check if the entire string matches the regular expression
        isValid = phoneRegex.firstMatch(in: number, options: [], range: range) != nil
    }

     // MARK: Email Validation Logic
     private func isValidEmail(_ email: String) -> Bool {
         // Simple regex for basic email format validation
         let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
         return emailPredicate.evaluate(with: email)
     }
}


// MARK: - Preview

#Preview {
        BookingInfoView()
}
