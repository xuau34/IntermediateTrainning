//
//  CreateCompanyCtroller.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/2.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit
import CoreData

protocol AddCompanyDelegate {
    func addCompany(company: Company)
    func editCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    var delegate: AddCompanyDelegate?
    var company: Company?{
        didSet{
            nameTextField.text = company?.name
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // using ..Appear to change it everytime, whereas ..Load is for one time only
    override func viewWillAppear(_ animated: Bool) {
        
        if company == nil {
            navigationItem.title = "Create Company"
        } else {
            navigationItem.title = "Edit Company"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    private func setupUI() {
        let lightBlueBackground = UIView()
        lightBlueBackground.backgroundColor = .lightBlue
        lightBlueBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackground)
        lightBlueBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackground.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave(){
        guard (nameTextField.text != nil) else {
            return
        }
        
        if self.company == nil {
            handleCreateSave()
        } else {
            handleEditSave()
        }
        
        
        
    }
    
    private func handleEditSave() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        
        do {
            try context.save()
            
            // Upon successing saving into CoreData
            // equal to dismiss(animated:true, completion: { code })
            dismiss(animated: true){
                self.delegate?.editCompany(company: self.company!)
            }
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
    }
    
    private func handleCreateSave() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        
        do {
            try context.save()
            
            // Upon successing saving into CoreData
            // equal to dismiss(animated:true, completion: { code })
            dismiss(animated: true){
                self.delegate?.addCompany(company: company as! Company)
            }
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
    }
    
}
