//
//  EmployeesController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController{
    
    var company: Company?
    let cellId = "EmployeeCell"
    let employeeTypes = EmployeeType.allTypes
    var allEmployees = [[Employee()]]
    
    func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        allEmployees = []
        for employeeType in EmployeeType.allTypes {
            allEmployees.append( companyEmployees.filter({ $0.type == employeeType }))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = company?.name
        setupPlusButtonInNavBar(selector: #selector(handleCreateEmployee))
        fetchEmployees()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func handleCreateEmployee() {
        let createEmployeeController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeeController)
        createEmployeeController.company = self.company
        createEmployeeController.addEmployeeDelegate = self
        present(navController, animated: true, completion: nil)
    }
    
}
