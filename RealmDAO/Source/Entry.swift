//
//  Entry.swift
//  Vkusomaniya
//
//  Created by Mikhail Zinov on 13/02/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation
import RealmSwift

open class Entry: Object {
    dynamic var id: String = ""
    
    override open class func primaryKey() -> String? {
        return "id"
    }
}
