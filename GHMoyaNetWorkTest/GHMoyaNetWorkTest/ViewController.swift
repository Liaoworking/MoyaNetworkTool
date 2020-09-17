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

    /// 用来主动取消网络请求
    var cancelableRequest: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testZhiHuDailyAPI()///演示moya+ObjectMapper
        testAPI()//调用这个方法只是演示post请求 接口是调不通的
        multiServiceModule() // 多业务场景使用的DEMO
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 有些时候的需求是页面退出是取消网络请求。
        cancelableRequest?.cancel()
    }
    
    func testZhiHuDailyAPI() {
        cancelableRequest = NetWorkRequest(API.easyRequset, completion: { (responseString) -> (Void) in
            // DEMO中ObjectMapper转模型只是做一个演示，具体封装和用法可以参照
            // https://github.com/tristanhimmelman/ObjectMapper
            if let zhihuModel = GHZhihuModel(JSONString: responseString) {
                zhihuModel.stories?.forEach({ (item) in
                    print("模型属性--\(item.title ?? "模型无title")" )
            })
        }
        }, failed: { (failedResutl) -> (Void) in
            print("服务器返回code不为0000啦~\(failedResutl)")
        }, errorResult: { () -> (Void) in
            print("网络异常")
        })

    }
    
    /// 基本使用
    func testAPI() {
        var paraDict: [String:Any] = Dictionary()
        paraDict["app_type_"] = "1"
        paraDict["app_version_no_"] = "1.0.1"
        paraDict["platform_type_"] = "2"
        paraDict["ver_code_value_"] = nil
        NetWorkRequest(API.updateAPi(parameters: paraDict)) { (responseString) -> (Void) in
            //后台flag为1000是后台的result code
            print(responseString)
        }
    }
    
    /// muti-form 多表单文件上传，这里使用的是png图片上传--接口地址是我瞎写的， 你按照实际后台地址写就行
    func uploadImage() {
        var para:[String:Any] = [:] //参数按照后台约定就成
        para["token"] = "token"
        para["juid"] = "id"
        para["file_type_"] = "head"
        
        let imageData = UIImageJPEGRepresentation(UIImage(), 0.3) //把图片转换成data
        NetWorkRequest(API.uploadHeadImage(parameters: para, imageDate: imageData!)) { (resultString) -> (Void) in
            ///处理后台返回的json字符串
        }
    }
    
    
    /// 多业务模块时候的网络请求
    func multiServiceModule() {
        // 登录模块的网络请求
        NetWorkRequest(APILogin.login) { (resultString) in
            // do something here
        }
        
        // 用户信息获取
        NetWorkRequest(APIUser.getInfo) { (resultString) in
            // do something here
        }
        // 商品列表获取
        NetWorkRequest(APIShops.getGoods) { (resultString) in
            // do something here
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

