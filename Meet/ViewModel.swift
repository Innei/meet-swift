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
}
