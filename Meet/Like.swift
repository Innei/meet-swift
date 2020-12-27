//
//  Like.swift
//  Meet
//
//  Created by Innei on 2020/12/27.
//

import Foundation

class Like: ObservableObject {
    @Published var likes: [LikeModel] = []

    public var codable: [LikeModel] {
        likes
    }

    init() {
        if let data = HitokotoViewModel.userDefaults.data(forKey: HitokotoViewModel.storeKey) {
            let stored = try! PropertyListDecoder().decode([LikeModel].self, from: data)
            likes = stored.map { $0 }
        }
    }

    func has(item: LikeModel) -> Int? {
        return likes.firstIndex(where: { $0.id == item.id })
    }

    func add(item: LikeModel) -> Bool {
        if has(item: item) != nil {
            return false
        } else {
            likes.append(item)
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
