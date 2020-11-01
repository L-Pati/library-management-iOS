//
//  NetworkingService.swift
//  LibraryManagement
//
//  Created by Lauren Sickels on 8/30/20.
//  Copyright © 2020 Lauren Pati. All rights reserved.
//

import Foundation

class NetworkingService {
    public static let shared = NetworkingService()
    
    let configuraiton = URLSessionConfiguration.default
    let urlSession: URLSession
    private let baseURL = "http://localhost:8080/books/"
    
    private init() {
        urlSession = URLSession(configuration: configuraiton)
    }
    
    public func getAllBooks(completion: @escaping((BookResponse) -> Void)) {
        guard let url = URL(string: baseURL) else {
            assertionFailure("unable to create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard
                let books = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                completion(BookResponse(books: []))
                return
            }
            
            do {
                let decodedBooks = try JSONDecoder().decode(BookResponse.self, from: books)
                completion(decodedBooks)
            } catch {
                completion(BookResponse(books: []))
                assertionFailure("decoding error!")
            }
        }.resume()
    }
    
    public func addBook(_ book: Book, completion: @escaping ((Bool) -> Void)) {
        guard
            let url = URL(string: baseURL),
            let encodedBook = try? JSONEncoder().encode(book)
        else {
            assertionFailure("unable to make URl")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.post.rawValue
        urlRequest.httpBody = encodedBook
        urlRequest.addValue("application/json;odata=verbose", forHTTPHeaderField: "Content-Type")
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                completion(false)
                return
            }
            
            completion(true)
        }.resume()
    }
    
    public func deleteBook(book: Book, completion: @escaping((Bool) -> Void)) {
        guard
            let url = URL(string: baseURL),
            let encryptedBook = try? JSONEncoder().encode(book)
        else {
            assertionFailure("could not delete book!")
            completion(false)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.delete.rawValue
        urlRequest.httpBody = encryptedBook
        urlRequest.addValue("application/json;odata=verbose", forHTTPHeaderField: "Content-Type")
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                assertionFailure("couldn't delete book")
                completion(false)
                return
            }
            
            completion(true)
        }.resume()
    }
    
    public func search(for query: String, completion: @escaping((BookResponse?) -> Void)) {
        let urlString = baseURL + "search/" + query
        
        guard let url = URL(string: urlString) else {
            assertionFailure("unable to make URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard
                let books = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                completion(nil)
                return
            }
            
            do {
                let decodedBooks = try JSONDecoder().decode(BookResponse.self, from: books)
                completion(decodedBooks)
            } catch {
                completion(nil)
                assertionFailure("decoding error!")
            }
        }.resume()
    }
    
    public func checkOutBook(_ book: Book, completion: @escaping ((Bool) -> Void)) {
        let urlString = baseURL + "checkout/" + "\(book.id)"
        
        guard let url = URL(string: urlString) else {
            assertionFailure("unable to make URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.put.rawValue
        
        urlSession.dataTask(with: urlRequest) { _, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                completion(false)
                return
            }
            
            completion(true)
        }.resume()
    }
    
    public func returnBook(_ book: Book, completion: @escaping ((Bool) -> Void)) {
        let urlString = "checkout/" + "\(book.id)"
        
        guard let url = URL(string: urlString) else {
            assertionFailure("unable to make URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.put.rawValue
        
        
        urlSession.dataTask(with: urlRequest) { _, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                completion(false)
                return
            }
            
            completion(true)
        }.resume()
    }
}
