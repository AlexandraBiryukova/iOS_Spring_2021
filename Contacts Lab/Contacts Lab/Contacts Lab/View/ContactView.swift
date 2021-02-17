//
//  ContactView.swift
//  Contacts Lab
//
//  Created by Alexandra Biryukova on 2/18/21.
//

import SwiftUI

struct ContactView: View {
    enum ViewState {
        case item, details
    }
    
    private let contact: Contact
    private let viewState: ViewState
    
    init(contact: Contact, viewState: ViewState = .item) {
        self.contact = contact
        self.viewState = viewState
    }
    
    var body: some View {
        HStack(alignment: viewState == .details ? .top : .center) {
            contact.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: viewState == .details ? 120 : 80,
                       height: viewState == .details ? 120 : 80)
            Spacer()
            VStack(spacing: 8) {
                Text(contact.name)
                    .font(.system(size: 24, weight: .medium))
                Text(contact.phoneNumber)
                    .font(.system(size: 16))
            }
            Spacer()
        }
    }
}
