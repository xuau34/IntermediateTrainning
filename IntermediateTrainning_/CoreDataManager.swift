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
        let persistentContainer = NSPersistentContainer(name: "CompanyModel")
        persistentContainer.loadPersistentStores{ ( storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return persistentContainer
    }()
}
