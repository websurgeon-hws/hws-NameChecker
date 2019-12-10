//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import Foundation
import MapKit

public struct Person: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let imagePath: String
    public let locationInfo: CodableMKPointAnnotation?
    
    public init(id: UUID? = nil,
                name: String,
                imagePath: String,
                location: CLLocationCoordinate2D? = nil) {
        self.id = id ?? UUID()
        self.name = name
        self.imagePath = imagePath
        let annotation = CodableMKPointAnnotation()
        if let location = location {
            annotation.title = name
            annotation.coordinate = location
            self.locationInfo = annotation
        } else {
            self.locationInfo = nil
        }
    }
}

extension Person {
    public static func imageNameFor(id: UUID) -> String {
        return "personImage-\(id.uuidString)"
    }
    
    public var imageName: String {
        return Person.imageNameFor(id: id)
    }
}

extension People {
    func savePeople(completion: ((Result<URL, PeopleStoreSaveError>) -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = FileManager.default.savePeople(self.items, withName: "People")
            DispatchQueue.main.async {
                print("SAVE PEOPLE RESULT: \(result)")
                completion?(result)
            }
        }
    }
    
    func loadPeople(completion: ((Result<[Person], PeopleStoreLoadError>) -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = FileManager.default.loadPeople(withName: "People")
            DispatchQueue.main.async {
                switch result {
                case .failure: break
                case let .success(people):
                    self.items = people
                }
                print("LOAD PEOPLE RESULT: \(result)")
                completion?(result)
            }
        }
    }
}
