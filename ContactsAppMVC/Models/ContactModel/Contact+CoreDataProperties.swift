//
//  Contact+CoreDataProperties.swift
//  ContactsAppMVC
//
//  Created by Maryan Pasichniak on 11/25/18.
//  Copyright © 2018 Maryan Pasichniak. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var city: String?
    @NSManaged public var contactID: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var state: String?
    @NSManaged public var streetAddress1: String?
    @NSManaged public var streetAddress2: String?
    @NSManaged public var zipCode: String?

}
