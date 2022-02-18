//
//  ConcurrencyDemo.swift
//  GHMoyaNetWorkTest
//
//  Created by liaoing on 2022/2/18.
//  Copyright © 2022 liaoworking. All rights reserved.
//

import Foundation
import UIKit
import Moya

class ConcurrencyDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detach(priority: .background) {
            let result = await NetWorkRequest(API.easyRequset, modelType: [ZhihuItemModel].self)
            if let models = result.model {
                print("异步请求获取到的模型标题__\(models.map({$0.title ?? ""}))")
            } else {
                print("异步请求获取失败__\(result.response)")
            }
        }
    }
}
