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

class CreateCompanyController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var delegate: AddCompanyDelegate?
    var company: Company?{
        didSet{
            nameTextField.text = company?.name
            if let founded = company?.founded {
                datePicker.date = founded
            }
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            setupCircularImageStyle()
        }
    }
    
    // translatesAutoresizingMaskIntoConstraints == false - allows the components to adjust shapes when the screen is rotated
    
    // to target oneself, one must be set as lazy var. This ensures it'll always has an instance
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill //to not get padding or any empty
        
        // Actions/Events
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        
        return imageView
    }()
    
    private func setupCircularImageStyle(){
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
    
    @objc func handleSelectPhoto() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let oriImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = oriImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.setValue(UIColor.black, forKeyPath: "textColor")
        return dp
    }()
    
    // using ..Appear to change it everytime, whereas ..Load is for one time only
    override func viewWillAppear(_ animated: Bool) {
        
        if company == nil {
            navigationItem.title = "Create Company"
        } else {
            navigationItem.title = "Edit Company"
            nameTextField.text = company?.name
            if let founded = company?.founded {
                datePicker.date = founded
            }
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
        lightBlueBackground.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true;
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackground.bottomAnchor).isActive = true
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
        company?.founded = datePicker.date
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.setValue( imageData, forKey: "imageData")
        }
        
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
        company.setValue(datePicker.date, forKey: "founded")
        
        // Potential Bug
        // float for the persentage quality it's gonna reserve
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue( imageData, forKey: "imageData")
        }
        
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
