import SwiftUI

struct DessertImage: View {
    var imageLink: String
    @State private var dessertSprite: UIImage? = nil // State variable to hold the downloaded or cached image
    
    var body: some View {
        ZStack {
            if let image = dessertSprite {
                // Display the image if available
                Image(uiImage: image)
                    .resizable()
            } else {
                // Display a progress view as a placeholder while the image is loading
                ProgressView()
            }
        }
        .onAppear {
            loadDessertImage()
        }
    }
    
    // Load the dessert image
    func loadDessertImage() {
        if let cachedImage = ImageCache.shared.getImage(forKey: imageLink) {
            // Use the cached image if available
            dessertSprite = cachedImage
        } else {
            // Download the image if not in cache
            downloadDessertImage()
        }
    }
    
    // Download the image from the provided URL
    func downloadDessertImage() {
        guard let url = URL(string: imageLink) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle any errors that occur during image download
            guard let data = data, let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Cache the downloaded image
            ImageCache.shared.setImage(image, forKey: imageLink)
            // Update the state variable with the downloaded image on the main thread
            DispatchQueue.main.async {
                self.dessertSprite = image
            }
        }.resume() // Start the data task
    }
}

// Preview
struct DessertImage_Previews: PreviewProvider {
    static var previews: some View {
        DessertImage(imageLink: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg") // Sample image (Apam Balik)
    }
}
