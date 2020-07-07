//
//  CreateEmployeeController.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

protocol AddEmployeeDelegate {
    func addEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var addEmployeeDelegate: AddEmployeeDelegate?
    var company: Company?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString( string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray] )
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString( string: "MM/dd/yyyy", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray] )
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupUI()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Employee"
        
        setupCancelButton()
        
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        
        setupUI()
    }
    
    @objc func handleSave() {
        guard let company = self.company else { return }
        guard let employeeName = nameTextField.text else { return }
        guard let birthdayString = birthdayTextField.text else { return }
        
        if birthdayString.isEmpty {
            presentAlert(title: "Empty birthday", message: "Please enter birthday.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayString) else {
            presentAlert(title: "Invalid birthday", message: "Please enter birthday in MM/dd/yyyy format.")
            return
        }
        
        
        let (employee, error) = CoreDataManager.shared.createEmployeeIntoCoreData(employeeName: employeeName, birthday: birthdayDate, company: company)
        if error == nil {
            dismiss(animated: true, completion: {
                self.addEmployeeDelegate?.addEmployee(employee: employee!)
            })
        }
    }
    
    private func setupUI() {
        _ = setupLightBlueBackground(height: 100)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true;
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true;
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
    }
    
    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
