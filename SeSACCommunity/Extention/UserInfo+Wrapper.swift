//
//  UserDefault+Wrapper.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/10.
//

import Foundation

@propertyWrapper
class UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

class UserInfo {
    @UserDefault("username", defaultValue: "") static var username: String
    @UserDefault("password", defaultValue: "") static var password: String
    @UserDefault("jwt", defaultValue: "") static var jwt: String
    @UserDefault("id", defaultValue: 0) static var id: Int
}
