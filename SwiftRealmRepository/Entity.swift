//
//  Entity.swift
//  SwiftRealmRepository
//
//  Created by 石塚隆一 on 2018/02/14.
//  Copyright © 2018年 石塚隆一. All rights reserved.
//

import Foundation
import RealmSwift

protocol Entity {
    var id: String { get set }
}

class AbstractRealmEntity: Object, Entity {

    @objc dynamic var id: String = ""

    // プライマリーキーを設定
    override static func primaryKey() -> String? {
        return "id"
    }

}

class User: AbstractRealmEntity {
    @objc dynamic var name: String = ""
}
