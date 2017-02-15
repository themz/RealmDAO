//
//  RealmDAOTranslator.swift
//  Vkusomaniya
//
//  Created by Mikhail Zinov on 13/02/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmDAOTranslator<EntityType, EntryType: Object>: DAOTranslator {
    typealias Entity = EntityType
    typealias Entry = EntryType
    
    open func toEntity(entry: EntryType) throws -> EntityType {
        throw DAOError.subclassOverrideNecessary
    }
    
    open func toEntry(entity: EntityType) throws -> EntryType {
        throw DAOError.subclassOverrideNecessary
    }
}
