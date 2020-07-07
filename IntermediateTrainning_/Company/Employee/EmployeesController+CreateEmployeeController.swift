//
//  EmployeesController+CreateEmployeeController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

extension EmployeesController: AddEmployeeDelegate {
    func addEmployee(employee: Employee) {
        employees.append(employee)
        
        let newIndexPath = IndexPath(row: employees.count-1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
