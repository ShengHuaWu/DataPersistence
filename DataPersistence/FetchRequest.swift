//
//  FetchRequest.swift
//  DataPersistence
//
//  Created by ShengHua Wu on 17/04/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation
import RealmSwift

struct FetchRequest<Model, RealmObject: Object> {    
    let predicate: NSPredicate?
    let sortDescriptors: [SortDescriptor]
    let transformer: (Results<RealmObject>) -> Model
}

extension SortDescriptor {
    static let name = SortDescriptor(keyPath: "name", ascending: true)
}

extension Book {
    static let all = FetchRequest<[Book], BookObject>(predicate: nil, sortDescriptors: [SortDescriptor.name], transformer: { $0.map(Book.init) })
}
