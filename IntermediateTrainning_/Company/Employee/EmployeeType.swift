//
//  EmployeeType.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/8.
//  Copyright © 2020 Mia. All rights reserved.
//

enum EmployeeType : String {
    case Executive
    case SeniorManagement = "Senior Management"
    case Staff
    
    static let allTypes = [Executive.rawValue,
                           SeniorManagement.rawValue,
                           Staff.rawValue]
}
