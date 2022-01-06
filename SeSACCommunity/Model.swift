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
struct Comment: Decodable {
    let id: Int
    let comment: String
    let user: User
    let postID: Int
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, comment, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case post
    }
    
    private enum PostContainerKey: String, CodingKey {
        case postID = "id"
    }
    
    init(from decoder: Decoder) throws {
        let commentContainer = try decoder.container(keyedBy: CodingKeys.self)
        let postContainer = try commentContainer.nestedContainer(keyedBy: PostContainerKey.self, forKey: .post)
        
        self.id = try commentContainer.decode(Int.self, forKey: .id)
        self.comment = try commentContainer.decode(String.self, forKey: .comment)
        self.user = try commentContainer.decode(User.self, forKey: .user)
        self.postID = try postContainer.decode(Int.self, forKey: .postID)
        self.createdAt = try commentContainer.decode(String.self, forKey: .createdAt)
        self.updatedAt = try commentContainer.decode(String.self, forKey: .updatedAt)
    }
}
