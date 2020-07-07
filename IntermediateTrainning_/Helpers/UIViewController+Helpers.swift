//
//  UIViewController+Helpers.swift
//  IntermediateTrainning_
//
//  Created by 李宓2號 on 2020/7/7.
//  Copyright © 2020 Mia. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupSaveButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackground(height: CGFloat) -> UIView {
        let lightBlueBackground = UIView()
        lightBlueBackground.backgroundColor = .lightBlue
        lightBlueBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackground)
        lightBlueBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackground.heightAnchor.constraint(equalToConstant: height).isActive = true
        return lightBlueBackground
    }
}
