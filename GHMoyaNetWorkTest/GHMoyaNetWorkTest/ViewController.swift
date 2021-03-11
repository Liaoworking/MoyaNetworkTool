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
        
        testZhiHuDailyAPI()///演示moya+ObjectMapper   大部分业务场景使用的是这个调用。
        testAPI()//调用这个方法只是演示post请求 接口是调不通的
        multiServiceModule() // 多业务模块使用
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 有些时候的需求是页面退出是取消网络请求。
        cancelableRequest?.cancel()
    }
    
    func testZhiHuDailyAPI() {
        cancelableRequest = NetWorkRequest(API.easyRequset, modelType: [ZhihuItemModel].self, successCallback: { (zhihuModels, responseModel) in
            zhihuModels.forEach({ (item) in
                print("模型属性--\(item.title ?? "模型无title")" )
        })
        }, failureCallback: { (responseModel) in
            print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
        })

    }
    
    /// 基本使用
    func testAPI() {
        var paraDict: [String:Any] = Dictionary()
        paraDict["app_type_"] = "1"
        paraDict["app_version_no_"] = "1.0.1"
        paraDict["platform_type_"] = "2"
        paraDict["ver_code_value_"] = nil
        
        NetWorkRequest(API.updateAPi(parameters: paraDict), modelType: [ZhihuItemModel].self) { (zhihuModels, responseModel) in
            print("服务器传回来的Array数据模型个数\(zhihuModels.count)")
        } failureCallback: { (responseModel) in
            print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
        }
    }
    
    /// muti-form 多表单文件上传，这里使用的是png图片上传--接口地址是我瞎写的， 你按照实际后台地址写就行
    func uploadImage() {
        var para:[String:Any] = [:] //参数按照后台约定就成
        para["token"] = "token"
        para["juid"] = "id"
        para["file_type_"] = "head"
        
        let imageData = UIImage().jpegData(compressionQuality: 0.3) //把图片转换成data
        NetWorkRequest(API.uploadHeadImage(parameters: para, imageDate: imageData!),modelType: [ZhihuItemModel].self, successCallback: {_,_ in print("图片上传成功")}, failureCallback: nil)

    }
    
    
    /// 多业务模块时候的网络请求
    func multiServiceModule() {
        // 登录模块的网络请求
        NetWorkRequest(APILogin.login, modelType: [ZhihuItemModel].self, successCallback: {_,_ in print("登录模块的api")}, failureCallback: nil)
        // 用户信息获取
        NetWorkRequest(APIUser.getInfo, modelType: ZhihuItemModel.self, successCallback: {_,_ in print("用户模块的api")}, failureCallback: nil)
        // 商品列表获取
        NetWorkRequest(APIShops.getGoods, modelType: [ZhihuItemModel].self, successCallback: {_,_ in print("商品模块的api")}, failureCallback: nil)

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

