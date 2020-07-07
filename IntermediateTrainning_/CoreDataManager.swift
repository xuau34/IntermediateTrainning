//
//  CoreDataManager.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/3.
//  Copyright © 2020 Mia. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "IntermediateTrainning")
        persistentContainer.loadPersistentStores{ ( storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return persistentContainer
    }()
    
    func fetchCompanies() -> [Company] {
    
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            return companies
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
    }
    
    func createEmployeeIntoCoreData(employeeName: String, birthday: Date, company: Company) -> (Employee?,Error?) {
        let context = persistentContainer.viewContext

        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.company = company
        employee.name = employeeName
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employee.employeeInformation = employeeInformation
        employeeInformation.birthday = birthday
        
        do {
            try context.save()
            return (employee, nil)
        } catch let saveErr {
            print("Failed to save company:", saveErr)
            return (nil, saveErr)
        }
    }
}
