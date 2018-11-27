//
//  StorageProtocol.swift
//  ContactsAppMVC
//
//  Created by Maryan Pasichniak on 11/27/18.
//  Copyright © 2018 Maryan Pasichniak. All rights reserved.
//

import Foundation

protocol StorageProtocol {
    func saveContact(contact: Contact)
    func deleteContact(contact: Contact)
}

