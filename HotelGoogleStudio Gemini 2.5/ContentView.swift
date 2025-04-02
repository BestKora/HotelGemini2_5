//
//  ContentView.swift
//  HotelGoogleStudio Gemini 2.5
//
//  Created by Tatiana Kornilova on 28.03.2025.
//

import SwiftUI

// MARK: - Data Models

struct Hotel: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let ratingName: String
    let address: String
    let minimalPrice: Int
    let priceForIt: String
    let imageUrls: [String] // Use image names from Assets or URLs
    let description: String
    let peculiarities: [String] // Like "3-я линия", "Платный Wi-Fi в фойе"
}

struct Room: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let pricePer: String
    let peculiarities: [String] // Like "Все включено", "Кондиционер"
    let imageUrls: [String]
}


// MARK: - Content View (Root)

struct ContentView: View {
    // --- MOCK DATA ---
    // In a real app, this would come from a ViewModel/API
    let sampleHotel = Hotel(
        name: "Steigenberger Makadi", // Updated name based on screenshot 4
        rating: 5.0,
        ratingName: "Превосходно",
        address: "Madinat Makadi, Safaga Road, Makadi Bay, Египет",
        minimalPrice: 134673,
        priceForIt: "за тур с перелётом",
        imageUrls: ["hotel_placeholder_1", "hotel_placeholder_2", "hotel_placeholder_3", "hotel_placeholder_4", "hotel_placeholder_5", "hotel_placeholder_6", "hotel_placeholder_7"], // Add your image names
        description: "Отель VIP-класса с собственными гольф полями. Высокий уровень сервиса. Рекомендуем для респектабельного отдыха.",
        peculiarities: ["3-я линия", "Платный Wi-Fi в фойе", "30 км до аэропорта", "1 км до пляжа"]
    )

     let sampleRooms = [
        Room(name: "Стандартный с видом на бассейн или сад", price: 186600, pricePer: "за 7 ночей с перелётом", peculiarities: ["Все включено", "Кондиционер"], imageUrls: ["room1_image1", "room1_image2","room1_image3","room1_image4"]),
        Room(name: "Люкс с видом на море", price: 250000, pricePer: "за 7 ночей с перелётом", peculiarities: ["Все включено", "Кондиционер", "Мини-бар"], imageUrls: ["suite1_image1", "suite1_image2", "suite1_image3"])
        // Add more rooms
    ]
    // --- ---

    var body: some View {
        NavigationView {
            HotelDetailView(hotel: sampleHotel, rooms: sampleRooms)
        }
        // Optional: Use .accentColor for global tint if needed
        // .accentColor(.blue)
    }
}

// MARK: - Hotel Detail View

struct HotelDetailView: View {
    let hotel: Hotel
    let rooms: [Room] // Pass rooms data for navigation

    @State private var selectedImageIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // --- Section 1: Image Carousel, Basic Info ---
                VStack(alignment: .leading, spacing: 16) {
                    ImageCarouselView(imageUrls: hotel.imageUrls, selectedIndex: $selectedImageIndex)
                        .frame(height: 250) // Adjust height as needed
                        .clipShape(RoundedRectangle(cornerRadius: 15)) // Rounded corners

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text("\(hotel.rating, specifier: "%.1f") \(hotel.ratingName)")
                            .foregroundColor(.orange)
                            .font(.system(size: 16, weight: .medium))
                    }

                    Text(hotel.name)
                        .font(.system(size: 22, weight: .medium))

                    Button {
                        // Action for address tap if needed (e.g., open map)
                        print("Address tapped")
                    } label: {
                        Text(hotel.address)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue) // Link-like appearance
                    }

                    HStack(alignment: .bottom, spacing: 8) {
                         Text("от \(hotel.minimalPrice) ₽")
                            .font(.system(size: 30, weight: .semibold))
                         Text(hotel.priceForIt.lowercased())
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4) // Align baseline better
                    }

                }
                .padding(.horizontal)
                .padding(.vertical, 8) // Add some vertical padding
                .background(Color.white) // White background for this section
                .cornerRadius(15) // Rounded corners for the section


                 // --- Section 2: About the Hotel ---
                 VStack(alignment: .leading, spacing: 16) {
                    Text("Об отеле")
                        .font(.system(size: 22, weight: .medium))

                    // Peculiarities (Tags)
                    FlexibleGridView(data: hotel.peculiarities) { item in
                        Text(item)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color(UIColor.systemGray6)) // Tag background
                            .cornerRadius(5)
                    }


                    Text(hotel.description)
                         .font(.system(size: 16, weight: .regular))

                    // --- Detail Buttons ---
                    VStack(spacing: 0) {
                         NavigationLink(destination: AmenitiesView()) { // Navigate to Amenities
                             SectionRow(iconName: "face.smiling", title: "Удобства", subtitle: "Самое необходимое")
                         }
                         Divider().padding(.leading, 45) // Indent divider
                         SectionRow(iconName: "checkmark.circle", title: "Что включено", subtitle: "Основные услуги")
                         Divider().padding(.leading, 45)
                         SectionRow(iconName: "xmark.circle", title: "Что не включено", subtitle: "Дополнительные услуги")
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(15)
                    .padding(.top) // Add space before buttons


                 }
                 .padding(.horizontal)
                 .padding(.vertical, 8)
                 .background(Color.white)
                 .cornerRadius(15)
                 .padding(.top, 8) // Space between sections


            } // End Main VStack
        } // End ScrollView
        .background(Color(UIColor.systemGray6).ignoresSafeArea()) // Background for the whole screen
        .navigationBarTitleDisplayMode(.inline) // Keep title small
        .navigationBarBackButtonHidden(true)
       .toolbar { // Hide the default back button text
            ToolbarItem(placement: .principal) {
                 Text(hotel.name) // Or just "Отель"
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .safeAreaInset(edge: .bottom) {
             // --- Bottom Button ---
             NavigationLink(destination: RoomSelectionView(hotelName: hotel.name, rooms: rooms)) {
                  Text("К выбору номера")
                     .font(.system(size: 16, weight: .medium))
                     .foregroundColor(.white)
                     .frame(maxWidth: .infinity)
                     .padding()
                     .background(Color.blue)
                     .cornerRadius(15)
             }
             .padding(.horizontal)
             .padding(.top, 8) // Add space above button
             .background( // Add a white background behind the button area
                 Color.white
                    .ignoresSafeArea(edges: .bottom) // Extend white to screen bottom edge
             )
         }
    }
}

