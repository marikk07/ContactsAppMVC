//
//  ContactEditScreenViewController.swift
//  ContactsApp
//
//  Created by maryan on 11/10/2018.
//  Copyright © 2018 mp. All rights reserved.
//

import UIKit

class ContactEditScreenViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var inputContact: Contact?
    var visualObjects = ["First name:", "Last name:", "Phone:", "Address 1:", "Address 2:", "City:", "State:", "Zip Code:"]
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        setupView()
    }
    
    // MARK: - Private Methods
    private func registerNibs() {
        let userCellNib = UINib(nibName: ContactEditCell.nibName, bundle: nil)
        tableView.register(userCellNib, forCellReuseIdentifier: ContactEditCell.reuseIdentifier)
    }
    
    private func setupView() {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = inputContact == nil ? "New Contact" : "Editing Contact"
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let addButton = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(actionSaveButtonTouchUpInside(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func updateCellsWith(_ contact: Contact, cell: ContactEditCell, index: IndexPath) {
        var title = ""
        switch index.row {
        case 0:
            title = contact.firstName ?? ""
        case 1:
            title = contact.lastName ?? ""
        case 2:
            title = contact.phoneNumber ?? ""
        case 3:
            title = contact.streetAddress1 ?? ""
        case 4:
            title = contact.streetAddress2 ?? ""
        case 5:
            title = contact.city ?? ""
        case 6:
            title = contact.state ?? ""
        case 7:
            title = contact.zipCode ?? ""
        default: break
        }
        cell.inpuTextField.text = title
    }
    
    // MARK: - Actions
    @objc func actionSaveButtonTouchUpInside(_ sender: UIBarButtonItem) {
        guard   let firstNameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ContactEditCell,
                let lastNameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ContactEditCell,
                let phoneNumberCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ContactEditCell,
                let streetAddress1Cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? ContactEditCell,
                let streetAddress2Cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? ContactEditCell,
                let cityCell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? ContactEditCell,
                let stateCell = tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? ContactEditCell,
                let zipCodeCell = tableView.cellForRow(at: IndexPath(row: 7, section: 0)) as? ContactEditCell
        else { return }
        
        if let inputContact = inputContact {
            inputContact.firstName = firstNameCell.dataValue
            inputContact.lastName = lastNameCell.dataValue
            inputContact.phoneNumber = phoneNumberCell.dataValue
            inputContact.city = cityCell.dataValue
            inputContact.state = stateCell.dataValue
            inputContact.streetAddress1 = streetAddress1Cell.dataValue
            inputContact.streetAddress2 = streetAddress2Cell.dataValue
            inputContact.zipCode = zipCodeCell.dataValue
            CoreDataStack.shared.saveContact(contact: inputContact)
        } else {
            let contact = Contact(firstName: firstNameCell.dataValue, lastName: lastNameCell.dataValue, phoneNumber: phoneNumberCell.dataValue, streetAdress1: streetAddress1Cell.dataValue, streetAdress2: streetAddress2Cell.dataValue, city: cityCell.dataValue, state: stateCell.dataValue, zipCode: zipCodeCell.dataValue, context: CoreDataStack.shared.persistentContainer.viewContext)
            CoreDataStack.shared.saveContact(contact: contact)
        }
        _ =  self.navigationController?.popViewController(animated: true)
    }
}

extension ContactEditScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visualObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactEditCell.reuseIdentifier) as? ContactEditCell else { return UITableViewCell() }
        cell.configureWith(visualObjects[indexPath.row])
        if let contact = inputContact {
            updateCellsWith(contact, cell: cell, index: indexPath)
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
