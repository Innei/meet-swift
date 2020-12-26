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

    private static let storeKey = "like-list"

    static func storeData(add model: LikeModel) {
        if let data = userDefaults.data(forKey: storeKey) {
            var stored = try! PropertyListDecoder().decode([LikeModel].self, from: data)
            if stored.first(where: { $0.id == model.id }) != nil {
                return
            }

            stored.append(model)
            print(stored)
            if let data = try? PropertyListEncoder().encode(stored) {
                userDefaults.set(data, forKey: storeKey)
            }
        } else {
            if let data = try? PropertyListEncoder().encode([LikeModel]()) {
                userDefaults.set(data, forKey: storeKey)
            }
        }
    }
}
