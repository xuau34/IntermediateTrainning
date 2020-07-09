//
//  Service.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/9.
//  Copyright © 2020 Mia. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed on donwloadind data from server:", err)
                return
            }
            guard let data = data else { return }
            //let stringData = String(data: data, encoding: .utf8)
            
            let jsonDecoder = JSONDecoder()
            do{
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                let context = CoreDataManager.shared.persistentContainer.viewContext
                privateContext.parent = context //truly important
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                
                jsonCompanies.forEach({jsonCompany in
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    company.founded = foundedDate
                    
                    jsonCompany.employees?.forEach({ jsonEmployee in
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        let employee = Employee(context: privateContext)
                        employee.fullname = jsonEmployee.name
                        employee.employeeInformation?.birthday = birthdayDate
                        employee.type = jsonEmployee.type
                        employee.company = company
                    })
                })

                do {
                    try privateContext.save()
                    try context.save()
                } catch let saveErr {
                    print( "Failed on saving context in Service:", saveErr)
                }
            } catch let decodeErr {
                print( "Failed on decoding data:", decodeErr)
            }
        }.resume()
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let birthday: String
    let type: String
}
