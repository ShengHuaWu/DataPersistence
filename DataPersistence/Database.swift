//
//  Database.swift
//  DataPersistence
//
//  Created by ShengHua Wu on 16/04/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation
import RealmSwift

final class Database {
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    func createOrUpdate<Model, RealmObject>(model: Model, with descriptor: EntityDescriptor<Model, RealmObject>) {
        let object = descriptor.reverseTransformer(model)
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    func fetch<Model, RealmObject>(with descriptor: EntityDescriptor<Model, RealmObject>) -> Model {
        var results = realm.objects(RealmObject.self)
        
        if descriptor.sortDescriptors.count > 0 {
            results = results.sorted(by: descriptor.sortDescriptors)
        }
        
        return descriptor.transformer(results)
    }
    
    func delete<Model, RealmObject>(with descriptor: EntityDescriptor<Model, RealmObject>) {
        let object = realm.object(ofType: RealmObject.self, forPrimaryKey: descriptor.primaryKey)
        if let object = object {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
