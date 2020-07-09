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
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        navigationItem.title = "Auto Companies"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
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
}
