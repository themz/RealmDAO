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

public class RealmDAO<Entity, Entry: Object> {
    private let translator: RealmDAOTranslator<Entity, Entry>
    private let key: Data?
    
    /**
     Инициализатор DAO
     
     - Parameter translator: Транслятор для преобразования обьектных моделей
     в модели базы данных
     - Parameter key: Строка. Ключ шифрования Realm. Если ключь nil, файл realm не шифруется
     
     - Returns: Реализация DAO для конкретного сервиса
     - Remark: Класс Entry должен быть унаследован от Realm Object
     */
    public init(translator: RealmDAOTranslator<Entity, Entry>, key: String? = nil) {
        self.translator = translator
        self.key = key?.data(using: .ascii)
    }
    
    public func persist(_ entity: Entity) -> Bool {
        do {
            let realm = try self.realm()
            try realm.write {
                realm.add(try! translator.toEntry(entity: entity), update: true)
            }
        } catch {
            return false
        }
        return true
    }
    
    public func persist(_ entities: [Entity]) -> Bool {
        do {
            let realm = try self.realm()
            try realm.write {
                realm.add(translator.toEntries(entities: entities), update: true)
            }
        } catch {
            return false
        }
        return true
    }
    
    public func read(id: String) -> Entity? {
        let realm = try! self.realm()
        return try! translator.toEntity(entry: realm.object(ofType: Entry.self, forPrimaryKey: id)!)
    }
    
    public func read() -> [Entity] {
        let realm = try! self.realm()
        return translator.toEntities(entries: Array(realm.objects(Entry.self)))
    }
    
    public func erase(id: String) -> Bool {
        do {
            let realm = try self.realm()
            try realm.write {
                realm.delete(realm.object(ofType: Entry.self, forPrimaryKey: id)!)
            }
        } catch {
            return false
        }
        return true
    }
    
    public func erase() -> Bool {
        do {
            let realm = try self.realm()
            try realm.write {
                realm.delete(realm.objects(Entry.self))
            }
        } catch {
            return false
        }
        return true
    }
    
    private func realm() throws -> Realm {
        let config = Realm.Configuration(encryptionKey: self.key)
        return try Realm(configuration: config)
    }
}
