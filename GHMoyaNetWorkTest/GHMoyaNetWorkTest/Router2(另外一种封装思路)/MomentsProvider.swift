//
//  MomentsProvider.swift
//  GHMoyaNetWorkTest
//
//  Created by Run Liao on 2019/11/24.
//  Copyright © 2019 liaoworking. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
class MomentsProvider: MoyaProvider<MomentsAPI> {
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

let momentsProvider = MomentsProvider()


// 具体使用如下 使用同NetworkManager.swift文件中的封装

//momentsProvider.request(.showMoments) { (result) in
//    print(result)
//}
