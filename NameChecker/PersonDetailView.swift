//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import SwiftUI
import MapKit

struct PersonDetailView: View {
    let person: Person
    
    @State private var image: Image?
    @State private var errorMessage = ""
    @State private var showingMap = false
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var centerCoordinate = CLLocationCoordinate2D()

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
        .navigationBarItems(trailing:
            Button(action: {
                self.showingMap = true
            }) {
                Text("Location")
            }
            .disabled(self.person.locationInfo == nil)
        )
        .sheet(isPresented: self.$showingMap) {
            return self.mapView()
        }
    }
    
    private func mapView() -> AnyView? {
        guard let locationInfo = person.locationInfo else {
            return nil
        }

        DispatchQueue.main.async {
            self.centerCoordinate = locationInfo.coordinate
        }
        let annotation: MKPointAnnotation = locationInfo
        return AnyView(
            NavigationView {
                MapView(centerCoordinate: self.$centerCoordinate,
                        selectedPlace: self.$selectedPlace,
                        showingPlaceDetails: self.$showingPlaceDetails,
                        annotations: [annotation])
                    .navigationBarTitle("Where you met", displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: {
                            self.showingMap = false
                        }) {
                            Image(systemName: "xmark")
                                .padding()
                        }
                    )
            }
        )
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
        NavigationView {
            PersonDetailView(person: Person(name: "Test 1", imagePath: ""))
        }
    }
}
