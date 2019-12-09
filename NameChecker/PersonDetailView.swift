//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import SwiftUI

struct PersonDetailView: View {
    let person: Person
    
    @State private var image: Image?
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            if image == nil && errorMessage.isEmpty {
                Text("Loading...")
            } else if image == nil {
                Text("No image found")
            } else {
                image?
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .onAppear(perform: loadImage)
        .navigationBarTitle(person.name)
    }
    
    func loadImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = FileManager.default.loadImage(withName: self.person.imageName)
            DispatchQueue.main.async {
                switch result {
                case let .success(uiImage):
                    self.image = Image(uiImage: uiImage)
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailView(person: Person(name: "Test 1", imagePath: ""))
    }
}
