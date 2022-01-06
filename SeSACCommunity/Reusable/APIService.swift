//
//  APIService.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import Foundation
enum APIError: Error {
    case failed, statusCodeFailed,noData, invalidResponse, serverError, tokenExpired, invalidRequest, invalidData
}

enum APIRequest {
    enum Method: String {
        case GET, POST, PUT
        case DEL = "DELETE"
    }
    
    enum Order: String {
        case ascending = "asc"
        case descending = "desc"
    }
    
    case SignUp(username: String, email: String, password: String)
    case SignIn(identifier: String, password: String)
    case ChangePassword(currentPassword: String, newPassword: String, confirmNewPassword: String)
    
    case CreatePost(text: String)
    case ReadPost(order: Order)
    case ReadSpecificPost(postID: Int)
    case UpdatePost(postID: Int, text: String)
    case DeletePost(postID: Int)
    
    case CreateComment(comment: String, postID: Int)
    case ReadComment(postID: Int, order: Order)
    case UpdateComment(comment: String, postID: Int, commentID: Int)
    case DeleteComment(commentID: Int)
    
    func URLReqeust() -> URLRequest {
        switch self {
            // MAKR: Auth
        case .SignUp(let username, let email, let password):
            var request = URLRequest(url: url)
            request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
            request.httpMethod = Method.POST.rawValue
            return request
        case .SignIn(let identifier, let password):
            var request = URLRequest(url: url)
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "identifier=\(identifier)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
            return request
        case .ChangePassword(let currentPassword, let newPassword, let confirmNewPassword):
            var request = URLRequest(url: url)
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "currentPassword=\(currentPassword)&newPassword\(newPassword)&confirmNewPassword=\(confirmNewPassword)".data(using: .utf8, allowLossyConversion: false)
            
            request.addToken()
            return request
            
            // MARK: Post
        case .CreatePost(let text):
            var request = URLRequest(url: url)
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
            
            request.addToken()
            return request
        case .ReadPost:
            var request = URLRequest(url: url)
            request.httpMethod = Method.GET.rawValue
            
            request.addToken()
            return request
        case .ReadSpecificPost:
            var request = URLRequest(url: url)
            request.httpMethod = Method.GET.rawValue
            request.addToken()
            return request
        case .UpdatePost(_, let text):
            var request = URLRequest(url: url)
            request.httpMethod = Method.PUT.rawValue
            request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
            
            request.addToken()
            request.addContentType()
            return request
        case .DeletePost:
            var request = URLRequest(url: url)
            request.httpMethod = Method.DEL.rawValue
            request.addToken()
            return request
            
            // MARK: Comment
        case .CreateComment(let comment, let postID):
            var request = URLRequest(url: url)
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "comment=\(comment)&post=\(postID)".data(using: .utf8, allowLossyConversion: false)
            request.addToken()
            request.addContentType()
            return request
        case .ReadComment:
            var request = URLRequest(url: url)
            request.httpMethod = Method.GET.rawValue
            request.addToken()
            request.addContentType()
            return request
        case .UpdateComment(let comment, let postID, _):
            var request = URLRequest(url: url)
            request.httpMethod = Method.PUT.rawValue
            request.httpBody = "comment=\(comment)&post=\(postID)".data(using: .utf8, allowLossyConversion: false)
            request.addToken()
            request.addContentType()
            return request
        case .DeleteComment:
            var request = URLRequest(url: url)
            request.httpMethod = Method.DEL.rawValue
            request.addToken()
            return request
        }
    }
}

// MARK: - URL
extension URL {
    static let baseURL = "http://test.monocoding.com:1231"
    
    static func endPoint(_ path: String) -> URL {
        return URL(string: baseURL + path)!
    }
}

extension APIRequest {
    var url: URL {
        switch self {
        case .SignUp: return .endPoint("/auth/local/register")
        case .SignIn: return .endPoint("/auth/local")
        case .ChangePassword: return .endPoint("/custom/change-password")
            
        case .CreatePost: return .endPoint("/posts")
        case .ReadPost(let order): return .endPoint("/posts?_sort=created_at:\(order.rawValue)")
        case .ReadSpecificPost(let postID): return
                .endPoint("/posts/\(postID)")
        case .UpdatePost(let postID, _): return .endPoint("/posts/\(postID)")
        case .DeletePost(let postID):
            return .endPoint("/posts/\(postID)")
            
        case .CreateComment:
            return .endPoint("/comments")
        case .ReadComment(let postID, let order):
            return .endPoint("/comments?post=\(postID)&_sort=created_at:\(order.rawValue)")
        case .UpdateComment(_, _, let commentID):
            return .endPoint("/comments/\(commentID)")
        case .DeleteComment(let commentID):
            return .endPoint("/comments/\(commentID)")
        }
    }
    static var token: String {
        let jwt = UserDefaults.standard.string(forKey: "token") ?? ""
        return "Bearer \(jwt)"
    }
}

// MARK: addToken, addContentType
extension URLRequest {
    mutating func addToken() {
        self.addValue(APIRequest.token, forHTTPHeaderField: "Authorization")
    }
    mutating func addContentType() {
        self.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}

class APIService {
    static func requestSignIn(identifier: String, password: String, _ completion: @escaping (AccessInfo?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.SignIn(identifier: identifier, password: password).URLReqeust(), completion: completion)
    }
    // MARK: Post
    static func requestReadPost(_ completion: @escaping (Board?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.ReadPost(order: .descending).URLReqeust(), completion: completion)
    }
    static func requestReadSpecificPost(postID: Int, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.ReadSpecificPost(postID: postID).URLReqeust(), completion: completion)
    }
    static func requestCreatePost(text: String, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.CreatePost(text: text).URLReqeust(), completion: completion)
    }
    static func requestUpdatePost(postID: Int, text: String, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.UpdatePost(postID: postID, text: text).URLReqeust(), completion: completion)
    }
    static func requestDeletePost(postID: Int, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.DeletePost(postID: postID).URLReqeust(), completion: completion)
    }
    // MARK: Comment
    static func requestCreateComment(comment: String, postID: Int, _ completion: @escaping (Comment?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.CreateComment(comment: comment, postID: postID).URLReqeust(), completion: completion)
    }
    static func requestReadComment(postID: Int, completion: @escaping (Comments?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.ReadComment(postID: postID, order: .descending).URLReqeust(), completion: completion)
    }
    static func requestUpdateComment(comment: String, postID: Int, commentID: Int, completion: @escaping (Comment?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.UpdateComment(comment: comment, postID: postID, commentID: commentID).URLReqeust(), completion: completion)
    }
    static func requestDeleteComment(commentID: Int, completion: @escaping (Comment?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.DeleteComment(commentID: commentID).URLReqeust(), completion: completion)
    }
}
