//
//  EmployeesController+TableView.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

extension EmployeesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .tealColor
        
        let employee = employees[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = .white
        
        if let birthday = employee.employeeInformation?.birthday {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let birthdayString = dateFormatter.string(from: birthday)
            
            cell.textLabel?.text = "\(employee.name ?? "") - \(birthdayString)"
        } else {
            cell.textLabel?.text = company?.name
        }
        
        return cell
    }
}
