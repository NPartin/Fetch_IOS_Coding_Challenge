import SwiftUI

// View to display the details of a selected meal
struct DessertDetailView: View {
    var mealID: String // ID of the meal to fetch details for
    @State private var mealDetail: DessertDetail? // State variable to hold the meal details
    
    var body: some View {
        VStack {
            // Check if meal details are available
            if let mealDetail = mealDetail {
                ScrollView {
                    VStack(alignment: .leading) {
                        // Display the meal image
                        DessertImage(imageLink: mealDetail.strMealThumb)
                            .frame(height: 350)
                            .clipped()
                        
                        // Display the meal name
                        Text(mealDetail.strMeal)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.vertical, 5)
                        
                        // Display the category of the meal
                        Text("Category: \(mealDetail.strCategory)")
                            .font(.headline)
                            .padding(.vertical, 5)
                        
                        // Display the area of the meal
                        Text("Area: \(mealDetail.strArea)")
                            .font(.headline)
                            .padding(.vertical, 5)
                        
                        // Display tags if available
                        if let tags = mealDetail.strTags {
                            Text("Tags: \(tags)")
                                .font(.subheadline)
                                .padding(.vertical, 5)
                        }
                        
                        // Display the instructions header
                        Text("Instructions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                        
                        ForEach(formattedInstructions(from: mealDetail.strInstructions), id: \.self) { paragraph in
                            Text(paragraph)
                                .padding(.top, 5)
                        }
                        
                        // Display ingredients and measures
                        if !mealDetail.strIngredients.isEmpty {
                            Text("Ingredients")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.top, 10)
                            
                            ForEach(Array(zip(mealDetail.strIngredients, mealDetail.strMeasures)), id: \.0) { ingredient, measure in
                                Text("\(ingredient): \(measure)")
                                    .padding(.top, 2)
                            }
                        }
                    }
                    .padding()
                }
            } else {
                // Show a progress view while loading meal details
                ProgressView()
                    .onAppear {
                        loadMealDetail() // Load meal details when the view appears
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Format instuctions into a numbered list
    func formattedInstructions(from instructions: String) -> [String] {
        return instructions
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .enumerated()
            .map { "\($0 + 1). \($1)" }
    }
    
    // Load meal details from the API
    func loadMealDetail() {
        DessertDetailApi().getData(mealID: mealID) { mealDetail in
            self.mealDetail = mealDetail // Update the state variable with the fetched meal details
        }
    }
}

// Preview
struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DessertDetailView(mealID: "53049") // Preview with a sample (Apam Balik)
    }
}
