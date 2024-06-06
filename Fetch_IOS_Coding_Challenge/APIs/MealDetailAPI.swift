//
//  MealDetailAPI.swift
//  FetchIOSCodingChallenge
//
//  Created by Timothy Partin on 6/3/24.
//
import Foundation

// Decodable structure representing the main response from the API
struct MealDetailResponse: Decodable {
    var meals: [DessertDetail]
}

// Decodable structure representing a meal detail with an identifiable UUID
struct DessertDetail: Decodable, Identifiable {
    let id = UUID() // Generates a unique identifier for each meal detail
    var idMeal: String // ID of the meal
    var strMeal: String // Name of the meal
    var strCategory: String // Category of the meal
    var strArea: String // Area of the meal
    var strInstructions: String // Instructions for preparing the meal
    var strMealThumb: String // Thumbnail image URL of the meal
    var strTags: String? // Tags associated with the meal, optional
    var strIngredients: [String] = [] // Array to hold the ingredients
    var strMeasures: [String] = [] // Array to hold the measures

    // Decoding from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strTags = try? container.decode(String?.self, forKey: .strTags)
        
        // Dynamically decode ingredients and measures
        strIngredients = try Self.decodeDynamicFields(container: container, prefix: "strIngredient")
        strMeasures = try Self.decodeDynamicFields(container: container, prefix: "strMeasure")
    }

    // Function to dynamically decode fields with a given prefix
    private static func decodeDynamicFields(container: KeyedDecodingContainer<CodingKeys>, prefix: String) throws -> [String] {
        var results = [String]()
        var index = 1
        while true {
            let key = CodingKeys(stringValue: "\(prefix)\(index)")
            if let key = key, // Ensure key is valid
               let value = try container.decodeIfPresent(String.self, forKey: key), // Decode value if present
               !value.isEmpty { // Ensure value is not empty
                results.append(value)
            } else {
                break
            }
            index += 1
        }
        return results
    }

    // Coding keys to map JSON keys to properties
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strCategory, strArea, strInstructions, strMealThumb, strTags
        // Ingredient and measure keys
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
}

// Class responsible for fetching meal detail data from the API
class DessertDetailApi {
    // Function to fetch meal detail data from the given URL
    func getData(mealID: String, completion: @escaping (DessertDetail?) -> ()) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        guard let url = URL(string: urlString) else { return }

        // Create a data task to fetch data from the URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            guard let data = data else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                // Decode the JSON data into MealDetailResponse object
                let mealDetailResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
                // Execute completion handler with the first meal detail
                DispatchQueue.main.async {
                    completion(mealDetailResponse.meals.first)
                }
            } catch {
                // Handle decoding errors
                print("Error decoding data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume() // Start the data task
    }
}
