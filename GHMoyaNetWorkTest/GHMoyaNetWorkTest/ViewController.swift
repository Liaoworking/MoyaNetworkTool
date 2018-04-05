//
//  ViewController.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 3/30/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testZhiHuDailyAPI()
//        testAPI()
    }

    
    func testZhiHuDailyAPI() {
        NetWorkRequest(.easyRequset) { (responseString) -> (Void) in
            if let daliyItems = [GHItem].deserialize(from: responseString, designatedPath: "stories") {
                daliyItems.forEach({ (item) in
                    print(item?.title ?? "模型无title")
                })
            }
        }
    }
    
    func testAPI() {
        var paraDict: [String:Any] = Dictionary()
        paraDict["app_type_"] = "1"
        paraDict["app_version_no_"] = "1.0.1"
        paraDict["platform_type_"] = "2"
        paraDict["ver_code_value_"] = nil
        NetWorkRequest(.updateAPi(parameters: paraDict)) { (responseString) -> (Void) in
            //后台flag为1000是处理数据
            print(responseString)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

