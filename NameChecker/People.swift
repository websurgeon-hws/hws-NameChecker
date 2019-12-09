//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import Foundation

class People: ObservableObject {
    @Published var items = [Person]()
    
    func addPerson(_ person: Person) {
        items.append(person)
    }
}
