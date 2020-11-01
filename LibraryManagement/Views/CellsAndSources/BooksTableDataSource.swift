//
//  BooksTableDataSource.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 9/29/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class BooksTableDataSource {
    private (set) var allBooks: [Book] = []
    
    public func refreshData(completion: @escaping (() -> Void)) {
        allBooks = []
        getAllBooks(completion: completion)
    }
    
    private func getAllBooks(completion: @escaping (() -> Void)) {
        NetworkingService.shared.getAllBooks(completion: { [weak self] books in
            books.books.forEach { [weak self] book in
                self?.allBooks.append(book)
            }
            
            completion()
        })
    }
    
    public func getHeaderLabel(_ title: String, overrideWidth: Bool = false) -> UILabel {
        let label = UILabel()
        
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if !overrideWidth {
            label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        }
        
        return label
    }
}
