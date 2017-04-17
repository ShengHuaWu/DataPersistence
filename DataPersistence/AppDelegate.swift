//
//  AppDelegate.swift
//  DataPersistence
//
//  Created by ShengHua Wu on 16/04/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let database = Database()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        insertSeedData()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let tableViewController = TableViewController(database: database)
        let navigationController = UINavigationController(rootViewController: tableViewController)
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func insertSeedData() {
        let results = database.fetch(with: Book.all)
        guard results.count == 0 else {
            return
        }
        
        let many = [Book.bigLittleLies, Book.southAndWest, Book.fake]
        many.forEach { database.createOrUpdate(model: $0, with: BookObject.init) }
    }
}

