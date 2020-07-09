//
//  CustomMigration.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/9.
//  Copyright © 2020 Mia. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    @objc func trasformIntNumOfEmployeesToString(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        }
        return "large"
    }
}
