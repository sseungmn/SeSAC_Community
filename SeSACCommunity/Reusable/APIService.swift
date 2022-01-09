//
//  APIService.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import Foundation

enum APIError: Error, Equatable {
    case failed, statusCodeFailed, noData, invalidResponse, serverError, invalidRequest, invalidData
    case unauthorized
//    case unauthorized(type: AuthorizedErrorType)
//    enum AuthorizedErrorType: Int {
//        case `init`
//        case tokenExpired
//        case inaccessible
//    }
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
    case SignIn(username: String, password: String)
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
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        switch self {
            // MARK: Auth
        case .SignUp(let username, let email, let password):
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
            request.addContentType()
        case .SignIn(let username, let password):
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "identifier=\(username)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        case .ChangePassword(let currentPassword, let newPassword, let confirmNewPassword):
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "currentPassword=\(currentPassword)&newPassword\(newPassword)&confirmNewPassword=\(confirmNewPassword)".data(using: .utf8, allowLossyConversion: false)
            request.addToken()
            
            // MARK: Post
        case .CreatePost(let text):
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
            request.addToken()
        case .ReadPost:
            request.httpMethod = Method.GET.rawValue
            request.addToken()
        case .ReadSpecificPost:
            request.httpMethod = Method.GET.rawValue
            request.addToken()
        case .UpdatePost(_, let text):
            request.httpMethod = Method.PUT.rawValue
            request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
            request.addToken()
            request.addContentType()
        case .DeletePost:
            request.httpMethod = Method.DEL.rawValue
            request.addToken()
            
            // MARK: Comment
        case .CreateComment(let comment, let postID):
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "comment=\(comment)&post=\(postID)".data(using: .utf8, allowLossyConversion: false)
            request.addToken()
            request.addContentType()
        case .ReadComment:
            request.httpMethod = Method.GET.rawValue
            request.addToken()
            request.addContentType()
        case .UpdateComment(let comment, let postID, _):
            request.httpMethod = Method.PUT.rawValue
            request.httpBody = "comment=\(comment)&post=\(postID)".data(using: .utf8, allowLossyConversion: false)
            request.addToken()
            request.addContentType()
        case .DeleteComment:
            request.httpMethod = Method.DEL.rawValue
            request.addToken()
        }
        return request
    }
}

// MARK: - URL
extension URL {
    static let baseURL = Bundle.main.baseURL
    
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
    // MARK: Auth
    static func requestSignUp(username: String, email: String, password: String, _ completion: @escaping (AccessInfo?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.SignUp(username: username, email: email, password: password).urlRequest, completion: completion)
    }
    static func requestSignIn(username: String, password: String, _ completion: @escaping (AccessInfo?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.SignIn(username: username, password: password).urlRequest, completion: completion)
    }
    // MARK: Post
    static func requestReadPost(_ completion: @escaping (Board?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.ReadPost(order: .descending).urlRequest, completion: completion)
    }
    static func requestReadSpecificPost(postID: Int, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.ReadSpecificPost(postID: postID).urlRequest, completion: completion)
    }
    static func requestCreatePost(text: String, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.CreatePost(text: text).urlRequest, completion: completion)
    }
    static func requestUpdatePost(postID: Int, text: String, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.UpdatePost(postID: postID, text: text).urlRequest, completion: completion)
    }
    static func requestDeletePost(postID: Int, _ completion: @escaping (Post?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.DeletePost(postID: postID).urlRequest, completion: completion)
    }
    // MARK: Comment
    static func requestCreateComment(comment: String, postID: Int, _ completion: @escaping (Comment?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.CreateComment(comment: comment, postID: postID).urlRequest, completion: completion)
    }
    static func requestReadComment(postID: Int, completion: @escaping (Comments?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.ReadComment(postID: postID, order: .descending).urlRequest, completion: completion)
    }
    static func requestUpdateComment(comment: String, postID: Int, commentID: Int, completion: @escaping (Comment?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.UpdateComment(comment: comment, postID: postID, commentID: commentID).urlRequest, completion: completion)
    }
    static func requestDeleteComment(commentID: Int, completion: @escaping (Comment?, APIError?) -> Void) {
        URLSession.request(endpoint: APIRequest.DeleteComment(commentID: commentID).urlRequest, completion: completion)
    }
}
