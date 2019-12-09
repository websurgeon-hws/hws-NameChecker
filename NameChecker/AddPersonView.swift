//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import SwiftUI

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var people: People
    @State private var personName: String = ""
    @State private var personImage: UIImage?
    @State private var showingImagePicker = false
    @State var image: Image?
    
    private var canSave: Bool {
        return !(personName.isEmpty || personImage == nil)
    }

    var body: some View {
        NavigationView {
            VStack {

                if image == nil {
                    Spacer()

                    Text("Tap to choose image")
                        .padding()
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                        .accessibility(addTraits: [.isButton])
                } else {
                    image?
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding()
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                        .accessibility(removeTraits: [.isImage])
                        .accessibility(addTraits: [.isButton])
                        .accessibility(label: Text("Tap to change image"))
                    
                    TextField("Enter Name", text: self.$personName)
                        .padding()
                }
                
                Spacer()
            }
            .navigationBarTitle("Add Person", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            , trailing:
                Button("Save") {
                    self.savePerson()
                }
                .disabled(!self.canSave)
            )
            .sheet(isPresented: $showingImagePicker,
                    onDismiss: handleChosenImage) {
                ImagePicker(image: self.$personImage)
            }
        }
    }
    
    private func handleChosenImage() {
        guard let uiImage = personImage else { return }

        image = Image(uiImage: uiImage)
    }
    
    private func savePerson() {
        print("SAVE PERSON")
                
        let person = Person(name: personName, imagePath: "")
        people.addPerson(person)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static let people = People(items: [
        Person(name: "Person 1", imagePath: ""),
        Person(name: "Person 2", imagePath: ""),
        Person(name: "Person 3", imagePath: "")
    ])
    
    static var previews: some View {
        AddPersonView(people: people)
    }
}
