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

extension Book {
    static let createOrUpdate: EntityDescriptor<Book, BookObject> = .createOrUpdate(reverseTransformer: BookObject.init)
    static let all: EntityDescriptor<[Book], BookObject> = .fetch(sortDescriptors: [SortDescriptor.name], transformer: { $0.map(Book.init) })
    
    var delete: EntityDescriptor<Book, BookObject> {
        return .delete(primaryKey: bookID)
    }
}
