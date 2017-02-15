//
//  RealmDAO.swift
//  Vkusomaniya
//
//  Created by Mikhail Zinov on 13/02/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Класс реализует шаблон DAO для работы с базой данных Realm
 */

class RealmDAO<Entity, Entry: Object> {
    private let translator: RealmDAOTranslator<Entity, Entry>
    
    /**
     Инициализатор DAO
     
     - Parameter translator: Транслятор для преобразования обьектных моделей
     в модели базы данных
     
     - Returns: Реализация DAO для конкретного сервиса
     - Remark: Класс Entry должен быть унаследован от Realm Object
     */
    init(translator: RealmDAOTranslator<Entity, Entry>) {
        self.translator = translator
    }
    
    func persist(_ entity: Entity) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(try! translator.toEntry(entity: entity), update: true)
            }
        } catch {
            return false
        }
        return true
    }
    
    func persist(_ entities: [Entity]) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(translator.toEntries(entities: entities), update: true)
            }
        } catch {
            return false
        }
        return true
    }
    
    func read(id: String) -> Entity? {
        let realm = try! Realm()
        return try! translator.toEntity(entry: realm.object(ofType: Entry.self, forPrimaryKey: id)!)
    }
    
    func read() -> [Entity] {
        let realm = try! Realm()
        return translator.toEntities(entries: Array(realm.objects(Entry.self)))
    }
    
    func erase(id: String) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.object(ofType: Entry.self, forPrimaryKey: id)!)
            }
        } catch {
            return false
        }
        return true
    }
    
    func erase() -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(Entry.self))
            }
        } catch {
            return false
        }
        return true
    }
}
