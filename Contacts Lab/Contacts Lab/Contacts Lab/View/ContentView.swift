//
//  ContentView.swift
//  Contacts Lab
//
//  Created by Alexandra Biryukova on 2/17/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var contactsViewModel = ContactsViewModel()
    @State var isActive = false
    
    @ViewBuilder
    var listView: some View {
        if contactsViewModel.contacts.isEmpty {
            VStack {
                Text("No contacts")
                    .padding(.top, 24)
                Spacer()
            }
        } else {
            List {
                ForEach(contactsViewModel.contacts) { contact in
                    ZStack {
                        ContactView(contact: contact)
                        NavigationLink(
                            destination: ContactDetailsView(contact: contact, completion: {
                                contact in
                                removeContact(contact: contact)
                            })) {
                        }.buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0)
                    }
                }.onDelete(perform: removeContact)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            listView
                .navigationBarTitle("Contacts", displayMode: .inline)
                .toolbar {
                    NavigationLink(
                        destination: AddContactView(completion: {
                            contact in
                            addContact(contact: contact)
                            isActive = false
                        }), isActive: $isActive) {
                        Image(systemName: "plus.circle")
                    }
                }
        }
    }
    
    private func removeContact(at indexSet: IndexSet) {
        contactsViewModel.contacts.remove(atOffsets: indexSet)
    }
    
    private func removeContact(contact: Contact) {
        guard let index = contactsViewModel.contacts.firstIndex(where: { $0 == contact }) else { return }
        contactsViewModel.contacts.remove(at: index)
    }
    
    private func addContact(contact: Contact) {
        contactsViewModel.contacts.append(contact)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //        ContentView()
        ContactDetailsView(contact: .init(name: "adsf", phoneNumber: "adsf", gender: .female), completion: {contact in print(contact)})
    }
}
