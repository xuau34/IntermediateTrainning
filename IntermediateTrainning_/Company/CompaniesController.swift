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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesController = EmployeesController()
        employeesController.company = companies[indexPath.row]
        
        // different from present; push will show the previous page and back link, while present will give a blank new page
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    @objc func handleReset() {
        
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
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        //!!!! important
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
}

