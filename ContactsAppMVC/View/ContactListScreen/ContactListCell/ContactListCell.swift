//
//  ContactListCell.swift
//  ContactsApp
//
//  Created by Maryan Pasichniak on 10/11/18.
//  Copyright © 2018 Maryan Pasichniak. All rights reserved.
//

import UIKit

class ContactListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    // MARK: Static
    static let nibName = "ContactListCell"
    static let reuseIdentifier = "ContactListCell"
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Public Methods
    func configureWith(_ input: Contact) {
        nameLabel.text = (input.firstName ?? "") + " " + (input.lastName ?? "")
        addressLabel.text = input.streetAddress1
        phoneLabel.text = input.phoneNumber
    }
}
