//
//  ViewModel.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//

import Foundation

class HitokotoViewModel {
    static func fetch(completion: @escaping (HitokotoModel) -> Void) {
        let task = URLSession.shared.hitokotoModelTask(with: URL(string: "https://v1.hitokoto.cn/")!) { hitokotoModel, _, _ in
            if let hitokotoModel = hitokotoModel {
                DispatchQueue.main.async {
                    completion(hitokotoModel)
                }
            }
        }

        task.resume()
    }

    private(set) static var userDefaults = UserDefaults()

    public static let storeKey = "like-list"

    public static let like = Like()

    static func storeData(add model: LikeModel) {
        if !like.add(item: model) {
            return
        }

        refreshStore()
    }

    private static func refreshStore() {
        if let data = try? PropertyListEncoder().encode(like.codable) {
            userDefaults.set(data, forKey: storeKey)
        }
    }

    static func storeData(removeUUID uuid: UUID) {
        if like.remove(uuid: uuid) == nil {
            return
        }
        refreshStore()
    }

    static func storeData(removeAtIndexSet indexSet: IndexSet) {
        like.likes.remove(atOffsets: indexSet)
        refreshStore()
    }

    static func clearStoreData() {
        like.likes.removeAll()
        refreshStore()
    }

    static func swap(from: IndexSet, to: Int) {
        like.likes.move(fromOffsets: from, toOffset: to)
        refreshStore()
    }

    static func isStored(uuid: UUID?) -> Bool {
        if uuid == nil {
            return false
        }
        return like.likes.first(where: { $0.id == uuid }) != nil
    }
}
