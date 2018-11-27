//
//  ContactListScreenViewController.swift
//  ContactsApp
//
//  Created by maryan on 11/10/2018.
//  Copyright © 2018 mp. All rights reserved.
//

import UIKit
import CoreData

class ContactListScreenViewController: UIViewController {


    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private var fetchController: NSFetchedResultsController<Contact> = {
        let fetchRequest = NSFetchRequest<Contact>(entityName: Contact.entityName)
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fethcController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: "firstName", cacheName: nil)
        return fethcController
    }()
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        setupView()
        fetchControllerFetch()
    }


    
    // MARK: - Private Methods
    private func registerNibs() {
        let userCellNib = UINib(nibName: ContactListCell.nibName, bundle: nil)
        tableView.register(userCellNib, forCellReuseIdentifier: ContactListCell.reuseIdentifier)
    }
    
    private func fetchControllerFetch() {
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
        } catch {
            debugPrint("Error while fetching objects")
        }
    }
    
    private func setupView() {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = "Contacts"
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAddButtonTouchUpInside(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    // MARK: - Actions
    @objc func actionAddButtonTouchUpInside(_ sender: UIBarButtonItem) {
        if let editViewController = storyboard?.instantiateViewController(withIdentifier: "ContactEditScreenViewController") as? ContactEditScreenViewController {
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
    }
}

extension ContactListScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactListCell.reuseIdentifier) as? ContactListCell else {
            return UITableViewCell()
        }
        let contact = fetchController.object(at: indexPath)
        cell.configureWith(contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contact = fetchController.object(at: indexPath)
        CoreDataStack.shared.deleteContact(contact: contact)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editViewController = storyboard?.instantiateViewController(withIdentifier: "ContactEditScreenViewController") as? ContactEditScreenViewController {
            let contact = fetchController.object(at: indexPath)
            editViewController.inputContact = contact
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
    }
}

extension ContactListScreenViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let safeIndexPath = newIndexPath {
                tableView.insertRows(at: [safeIndexPath], with: .automatic)
            }
        case .delete:
            if let safeIndexPath = indexPath {
                tableView.deleteRows(at: [safeIndexPath], with: .automatic)
            }
            
        case .update:
            if let safeIndexPath = indexPath {
                tableView.reloadRows(at: [safeIndexPath], with: .automatic)
            }
        case .move:
            if let safeIndexPath = indexPath, let safeNewIndexPath = newIndexPath {
                tableView.deleteRows(at: [safeIndexPath], with: .automatic)
                tableView.insertRows(at: [safeNewIndexPath], with: .automatic)
            }
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
