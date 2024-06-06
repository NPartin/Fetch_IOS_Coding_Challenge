import Foundation

// Codable structure representing the main response from the API
struct MealsMain: Codable {
    var meals: [MealEntry]
}

// Codable structure representing a meal entry with an identifiable UUID
struct MealEntry: Codable, Identifiable {
    let id = UUID()
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}

// Codable structure representing a meal
struct Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

// Class responsible for fetching dessert data from the API
class DessertApiMain {
    // Function to fetch data from the given URL
    func getData(mealsURL: String, completion: @escaping ([MealEntry]) -> ()) {
        guard let url = URL(string: mealsURL) else { return }
        
        // Create a data task to fetch data from the URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                // Decode the JSON data into MealsMain object
                let meals = try JSONDecoder().decode(MealsMain.self, from: data)
                DispatchQueue.main.async {
                    // Filter out any meals with empty or null values
                    let filteredMeals = meals.meals.filter {
                        !$0.strMeal.isEmpty && !$0.strMealThumb.isEmpty && !$0.idMeal.isEmpty
                    }
                    // Complete with the filtered meals
                    completion(filteredMeals)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume() // Start the data task
    }
}

// Class responsible for fetching a selected meal's data from the API
class DessertSelectedApi {
    // Function to fetch data from the given URL
    func getData(url: String, completion: @escaping (Meal?) -> ()) {
        guard let url = URL(string: url) else { return }
        
        // Create a data task to fetch data from the URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                // Decode the JSON data into Meal object
                let mealSelected = try JSONDecoder().decode(Meal.self, from: data)
                // Check if the meal has any empty or null values
                if !mealSelected.strMeal.isEmpty && !mealSelected.strMealThumb.isEmpty && !mealSelected.idMeal.isEmpty {
                    DispatchQueue.main.async {
                        completion(mealSelected)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume() // Start the data task
    }
}
