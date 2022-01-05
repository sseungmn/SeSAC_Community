//
//  Model.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import Foundation

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let jwt: String
    let user: User
}

// MARK: User
struct User: Codable {
    let id: Int
    let username, email: String
}

// MARK: - Board
typealias Board = [Post]

// MARK: Post
struct Post: Codable {
    let id: Int
    let text: String
    let user: User
    let createdAt, updatedAt: String
    let comments: [DummyComment]
    
    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case comments
    }
}

struct DummyComment: Codable {}

typealias Comments = [Comment]
// MARK: Comment
struct Comment: Codable {
    let id: Int
    let comment: String
    let user: User
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, comment, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
