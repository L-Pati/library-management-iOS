//
//  AddBookViewController.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 10/5/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupForm()
    }
    
    func setupForm() {
        addButton.layer.cornerRadius = 8.0
        addButton.addTarget(self, action: #selector(addBook), for: .touchUpInside)
    }
    
    @objc func addBook() {
        guard
            let title = titleField.text,
            let author = authorField.text
        else {
            assertionFailure("unable to capture text")
            return
        }
        
        let book = Book(id: 0, title: title, author: author, available: true)
        
        NetworkingService.shared.addBook(book) { [weak self] (success) in
            guard let self = self else { return }
            success ? self.alertSuccess() : self.alertFailure()
        }
    }
    
    private func alertSuccess() {
        let alert = UIAlertController(title: AddBooksStrings.success.rawValue, message: AddBooksStrings.successMessage.rawValue, preferredStyle: .alert)
        let addAnother = UIAlertAction(title: AddBooksStrings.addAnother.rawValue, style: .cancel) { [weak self] (_) in
            self?.titleField.text = "Title"
            self?.authorField.text = "Author"
        }
        
        let done = UIAlertAction(title: AddBooksStrings.done.rawValue, style: .default) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(addAnother)
        alert.addAction(done)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func alertFailure() {
        let alert = UIAlertController(title: AddBooksStrings.failure.rawValue, message: AddBooksStrings.failureMessage.rawValue, preferredStyle: .alert)
        let ok = UIAlertAction(title: AddBooksStrings.ok.rawValue, style: .cancel, handler: nil)
        
        alert.addAction(ok)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
