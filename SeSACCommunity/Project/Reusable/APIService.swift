//
//  APIService.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import Foundation
enum APIError: Error {
    case failed, noData, invalidResponse, serverError, tokenExpired, invalidRequest, invalidData
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
    //  case UpdatePost(postId: String, text: String)
    //  case DeletePost(postId: String)
    //  case CreateComment,
    case ReadComment(postID: Int, order: Order)
    //    UpdateComment, DeleteComment
    
    func URLReqeust() -> URLRequest {
        switch self {
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
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
            
        case .CreatePost(let text):
            var request = URLRequest(url: url)
            request.httpMethod = Method.POST.rawValue
            request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
            
        case .ReadPost:
            var request = URLRequest(url: url)
            request.httpMethod = Method.GET.rawValue
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
        case .ReadSpecificPost:
            var request = URLRequest(url: url)
            request.httpMethod = Method.GET.rawValue
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
            
            //    case .UpdatePost(let postId, let text):
            //      return URLReqeust()
            //    case .DeletePost(let postId, let Authorization):
            //      return URLReqeust()
        case .ReadComment:
            var request = URLRequest(url: url)
            request.httpMethod = Method.GET.rawValue
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
        }
    }
}
    
    extension APIRequest {
        var url: URL {
            switch self {
            case .SignUp: return .endPoint("/auth/local/register")
            case .SignIn: return .endPoint("/auth/local")
            case .ChangePassword: return .endPoint("/custom/change-password")
            case .ReadPost(let order): return .endPoint("/posts?_sort=created_at:\(order.rawValue)")
            case .ReadSpecificPost(let postID): return
                    .endPoint("/posts/\(postID)")
            case .CreatePost: return .endPoint("/posts")
            case .ReadComment(let postID, let order):
                return .endPoint("/comments?post=\(postID)&_sort=created_at:\(order.rawValue)")
            }
        }
        var token: String {
            let jwt = UserDefaults.standard.string(forKey: "token") ?? ""
            return "Bearer \(jwt)"
        }
    }
    
    extension URL {
        static let baseURL = "http://test.monocoding.com:1231"
        
        static func endPoint(_ path: String) -> URL {
            return URL(string: baseURL + path)!
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
        // MARK: Comment
        static func requestReadComment(postID: Int, completion: @escaping (Comments?, APIError?) -> Void) {
            URLSession.request(endpoint: APIRequest.ReadComment(postID: postID, order: .descending).URLReqeust(), completion: completion)
        }
    }
