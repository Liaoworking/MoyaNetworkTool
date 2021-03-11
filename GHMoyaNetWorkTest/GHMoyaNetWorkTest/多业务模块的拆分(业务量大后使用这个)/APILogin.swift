//
//  APILogin.swift
//  GHMoyaNetWorkTest
//
//  Created by liaoworking on 2020/9/17.
//  Copyright © 2020 liaoworking. All rights reserved.
//

import Foundation
import Moya
// 注册登录模块的api  仅仅做多业务拆分的演示。 具体网络请求接口封装可以参照API.swift文件
enum APILogin {
    case login
    case register
    case sendMobileMsg(phoneNumber: String)
}

extension APILogin: TargetType {
    var baseURL: URL {
        return URL.init(string:(Moya_baseURL))!
    }
    
    var path: String {
        switch self {
        case .login:
            return "api/login"
        case .register:
            return "api/register"
        case .sendMobileMsg(let phoneNumber):
            return "api/sendMobileMsg/\(phoneNumber)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .sendMobileMsg(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login, .register, .sendMobileMsg(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["header信息可以参考API.swift文件中的header，项目中建议封装在一个地方用的时候调用一下即可":""]
    }
    
}