// MARK: - Image Carousel View

struct ImageCarouselView: View {
    let imageUrls: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<imageUrls.count, id: \.self) { index in
                Image(imageUrls[index]) // Assumes images are in Assets
                    .resizable()
                    .scaledToFill()
                    .tag(index)
                    // Add error handling/placeholder if needed
                    .overlay{
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("\(index + 1) / \(imageUrls.count)")
                                    .bold()
                                    .foregroundStyle(Color.white)
                                    .padding(.horizontal, 45)
                            }
                            .padding()
                        }
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // Hide default dots
        .overlay(
            // Custom Pagination Dots
            HStack(spacing: 8) {
                ForEach(0..<imageUrls.count, id: \.self) { index in
                    Circle()
                        .fill(selectedIndex == index ? Color.black : Color.gray.opacity(0.7))
                        .frame(width: 7, height: 7)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.9))
            .cornerRadius(5)
            .padding(.bottom, 10) // Position dots from bottom
            , alignment: .bottom // Align dots at the bottom
        )
    }
}

// MARK: - Section Row Helper View

struct SectionRow: View {
    let iconName: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.primary.opacity(0.9))

            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}


// MARK: - Amenities View (Placeholder)

struct AmenitiesView: View {
    var body: some View {
        ScrollView { // Make it scrollable in case content grows
            VStack {
                 Text("Details about Удобства")
                     .padding()
                 // Add actual amenity details here (Lists, Grids, etc.)
                 Spacer()
            }
        }
        .navigationTitle("Удобства") // Standard navigation title
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Room Selection View

struct RoomSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let hotelName: String
    let rooms: [Room]

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(rooms) { room in
                    RoomCardView(room: room)
                }
            }
            .padding(.vertical) // Add padding top/bottom inside scrollview
        }
        .navigationTitle("Номера")
      //  .navigationBarTitleDisplayMode(.inline)
        //----
        .navigationBarBackButtonHidden(true)
               .toolbar {
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button(action: {
                           // pop action, e.g., dismiss or navigation pop
                           dismiss()
                       }) {
                           HStack {
                               Image(systemName: "chevron.left")
                               Text(hotelName) // "Steigenberger Makadi"
                           }
                       }
                   }
               }
        //----
        .background(Color(UIColor.systemGray6).ignoresSafeArea()) // Match background
    }
}

// MARK: - Room Card View

struct RoomCardView: View {
    let room: Room
    @State private var selectedImageIndex = 0 // Each card manages its own carousel state

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ImageCarouselView(imageUrls: room.imageUrls, selectedIndex: $selectedImageIndex)
                 .frame(height: 200) // Adjust height
                 .clipShape(RoundedRectangle(cornerRadius: 15))

            Text(room.name)
                 .font(.system(size: 22, weight: .medium))

             // Peculiarities (Tags)
            FlexibleGridView(data: room.peculiarities) { item in
                Text(item)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(5)
            }

             // Room Price
             HStack(alignment: .bottom, spacing: 8) {
                  Text("\(room.price) ₽")
                     .font(.system(size: 30, weight: .semibold))
                  Text(room.pricePer.lowercased())
                     .font(.system(size: 16, weight: .regular))
                     .foregroundColor(.secondary)
                     .padding(.bottom, 4)
             }

             // Choose Room Button
            NavigationLink(destination:   BookingInfoView()) {
                 Text("Выбрать номер")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
         /*    Button {
                 // Action for selecting THIS specific room
                 print("Selected room: \(room.name)")
             } label: {
                   Text("Выбрать номер")
                      .font(.system(size: 16, weight: .medium))
                      .foregroundColor(.white)
                      .frame(maxWidth: .infinity)
                      .padding()
                      .background(Color.blue)
                      .cornerRadius(15)
             }*/

        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal) // Add horizontal space between cards and screen edge
    }
}


// MARK: - Flexible Grid View (Helper for Tags)

struct FlexibleGridView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0

    init(data: Data, spacing: CGFloat = 8, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }

            _FlexibleGrid(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}

struct _FlexibleGrid<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }

    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth

        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            remainingWidth -= (elementSize.width + spacing)
        }
        return rows
    }
}

// Helper to read view size
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

#Preview {
    ContentView()
}
