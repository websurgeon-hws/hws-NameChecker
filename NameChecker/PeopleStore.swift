//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import Foundation

public enum PeopleStoreSaveError: Error {
    case noImageFound
    case storeLocationNotFound
    case unhandled(error: Error)
}

public enum PeopleStoreLoadError: Error {
    case storeLocationNotFound
    case noPeopleFound
    case unhandled(error: Error)
}

public protocol PeopleStore {
    func savePeople(
        _ people: [Person],
        withName name: String
    ) -> Result<URL, PeopleStoreSaveError>
    
    func loadPeople(
        withName name: String
    ) -> Result<[Person], PeopleStoreLoadError>
}
