//
//  EmployeesController+CreateEmployeeController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

extension EmployeesController: AddEmployeeDelegate {
    func didAddEmployee(employee: Employee) {
        let section = employeeTypes.firstIndex(of: employee.type ?? "Staff") ?? 0
        allEmployees[section].append(employee)
        
        let newIndexPath = IndexPath(row: allEmployees[section].count-1, section: section)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
