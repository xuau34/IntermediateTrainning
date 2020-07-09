//
//  CompaniesAutoController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/9.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoController: UITableViewController, NSFetchedResultsControllerDelegate {
    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        // sectionNameKeyPath could be "name", so it will group by name
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do{
            try frc.performFetch()
        } catch let frcFetchErr {
            print( "fetchedResultsController in CompaniesAutoController failed on performFetch():", frcFetchErr)
        }
        return frc
    }()
    
    let cellId = "CompaniesAutoControllerCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.title = "Auto Companies"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
        
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControll.tintColor = .white
        self.refreshControl = refreshControll
    }
    
    @objc private func handleRefresh() {
        refreshControl?.beginRefreshing()
        Service.shared.downloadCompaniesFromServer()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesController = EmployeesController()
        employeesController.company = fetchedResultsController.object(at: indexPath)
        
        // different from present; push will show the previous page and back link, while present will give a blank new page
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    @objc private func handleAdd() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: context)
        company.name = "0"
        
        do {
            try context.save()
        } catch let saveErr {
            print("Failed on saving company in CompaniesAutoController:", saveErr)
        }
    }
    
    @objc private func handleDelete() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        //request.predicate = NSPredicate(format: "name CONTAINS %@", "0")
        do {
            let companies = try context.fetch(request)
            companies.forEach({(company) in
                context.delete(company)
            })
            do {
                try context.save()
            } catch let saveErr {
                print("Failed on saving context", saveErr)
            }
        } catch let fetchErr {
            print("Failed on fetching error", fetchErr)
        }
    }
}
