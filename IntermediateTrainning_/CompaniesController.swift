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
        print("Adding company..")
        
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
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
}

