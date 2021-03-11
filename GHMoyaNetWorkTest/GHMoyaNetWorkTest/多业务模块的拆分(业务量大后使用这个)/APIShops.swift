//
//  APIShops.swift
//  GHMoyaNetWorkTest
//
//  Created by liaoworking on 2020/9/17.
//  Copyright © 2020 liaoworking. All rights reserved.
//

import Foundation
import Moya
// 店铺模块的api  仅仅做多业务拆分的演示。 具体网络请求接口封装可以参照API.swift文件
enum APIShops {
    case getGoods
    case getShopInfo(shopID: String)
}

extension APIShops: TargetType {
    var baseURL: URL {
        return URL.init(string:(Moya_baseURL))!
    }
    
    var path: String {
        switch self {
        case .getGoods:
            return "api/getGoods"
        case .getShopInfo(let shopID):
            return "api/getShopInfo/\(shopID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGoods, .getShopInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getShopInfo(_), .getGoods:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["header信息可以参考API.swift文件中的header，项目中是封装在一个地方用的时候调用一下即可":""]
    }
    
}
