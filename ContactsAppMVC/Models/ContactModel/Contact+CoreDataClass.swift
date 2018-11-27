//
//  Contact+CoreDataClass.swift
//  ContactsAppMVC
//
//  Created by Maryan Pasichniak on 11/25/18.
//  Copyright © 2018 Maryan Pasichniak. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Contact)
public class Contact: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case contactID
        case firstName
        case lastName
        case phoneNumber
        case streetAddress1
        case streetAddress2
        case city
        case state
        case zipCode
    }
    
    static var entityName: String {
        get { return String(describing: self) }
    }
    
    convenience init(firstName: String?, lastName: String?, phoneNumber: String?, streetAdress1: String?, streetAdress2: String?, city: String?, state: String?, zipCode: String?, context: NSManagedObjectContext) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {
            fatalError("Failed to decode Contact Model!")
        }
        self.init(entity: entity, insertInto: context)
        
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.streetAddress1 = streetAdress1
        self.streetAddress2 = streetAdress2
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.contactID = UUID().uuidString
    }
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext) else {
                fatalError("Failed to decode Contact model!")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contactID = try container.decodeIfPresent(String.self, forKey: .contactID)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.streetAddress1 = try container.decodeIfPresent(String.self, forKey: .streetAddress1)
        self.streetAddress2 = try container.decodeIfPresent(String.self, forKey: .streetAddress2)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contactID, forKey: .contactID)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(streetAddress1, forKey: .streetAddress1)
        try container.encode(streetAddress2, forKey: .streetAddress2)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zipCode, forKey: .zipCode)
    }
    
}

//MARK: - CodingUserInfoKey
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
