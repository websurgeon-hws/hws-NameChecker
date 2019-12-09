//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import Foundation

struct Person: Identifiable, Codable {
    let id = UUID()
    let name: String
    let imagePath: String
}
