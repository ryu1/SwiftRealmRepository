//
//  Repository.swift
//  SwiftRealmRepository
//
//  Created by 石塚隆一 on 2018/02/14.
//  Copyright © 2018年 石塚隆一. All rights reserved.
//

import Foundation
import RealmSwift
import AnyQuery

protocol Repository {

    associatedtype Domain

    func find(byPrimaryKey: String) -> Domain?

    func find(query: AnyQuery?, sort: AnySort?) -> [Domain]

//    func findAll() -> [Domain]

    func add(domains: [Domain])

    func delete(domains: [Domain])

}

extension Repository {
    func findAll() -> [Domain] {
        return find(query: nil, sort: nil)
    }
}

class AbstractRealmRepository<DomainType: Object>: Repository {

    typealias Domain = DomainType

    var realm: Realm

    init() {
        self.realm = try! Realm()
    }

    func find(byPrimaryKey key: String) -> DomainType? {
        return realm.objects(DomainType.self).filter("ID == %@", key).first
    }

    func find(query: AnyQuery?, sort: AnySort?) -> [DomainType] {
        var result = realm.objects(DomainType.self)

        if let predicate = query?.predicate {
            result = result.filter(predicate)
        }

        if let sortDescriptors = sort?.sortDescriptors {
            for sortDescriptor in sortDescriptors {
                guard let key = sortDescriptor.key else {
                    continue
                }
                result = result.sorted(byKeyPath: key, ascending: sortDescriptor.ascending)
            }
        }

        return Array(result)
    }

//    // 全部取ってくる
//    func findAll() -> [DomainType] {
//        return realm.objects(DomainType.self).map({$0})
//    }

    // 条件指定
    func find(predicate: NSPredicate) -> [DomainType] {
        return Array(realm.objects(DomainType.self).filter(predicate))
    }

    // データ追加と更新
    func add(domains: [DomainType]) {
        try! realm.write {
            realm.add(domains, update: true)
        }
    }
    // データ削除
    func delete(domains: [DomainType]) {
        try! realm.write {
            realm.delete(domains)
        }
    }
//    // トランザクション
//    func transaction(_ transactionBlock: () -> Void) {
//        try! realm.write {
//            transactionBlock()
//        }
//    }
//    // スレッドをまたいだオブジェクトの解決
//    func resolve<Confined: ThreadConfined>(_ reference: ThreadSafeReference<Confined>) -> Confined? {
//        return self.realm.resolve(reference)
//    }

}

