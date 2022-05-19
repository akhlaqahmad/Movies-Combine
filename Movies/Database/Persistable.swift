//
//  Persistable.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import Foundation
import RealmSwift


protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
