//
//  Book.swift
//  DataPersistence
//
//  Created by ShengHua Wu on 16/04/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation
import RealmSwift

struct Book {
    enum RatingScale: Int {
        case notRecommended = 0
        case mediocre
        case good
        case veryGood
        case outstanding
    }
    
    let bookID: String
    let name: String
    let comment: String?
    let rating: RatingScale
}

extension Book {
    init(object: BookObject) {
        guard let rating = RatingScale(rawValue: object.rating) else {
            fatalError("Rating is invalid")
        }
        
        self.bookID = object.bookID
        self.rating = rating
        self.name = object.name
        self.comment = object.comment
    }
}

// MARK: - Seed Data
extension Book {
    static let bigLittleLies = Book(bookID: "", name: "Big Little Lies", comment: "Awesome!!", rating: .outstanding)
    static let southAndWest = Book(bookID: "", name: "South and West", comment: nil, rating: .good)
    static let fake = Book(bookID: "", name: "Fake Book", comment: "This is a bad example.", rating: .notRecommended)
}
