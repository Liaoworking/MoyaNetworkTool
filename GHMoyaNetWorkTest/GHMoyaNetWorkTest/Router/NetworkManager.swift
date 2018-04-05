//
//  NetworkManager.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 4/2/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

/// 超时时长
private var requestTimeOut:Double = 30
///成功数据的回调
typealias successCallback = ((String) -> (Void))

private let myEndpointClosure = { (target: API) -> Endpoint in
    
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30//每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    switch target {
    case .easyRequset:
        return endpoint
    case .register:
        requestTimeOut = 5
        return endpoint
        
    default:
        return endpoint
    }
}

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
let policies: [String: ServerTrustPolicy] = [
    "example.com": .pinPublicKeys(
        publicKeys: ServerTrustPolicy.publicKeysInBundle(),
        validateCertificateChain: true,
        validateHost: true
    )
]
*/

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
//private public func defaultAlamofireManager() -> Manager {
//    
//    let configuration = URLSessionConfiguration.default
//    
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//    
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//    
//    manager.startRequestsImmediately = false
//    
//    return manager
//}


/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in

    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
    case .began:
        print("开始请求网络")
        
    case .ended:
        print("结束")
    }
}

// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
//stubClosure   用来延时发送网络请求

let Provider = MoyaProvider<API>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)


func NetWorkRequest(_ target: API, completion: @escaping successCallback ){
    //先判断网络是否有链接 没有的话直接返回--代码略
    
    //显示hud
    Provider.request(target) { (result) in
        //隐藏hud
        switch result {
        case let .success(response):
            do {
                let jsonData = try JSON(data: response.data)
                print(jsonData)
//               这里的限制条件依据不同项目来做，为演示demo我把判断条件注释了，直接返回。
                
//                if jsonData[RESULT_CODE].stringValue == "1000"{
                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
//                }else{
                    //flag 不为0000 时判断
                    print("flag不为1000 HUD显示后台返回message"+"\(jsonData[RESULT_MESSAGE].stringValue)")
//                }
            } catch {
            }
        case let .failure(error):
            guard let error = error as? CustomStringConvertible else {
                //网络连接失败，提示用户
                print("网络连接失败")
                break
            }
        }
    }
}



/// Demo中并未使用。
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let json = parameters?["jsonArray"] else {
            return request
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = data
        
        return request
    }
}
