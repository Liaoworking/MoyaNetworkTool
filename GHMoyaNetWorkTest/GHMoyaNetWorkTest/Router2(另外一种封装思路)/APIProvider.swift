//
//  File.swift
//  GHMoyaNetWorkTest
//
//  Created by Run Liao on 2019/11/24.
//  Copyright © 2019 liaoworking. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

class APIProvider: MoyaProvider<API> {
    override init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
                  requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
                  stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {

        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   manager: manager,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
}

let provider = APIProvider()


/// 如有以后增加了一个借口很多新的模块，例如朋友圈模块 我们可以重新创建一个TargetType 来单独做处理



// 具体使用如下 使用方法同NetworkManager.swift文件中的封装

//provider.request(.easyRequset) { (result) in
//    print("\(result)")
//}
