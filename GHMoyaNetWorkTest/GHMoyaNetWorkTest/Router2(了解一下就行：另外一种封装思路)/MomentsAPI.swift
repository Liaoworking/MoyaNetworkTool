//
//  MomentsAPI.swift
//  GHMoyaNetWorkTest
//
//  Created by Run Liao on 2019/11/24.
//  Copyright © 2019 liaoworking. All rights reserved.
//

import Foundation
import Moya
/// 朋友圈模块的API封装
enum MomentsAPI {
    case showMoments
}

/// 封装实现同API.swift  这里不赘诉
extension MomentsAPI: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
