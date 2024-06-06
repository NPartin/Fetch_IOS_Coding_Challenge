//
//  ContentView.swift
//  FetchIOSCodingChallenge
//
//  Created by Timothy Partin on 6/3/24.
//
import SwiftUI

struct DessertsView: View {
    @State private var desserts: [MealEntry] = [] // State variable to hold the list of desserts
    @State private var searchText: String = "" // State variable to hold the search text
    
    // Computed property to filter desserts based on the search text
    var filteredDesserts: [MealEntry] {
        if searchText.isEmpty {
            return desserts
        } else {
            return desserts.filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search for a dessert", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Style the text field with rounded border
                    .padding()
                
                // List to display filtered desserts
                List(filteredDesserts) { dessert in
                    // Navigation link to detail view
                    NavigationLink(destination: DessertDetailView(mealID: dessert.idMeal)) {
                        HStack {
                            // Dessert image
                            DessertImage(imageLink: dessert.strMealThumb)
                                .frame(width: 75, height: 75)
                                .clipShape(Rectangle()).cornerRadius(25) // Style the image with a rectangular shape and rounded corners
                                .padding(.vertical, 5)
                            
                            // Dessert name
                            Text(dessert.strMeal)
                                .font(.headline) // Set font to headline
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("Desserts") // Set navigation title
                .onAppear {
                    loadDesserts() // Load desserts when the view appears
                }
            }
        }
    }
    
    // Function to load desserts from the API
    func loadDesserts() {
        let mealsURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert" // API endpoint
        DessertApiMain().getData(mealsURL: mealsURL) { meals in
            self.desserts = meals // Update the state variable with the fetched meals
            // Preload images
            for meal in meals {
                if let url = URL(string: meal.strMealThumb) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, let image = UIImage(data: data) else { return }
                        ImageCache.shared.setImage(image, forKey: meal.strMealThumb) // Cache the preloaded images
                    }.resume() // Start the data task
                }
            }
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DessertsView()
    }
}
