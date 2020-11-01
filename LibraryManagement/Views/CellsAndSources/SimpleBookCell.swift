//
//  SearchCell.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 9/29/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import UIKit

class SimpleBookCell: UITableViewCell {
    private (set) var book: Book?
    override var reuseIdentifier: String? {
        return "BookCell"
    }
    
    func setBook(book: Book) {
        self.book = book
        
        let available = book.available ? "Yes" : "No"
        self.textLabel?.text = "Book ID: \(book.id) \n" + "Title: \(book.title) \n" + "Author: \(book.author) \n" + "Available: \(available)"
        self.textLabel?.numberOfLines = 4
    }
}


