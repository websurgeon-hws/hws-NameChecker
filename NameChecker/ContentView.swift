//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var people: People
    @State private var showingAddPerson = false
    
    var body: some View {
        NavigationView {
            List(self.people.items) { person in
                NavigationLink(destination:
                    PersonDetailView(person: person)
                ) {
                    VStack(alignment: .leading) {
                        Text("\(person.name)")
                    }
                }
            }
            .navigationBarTitle("Name Checker")
            .navigationBarItems(trailing: Button(action: {
                self.showingAddPerson = true
            }) {
                Image(systemName: "plus")
                    .padding()
            })
            .sheet(isPresented: self.$showingAddPerson) {
                AddPersonView(people: self.people)
            }
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
