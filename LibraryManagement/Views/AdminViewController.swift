//
//  AdminViewController.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 8/30/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
    @IBOutlet weak var manageBooks: UIButton!
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var addBookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    private func setupButtons() {
        logOut.addTarget(self, action: #selector(logOutAsAdmin), for: .touchUpInside)
        manageBooks.addTarget(self, action: #selector(openManageBooks), for: .touchUpInside)
        
        setButtonLayer(manageBooks)
        setButtonLayer(logOut)
        setButtonLayer(addBookButton)
    }
    
    private func setButtonLayer(_ button: UIButton) {
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    @objc private func logOutAsAdmin() {
        self.dismiss(animated: false)
    }
    
    @objc private func openManageBooks() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        let dataSource = BooksTableDataSource()
        let manageBooksVC = ManageBooksTableViewController(dataSource: dataSource)
        
        activityIndicator.startAnimating()
        dataSource.refreshData {
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.present(manageBooksVC, animated: true)
            }
        }
    }
}
