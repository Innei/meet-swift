//
//  Like.swift
//  Meet
//
//  Created by Innei on 2020/12/27.
//

import Foundation

class Like: ObservableObject {
    @Published var likes: [LikeModel] = [] {
        didSet {
            Store.refreshStore(self)
        }
    }

    public var codable: [LikeModel] {
        likes
    }

    init() {
        if let data = Store.userDefaults.data(forKey: Store.storeKey) {
            let stored = try! PropertyListDecoder().decode([LikeModel].self, from: data)
            likes = stored.map { $0 }
        }
    }

    func has(item: LikeModel) -> Int? {
        return likes.firstIndex(where: { $0.id == item.id })
    }

    func has(uuid: UUID?) -> Bool {
        guard let uuid = uuid else { return false }
        return likes.first { $0.id == uuid } != nil
    }

    func add(item: LikeModel) -> Bool {
        if has(item: item) != nil {
            return false
        } else {
            likes.append(item)
//            Store.refreshStore()
            return true
        }
    }

    func remove(item: LikeModel) -> LikeModel? {
        let id = item.id
        if let index = likes.firstIndex(where: { $0.id == id }) {
            let element = likes[index]
            likes.remove(at: index)
            return element
        } else {
            return nil
        }
    }

    func remove(uuid: UUID) -> LikeModel? {
        let id = uuid
        if let index = likes.firstIndex(where: { $0.id == id }) {
            let element = likes[index]
            likes.remove(at: index)
            return element
        } else {
            return nil
        }
    }

    func removeAll() {
        likes.removeAll()
    }
}

class Store {
    private(set) static var userDefaults = UserDefaults()

    public static let storeKey = "like-list"

    public static func refreshStore(_ like: Like) {

        if let data = try? PropertyListEncoder().encode(like.codable) {
            userDefaults.set(data, forKey: storeKey)
        }
    }
}
