//
//  ManageBooksTableViewController.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 10/4/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class ManageBooksTableViewController: UITableViewController {
    let dataSource: BooksTableDataSource!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    init(dataSource: BooksTableDataSource) {
        self.dataSource = dataSource
        super.init(style: .plain)
        setupCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCells() {
        self.tableView.register(SimpleBookCell.self, forCellReuseIdentifier: "BookCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = createHeaderView()
        return headerView
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        let label = dataSource.getHeaderLabel(ManageBooksStrings.manageBooks.rawValue, overrideWidth: true)
        let addButton = UIButton()
        let refreshButton = UIButton()
        
        headerView.backgroundColor = .darkGray
        
        addButton.addTarget(self, action: #selector(addBook), for: .touchUpInside)
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        addButton.backgroundColor = .darkGray
        
        refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.setTitleColor(.systemBlue, for: .normal)
        refreshButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        refreshButton.backgroundColor = .darkGray
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        headerView.addSubview(addButton)
        headerView.addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            refreshButton.heightAnchor.constraint(equalToConstant: 50),
            refreshButton.widthAnchor.constraint(equalToConstant: 70),
            refreshButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            label.leadingAnchor.constraint(equalTo: refreshButton.trailingAnchor)
        ])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row <= dataSource.allBooks.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? SimpleBookCell
        else {
            assertionFailure("unable to create cell")
            return UITableViewCell()
        }
        
        cell.setBook(book: dataSource.allBooks[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row <= dataSource.allBooks.count else {
            assertionFailure("Index out of range!")
            alertSomethingWentWrong()
            return
        }
        
        let book = dataSource.allBooks[indexPath.row]
        alertOptions(using: book)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.allBooks.count
    }
    
    private func alertOptions(using book: Book) {
        let title = ManageBooksStrings.deleteTitle.rawValue
        let message = ManageBooksStrings.deleteMessage.rawValue
        let no = ManageBooksStrings.no.rawValue
        let delete = ManageBooksStrings.delete.rawValue
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: no, style: .cancel)
        let deleteAction = UIAlertAction(title: delete, style: .destructive) { [weak self] (_) in
            self?.deleteBook(book)
        }
        
        alert.addAction(dismissAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
    private func deleteBook(_ book: Book) {
        activityIndicator.startAnimating()
        NetworkingService.shared.deleteBook(book: book) { [weak self] (success) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                success ? self?.alertSuccess() : self?.alertSomethingWentWrong()
            }
        }
    }
    
    private func alertSuccess() {
        let title = ManageBooksStrings.successTitle.rawValue
        let message = ManageBooksStrings.deleteBookSuccess.rawValue
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    private func alertSomethingWentWrong() {
        let title = ManageBooksStrings.errorTitle.rawValue
        let message = ManageBooksStrings.genericFailure.rawValue
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true)
    }
    
    @objc private func addBook() {
        let addVC = UIStoryboard(name: "AddBookViewController", bundle: Bundle(for: ManageBooksTableViewController.self)).instantiateViewController(identifier: "AddBookViewController") as! AddBookViewController
        self.present(addVC, animated: true)
    }
    
    @objc private func refreshData() {
        activityIndicator.startAnimating()
        
        NetworkingService.shared.getAllBooks { [weak self] (books) in
            guard !books.books.isEmpty else {
                assertionFailure("unable to load data again")
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.alertSomethingWentWrong()
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
}
