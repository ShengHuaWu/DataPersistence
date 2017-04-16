//
//  BookObject.swift
//  DataPersistence
//
//  Created by ShengHua Wu on 16/04/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation
import RealmSwift

final class BookObject: Object {
    dynamic var bookID: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var comment: String? = nil
    dynamic var rating: Int = 0
    
    override static func primaryKey() -> String? {
        return "bookID"
    }
}

extension BookObject {
    convenience init(book: Book) {
        self.init()
        
        if book.bookID.characters.count > 0 {
            self.bookID = book.bookID
        }
        
        self.name = book.name
        self.comment = book.comment
        self.rating = book.rating.rawValue
    }
}
