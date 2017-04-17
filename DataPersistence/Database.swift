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
    
    func createOrUpdate<Model, RealmObject: Object>(model: Model, with reverseTransformer: (Model) -> RealmObject) {
        let object = reverseTransformer(model)
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    func fetch<Model, RealmObject>(with request: FetchRequest<Model, RealmObject>) -> Model {
        var results = realm.objects(RealmObject.self)
        
        if let predicate = request.predicate {
            results = results.filter(predicate)
        }
        
        if request.sortDescriptors.count > 0 {
            results = results.sorted(by: request.sortDescriptors)
        }
        
        return request.transformer(results)
    }
    
    func delete<RealmObject: Object>(type: RealmObject.Type, with primaryKey: String) {
        let object = realm.object(ofType: type, forPrimaryKey: primaryKey)
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
