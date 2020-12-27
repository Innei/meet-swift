//
//  Model.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let jsonData = """
//   {
//   "id": 111,
//   "uuid": "08f25fd6-d7e0-4a19-a0e6-98c89ceca1b6",
//   "hitokoto": "悲伤教会了我喜悦。",
//   "type": "a",
//   "from": "秋之回忆",
//   "from_who": null,
//   "creator": "LT2142",
//   "creator_uid": 0,
//   "reviewer": 0,
//   "commit_from": "web",
//   "created_at": "1468605909",
//   "length": 9
//   }
//   """.data(using: .utf8)!
//   let hitokoto = try? JSONDecoder().decode(HitokotoModel.self, from: jsonData)

// To read values from URLs:
//
//   let task = URLSession.shared.hitokotoModelTask(with: url) { hitokotoModel, response, error in
//     if let hitokotoModel = hitokotoModel {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - HitokotoModel

struct HitokotoModel: Codable {
    let id: Int
    let uuid, hitokoto, type, from: String
    let fromWho: JSONNull?
    let creator: String
    let creatorUid, reviewer: Int
    let commitFrom, createdAt: String
    let length: Int

    enum CodingKeys: String, CodingKey {
        case id, uuid, hitokoto, type, from
        case fromWho = "from_who"
        case creator
        case creatorUid = "creator_uid"
        case reviewer
        case commitFrom = "commit_from"
        case createdAt = "created_at"
        case length
    }
}

struct LikeModel: Codable, Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var text: String
    var createdAt: Date = Date()
    var from: String?
    var author: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func hitokotoModelTask(with url: URL, completionHandler: @escaping (HitokotoModel?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return codableTask(with: url, completionHandler: completionHandler)
    }
}
