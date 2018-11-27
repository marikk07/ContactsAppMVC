//
//  ContactEditCell.swift
//  ContactsApp
//
//  Created by Maryan Pasichniak on 10/11/18.
//  Copyright © 2018 Maryan Pasichniak. All rights reserved.
//

import UIKit

class ContactEditCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inpuTextField: UITextField!
    
    var dataValue: String {
        return self.inpuTextField.text ?? ""
    }
    
    // MARK: Static
    static let nibName = "ContactEditCell"
    static let reuseIdentifier = "ContactEditCell"
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(_ vo: String) {
        self.titleLabel.text = vo
    }
    
}
