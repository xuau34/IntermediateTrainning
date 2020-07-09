//
//  CompaniesAutoController+TableView.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/9.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

extension CompaniesAutoController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = fetchedResultsController.sections?[section].name
        label.backgroundColor = .lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkBlue
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    // potential bug: when open the section property of NSFetchedResultsController, it won't check below anymore
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        return count > 0 ? 0: 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        
        cell.company = self.fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(indexPath: indexPath), makeEditContextualAction(indexPath: indexPath)])
    }
    
    func makeDeleteContextualAction(indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, swipeButton, completionHandler) in
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            let company = self.fetchedResultsController.object(at: indexPath)
            
            context.delete( company )
            do {
                try context.save()
                
                // internal data must be deleted first because the table part will fire checking row number func immediately
                //self.companies.remove(at: indexPath.row)
                //self.tableView.deleteRows(at: [indexPath], with: .top)
                
                completionHandler(true)
            } catch let saveErr {
                print( "Saving the change to delete one company:", saveErr)
                
                completionHandler(false)
            }
        })
        
        deleteAction.backgroundColor = .lightRed
        
        return deleteAction
    }
    
    func makeEditContextualAction(indexPath: IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(action, swipeButton, completionHandler) in
            
            let editCompanyController = CreateCompanyController()
            let navController = CustomNavigationController(rootViewController: editCompanyController)
            editCompanyController.company = self.fetchedResultsController.fetchedObjects?[indexPath.row]
            //editCompanyController.delegate = self
            self.present(navController, animated: true, completion: nil)
        })
        
        editAction.backgroundColor = .darkBlue
        
        return editAction
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

}
