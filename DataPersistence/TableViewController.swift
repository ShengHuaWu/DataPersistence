//
//  TableViewController.swift
//  DataPersistence
//
//  Created by ShengHua Wu on 17/04/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    // MARK: - Private Properties
    private let database: Database
    fileprivate var books: [Book] = []
    
    // MARK: - Designated Initializer
    init(database: Database) {
        self.database = database

        super.init(style: .plain)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Books"
        
        books = database.fetch(with: Book.all)
    }
}

// MARK: - Table view data source
extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let book = books[indexPath.row]
        cell.textLabel?.text = book.name
        cell.detailTextLabel?.text = "\(book.rating.rawValue)"
        return cell
    }
}
