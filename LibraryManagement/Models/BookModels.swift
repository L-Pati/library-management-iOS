//
//  BookSearchResponse.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 8/30/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import Foundation

public struct BookResponse: Codable {
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case books
    }
}

public struct Book: Codable {
    let id: Int
    let title: String
    let author: String
    let available: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case available
    }
}


