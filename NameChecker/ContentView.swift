//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var people: People

    var body: some View {
        NavigationView {
            List(self.people.items) { person in
                NavigationLink(destination: Text("\(person.name)")) {
                    VStack(alignment: .leading) {
                        Text("\(person.name)")
                    }
                }
            }
            .navigationBarTitle("Name Checker")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let people = People(items: [
        Person(name: "Person 1", imagePath: ""),
        Person(name: "Person 2", imagePath: ""),
        Person(name: "Person 3", imagePath: "")
    ])

    static var previews: some View {
        ContentView(people: people)
    }
}
