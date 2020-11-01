//
//  SearchTableViewController.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 8/30/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class AllBooksTableViewController: UITableViewController {
    let dataSource: BooksTableDataSource!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    init(dataSource: BooksTableDataSource) {
        self.dataSource = dataSource
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SimpleBookCell.self, forCellReuseIdentifier: "BookCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = dataSource.getHeaderLabel(AllBooksStrings.title.rawValue)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.allBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row <= dataSource.allBooks.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? SimpleBookCell
        else {
            assertionFailure("couldn't make cell")
            return UITableViewCell()
        }
        
        cell.setBook(book: dataSource.allBooks[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row <= dataSource.allBooks.count else {
            assertionFailure("index out of range")
            alertUnableToCheckOut()
            return
        }
        
        let selectedBook = dataSource.allBooks[indexPath.row]
        alertCheckoutBook(selectedBook)
    }
    
    private func alertCheckoutBook (_ book: Book) {
        let title = AllBooksStrings.checkoutTitle.rawValue
        let message = AllBooksStrings.checkoutMessage.rawValue
        let noActionTitle = AllBooksStrings.no.rawValue
        let yesActionTitle = AllBooksStrings.yes.rawValue
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let noAction = UIAlertAction(title: noActionTitle, style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: yesActionTitle, style: .default) { [weak self] (_) in
            self?.attemptCheckoutBook(book)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func attemptCheckoutBook(_ book: Book) {
        activityIndicator.startAnimating()
        
        NetworkingService.shared.checkOutBook(book) { [weak self] (success) in
            if success {
                self?.dataSource.refreshData(completion: {
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        self?.alertSuccess()
                        self?.tableView.reloadData()
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.alertUnableToCheckOut()
                }
            }
        }
    }
    
    private func alertSuccess() {
        let title = AllBooksStrings.successTitle.rawValue
        let message = AllBooksStrings.successMessage.rawValue
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func alertUnableToCheckOut() {
        let title = AllBooksStrings.error.rawValue
        let message = AllBooksStrings.tryAgain.rawValue
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
