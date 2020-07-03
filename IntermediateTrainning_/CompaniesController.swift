//
//  ViewController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/2.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, AddCompanyDelegate {
    
    var companies: [Company] = []
    
    private func fetchCompanies() {
    
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        
    }
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        //!!!! important
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    func addCompany(company: Company) {
        companies.append(company)
        
        let newIndexPath = IndexPath(row: companies.count-1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func editCompany(company: Company) {
        // Potential bug here
        let row = companies.firstIndex(of: company)
        
        guard row != nil else {
            print("Succeed in guarding nil editted company")
            return
        }
        
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier:"cellId", for: indexPath)
        
        cell.backgroundColor = UIColor.tealColor
        
        let company = companies[indexPath.row]
        
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
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
        return editAction
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
}

