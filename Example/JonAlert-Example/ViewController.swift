//
//  ViewController.swift
//  JonAlert-Example
//
//  Created by Jonathan Martins on 02/09/2018.
//  Copyright © 2018 Surrey. All rights reserved.
//

import UIKit
import JonAlert

class ViewController: UIViewController {

    private let button1:UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Only Message", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let button2:UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Custom Icon Alert", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let button3:UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Success Alert", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let button4:UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Error Alert", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        
        button1.addTarget(self, action: #selector(showAlert)        , for: .touchUpInside)
        button2.addTarget(self, action: #selector(showCustomAlert)  , for: .touchUpInside)
        button3.addTarget(self, action: #selector(showSuccessAlert) , for: .touchUpInside)
        button4.addTarget(self, action: #selector(showErrorAlert)   , for: .touchUpInside)
    }
    
    private func setupConstraints(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        self.view.addSubview(button4)

        NSLayoutConstraint.activate([
            button1.heightAnchor.constraint(equalToConstant: 32),
            button1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:60),
            button1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button1.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/1.5),

            button2.widthAnchor  .constraint(equalTo: button1.widthAnchor),
            button2.heightAnchor .constraint(equalTo: button1.heightAnchor),
            button2.centerXAnchor.constraint(equalTo: button1.centerXAnchor),
            button2.topAnchor    .constraint(equalTo: button1.bottomAnchor, constant: 15),
            
            button3.widthAnchor  .constraint(equalTo: button1.widthAnchor),
            button3.heightAnchor .constraint(equalTo: button1.heightAnchor),
            button3.centerXAnchor.constraint(equalTo: button1.centerXAnchor),
            button3.topAnchor    .constraint(equalTo: button2.bottomAnchor, constant: 15),
            
            button4.widthAnchor  .constraint(equalTo: button1.widthAnchor),
            button4.heightAnchor .constraint(equalTo: button1.heightAnchor),
            button4.centerXAnchor.constraint(equalTo: button1.centerXAnchor),
            button4.topAnchor    .constraint(equalTo: button3.bottomAnchor, constant: 15),
        ])
    }
    
    @objc private func showAlert(){
        JonAlert.show(message: "Displaying simple message...")
    }
    
    @objc private func showCustomAlert(){
        JonAlert.show(message:  "Displaying custom alert...", andIcon: UIImage(named:"icon_favorite"))
    }
    
    @objc private func showSuccessAlert(){
        JonAlert.showSuccess(message: "Displaying success alert...")
    }
    
    @objc private func showErrorAlert(){
        JonAlert.showError(message: "Displaying error alert...")
    }

}

