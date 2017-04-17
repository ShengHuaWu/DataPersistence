//
//  DatabaseTests.swift
//  DataPersistence
//
//  Created by ShengHua Wu on 16/04/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import XCTest
import RealmSwift
@testable import DataPersistence

class DatabaseTests: XCTestCase {
    // MARK: - Properties
    var database: Database!
    
    // MARK: - Overrider Methods
    override func setUp() {
        super.setUp()
        
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "com.shenghuawu.DataPersistence"))
        database = Database(realm: realm)
    }
    
    override func tearDown() {
        database.deleteAll()
        database = nil
        
        super.tearDown()
    }
    
    // MARK: - Enabled Tests
    func testBookCreation() {
        let newBook = Book.bigLittleLies
        
        database.createOrUpdate(model: newBook, with: BookObject.init)
        
        database.verifyBookCreationOrUpdating(newBook: newBook)
    }
    
    func testBookDeletion() {
        let newBook = Book.southAndWest
        database.createOrUpdate(model: newBook, with: BookObject.init)
        let bookInDB = database.fetch(with: Book.all).first!
        
        database.delete(type: BookObject.self, with: bookInDB.bookID)
        
        database.verifyBookDeletion()
    }
    
    func testBookUpdating() {
        let newBook = Book.fake
        database.createOrUpdate(model: newBook, with: BookObject.init)
        let bookInDB = database.fetch(with: Book.all).first!
        
        let modifiedBook = Book(bookID: bookInDB.bookID, name: "New Name", comment: "Change the rating and the name of this book.", rating: .mediocre)
        database.createOrUpdate(model: modifiedBook, with: BookObject.init)
        
        database.verifyBookCreationOrUpdating(newBook: modifiedBook)
    }
}

// MARK: - Verify
extension Database {
    func verifyBookCreationOrUpdating(newBook: Book, file: StaticString = #file, line: UInt = #line) {
        let results = fetch(with: Book.all)
        XCTAssertEqual(results.count, 1, "results count", file: file, line: line)
        
        let bookInDB = results.first!
        XCTAssert(bookInDB.bookID.characters.count > 0, "book ID is empty", file: file, line: line)
        XCTAssertEqual(bookInDB.name, newBook.name, "name", file: file, line: line)
        XCTAssertEqual(bookInDB.comment, newBook.comment, "comment", file: file, line: line)
        XCTAssertEqual(bookInDB.rating, newBook.rating, "rating", file: file, line: line)
    }
    
    func verifyBookDeletion(file: StaticString = #file, line: UInt = #line) {
        let results = fetch(with: Book.all)
        XCTAssertEqual(results.count, 0, "results count", file: file, line: line)
    }
}
