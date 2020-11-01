//
//  UserViewController.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 8/30/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var myBooksButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtons()
    }
    
    private func setupButtons() {
        setButtonLayer(searchButton)
        setButtonLayer(myBooksButton)
        setButtonLayer(logOutButton)
        
        myBooksButton.addTarget(self, action: #selector(showAllBooks), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutAsUser), for: .touchUpInside)
    }
    
    private func setButtonLayer(_ button: UIButton) {
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    @objc func showAllBooks() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        let allBooksDataSource = BooksTableDataSource()
        
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        
        allBooksDataSource.refreshData { [weak self] in
            let allBooksTableVC = AllBooksTableViewController(dataSource: allBooksDataSource)
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self?.present(allBooksTableVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func logOutAsUser() {
        self.dismiss(animated: false, completion: nil)
    }
}
