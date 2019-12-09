//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import UIKit

public struct FileManagerPeopleStore: PeopleStore {
    private let fileManager: FileManager
    
    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func savePeople(_ people: [Person], withName name: String) -> Result<URL, PeopleStoreSaveError> {
        guard let dir = getDocumentsDirectory() else {
             return .failure(.storeLocationNotFound)
        }

        do {
            let data = try JSONEncoder().encode(people)
            let url = dir.appendingPathComponent(name)
            try data.write(
                to: url,
                options: [
                    .atomicWrite,
                    .completeFileProtection
                ])

            return .success(url)
        } catch {
            return .failure(.unhandled(error: error))
        }
    }

    
        public func loadPeople(withName name: String) -> Result<[Person], PeopleStoreLoadError> {
            guard let dir = getDocumentsDirectory() else {
                 return .failure(.storeLocationNotFound)
            }


        do {
            let url = dir.appendingPathComponent(name)
            let data = try Data(contentsOf: url)

            let people = try JSONDecoder().decode([Person].self,
                                                  from: data)

            return .success(people)
        } catch {
            return .failure(.unhandled(error: error))
        }
    }
    
    private func getDocumentsDirectory() -> URL? {
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        return urls.first
    }
}

extension FileManager: PeopleStore {
    
    public func savePeople(_ people: [Person], withName name: String) -> Result<URL, PeopleStoreSaveError> {
        return FileManagerPeopleStore(fileManager: self)
            .savePeople(people, withName: name)
    }

    public func loadPeople(withName name: String) -> Result<[Person], PeopleStoreLoadError> {
        return FileManagerPeopleStore(fileManager: self)
            .loadPeople(withName: name)
    }
}
