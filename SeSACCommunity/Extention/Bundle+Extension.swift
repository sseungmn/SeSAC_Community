//
//  Bundle+Extension.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/07.
//

import Foundation

extension Bundle {
    var baseURL: String {
        guard let file = path(forResource: "PrivateInfo", ofType: "plist") else { fatalError("PrivateInfo.plist 파일이 존재하지 않습니다.") }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("APIKeys.plist 파일의 형식이 알맞지 않습니다.") }
        guard let key = resource["baseURL"] as? String else { fatalError("해당 API Key가 존재하지 않습니다.")}
        return key
    }
}
