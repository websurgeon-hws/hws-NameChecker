//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import Foundation

struct Person: Identifiable, Codable {
    let id: UUID
    let name: String
    let imagePath: String
    
    init(id: UUID? = nil, name: String, imagePath: String) {
        self.id = id ?? UUID()
        self.name = name
        self.imagePath = imagePath
    }
}

extension Person {
    static func imageNameFor(id: UUID) -> String {
        return "personImage-\(id.uuidString)"
    }
    
    var imageName: String {
        return Person.imageNameFor(id: id)
    }
}
