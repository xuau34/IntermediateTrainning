//
//  CompaniesController+CreateCompanyController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

extension CompaniesController: AddCompanyDelegate{
    func addCompany(company: Company) {
        companies.append(company)
        
        let newIndexPath = IndexPath(row: companies.count-1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func editCompany(company: Company) {
        // Potential bug here
        let row = companies.firstIndex(of: company)
        
        guard row != nil else {
            print("Succeed in guarding nil editted company")
            return
        }
        
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .automatic)
        
    }
}
