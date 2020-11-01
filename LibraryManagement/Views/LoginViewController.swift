//
//  ViewController.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 8/30/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtons()
    }

    private func setupButtons() {
        setButtonLayer(adminButton)
        setButtonLayer(userButton)
    }
    
    private func setButtonLayer(_ button: UIButton) {
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
}

