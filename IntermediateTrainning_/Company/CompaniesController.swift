//
//  ViewController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/2.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies: [Company] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companies = CoreDataManager.shared.fetchCompanies()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        /*
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 20, width: 10, height: 50)
        */
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "AddCompanies", style: .plain, target: self, action: #selector(handleAddCompanies)),
            UIBarButtonItem(title: "Updates", style: .plain, target: self, action: #selector(handleUpdates)),
            UIBarButtonItem(title: "Updates2", style: .plain, target: self, action: #selector(handleUpdates2))
        ]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesController = EmployeesController()
        employeesController.company = companies[indexPath.row]
        
        // different from present; push will show the previous page and back link, while present will give a blank new page
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    // can't handle quitely when there're too many cells/companies in the table
    @objc private func handleReset() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let deleteBatchRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest() )
        
        do {
            try context.execute(deleteBatchRequest)
            
            var indexPathToDelete = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToDelete.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToDelete, with: .top)
            
        } catch let delErr {
            print( "Failed on requesting deleting core data", delErr )
        }
    }
    
    @objc private func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        //!!!! important
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func handleAddCompanies() {
        /* CoreData will crash for the latter fetch is not thread-safe
        DispatchQueue.global(qos: .background).async {
            ...
        }
        */
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...1000).forEach{ value in
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    // to updates the companies stored in this view
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let saveErr {
                print( "Failed on saving context:", saveErr)
            }
        })
    }
    
    @objc private func handleUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do{
                let companies = try backgroundContext.fetch(request)
                companies.forEach({(company) in
                    company.name = "A: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        // in order to make sure they fetch before completion of save, and after reset, we must refetch our data again, for it will lose all
                        // heavy work and some might be redundant for it might not actually be changed
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let saveErr {
                    print( "Failed on saving context:", saveErr)
                }
            } catch let fetchErr {
                print("Failed on fetching companies:", fetchErr)
            }
        })
    }
    
    @objc private func handleUpdates2() {
        print( "Trying to handle update 2~")
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        do{
            let companies = try privateContext.fetch(request)
            companies.forEach({(company) in
                company.name = "B: \(company.name ?? "")"
            })
            
            do {
                try privateContext.save()

                // have another do and catch can let you have custom err resolution, and ?
                let context = CoreDataManager.shared.persistentContainer.viewContext
                if context.hasChanges {
                    try context.save()
                }
                self.tableView.reloadData()
                
            } catch let saveErr {
                print( "Failed on saving context:", saveErr)
            }
        } catch let fetchErr {
            print("Failed on fetching companies:", fetchErr)
        }
    }
}

