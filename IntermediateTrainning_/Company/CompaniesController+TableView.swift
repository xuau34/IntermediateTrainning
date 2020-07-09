//
//  CompaniesController+TableView.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

extension CompaniesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count > 0 ? 0: 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for: indexPath) as! CompanyCell
        
        cell.company = companies[indexPath.row]
        
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
            
            context.delete( self.companies[indexPath.row] )
            do {
                try context.save()
                
                // internal data must be deleted first because the table part will fire checking row number func immediately
                self.companies.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .top)
                
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
            editCompanyController.company = self.companies[indexPath.row]
            editCompanyController.delegate = self
            self.present(navController, animated: true, completion: nil)
        })
        
        editAction.backgroundColor = .darkBlue
        
        return editAction
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
}
