//
//  ViewController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/2.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController {

    let companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebook", founded: Date()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        setupNavigationStyle()
        
        
    }
    
    @objc func handleAddCompany() {
        print("Adding company..")
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
    
    func setupNavigationStyle() {
        
        
        navigationController?.navigationBar.backgroundColor = UIColor.lightRed
        navigationController?.navigationBar.barTintColor = UIColor.lightRed
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

