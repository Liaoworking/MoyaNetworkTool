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
    
    
    /// 基本使用
    func testAPI() {
        var paraDict: [String:Any] = Dictionary()
        paraDict["app_type_"] = "1"
        paraDict["app_version_no_"] = "1.0.1"
        paraDict["platform_type_"] = "2"
        paraDict["ver_code_value_"] = nil
        NetWorkRequest(.updateAPi(parameters: paraDict)) { (responseString) -> (Void) in
            //后台flag为1000是后台的result code
            print(responseString)
        }
    }
    
    /// muti-form 多表单文件上传，这里使用的是png图片上传--接口地址是我瞎写的， 你按照实际后台地址写就行
    func uploadImage() {
        var para = [String:Any]() //参数按照后台约定就成
        para["token"] = "token"
        para["juid"] = "id"
        para["file_type_"] = "head"
        
        let imageData = UIImageJPEGRepresentation(UIImage(), 0.3) //把图片转换成data
        NetWorkRequest(.uploadHeadImage(parameters: para, imageDate: imageData!)) { (resultString) -> (Void) in
            ///处理后台返回的json字符串
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

