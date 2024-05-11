//
//  ViewController.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 3/30/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import UIKit
import Moya
class ViewController: UIViewController {

    /// 用来主动取消网络请求
    var cancelableRequest: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPresentButton()
        // 演示moya+ObjectMapper 接口可以调通
        testZhiHuDailyAPI()
        // 这个方法只是演示 返回单个对象、返回数组、和不关心服务器返回的数据 的网络请求 接口调不通的 查看流程可自己打开注释
//        testAPI()
        // 多业务模块划分 减少单个文件的API数 查看流程可自己打开注释
//        multiServiceModule()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 有些时候的需求是页面退出是取消网络请求。
        cancelableRequest?.cancel()
    }
    
    func addPresentButton() {
        let asyncButton = UIButton(type: .custom)
        asyncButton.frame = CGRect(x: 0, y: 100, width: 280, height: 40)
        asyncButton.addTarget(self, action: #selector(showAsyncNetWorkRequest), for: .touchUpInside)
        asyncButton.setTitle("Swift5.5 Concurrency support", for: .normal)
        asyncButton.titleLabel?.numberOfLines = 2
        asyncButton.titleLabel?.font = .systemFont(ofSize: 16)
        asyncButton.setTitleColor(.black, for: .normal)
        view.addSubview(asyncButton)
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
    
    /// 基本使用 网络请求只是参考 具体接口调不通
    func testAPI() {
        var paraDict: [String:Any] = [:]
        paraDict["app_type_"] = "1"
        paraDict["app_version_no_"] = "1.0.1"
        paraDict["platform_type_"] = "2"
        paraDict["ver_code_value_"] = nil
        // 需要解析单个模型 ✌️✌️✌️✌️
        NetWorkRequest(API.updateAPi(parameters: paraDict), modelType: ZhihuItemModel.self) { (zhihuModel, responseModel) in
            print("服务器传回来的单个数据模型\(zhihuModel)")
        } failureCallback: { (responseModel) in
            print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
        }
        
        // 需要解析数组模型  ✌️✌️✌️✌️
        NetWorkRequest(API.updateAPi(parameters: paraDict), modelType: [ZhihuItemModel].self) { (zhihuModels, responseModel) in
            print("服务器传回来的Array数据模型\(zhihuModels)")
        } failureCallback: { (responseModel) in
            print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
        }
        
        // 不需要解析模型  只关心网络请求的成功或者失败  ✌️✌️✌️✌️
        NetWorkRequest(API.updateAPi(parameters: paraDict)) { responseModel in
            print("网络请求成功")
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
        
        guard let imageData = UIImage().jpegData(compressionQuality: 0.3) else { return }//把图片转换成data
        NetWorkRequest(API.uploadHeadImage(parameters: para, imageDate: imageData),modelType: [ZhihuItemModel].self, successCallback: {_,_ in print("图片上传成功")}, failureCallback: nil)
    }
    
    /// 不同的业务模块的网络请求
    func multiServiceModule() {
        // 登录模块的网络请求
        NetWorkRequest(APILogin.login, modelType: [ZhihuItemModel].self, successCallback: {_,_ in print("登录模块的api")}, failureCallback: nil)
        // 用户信息获取
        NetWorkRequest(APIUser.getInfo, modelType: ZhihuItemModel.self, successCallback: {_,_ in print("用户模块的api")}, failureCallback: nil)
        // 商品列表获取
        NetWorkRequest(APIShops.getGoods, modelType: [ZhihuItemModel].self, successCallback: {_,_ in print("商品模块的api")}, failureCallback: nil)
    }
    
    @objc func showAsyncNetWorkRequest() {
        present(ConcurrencyDemoVC(), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

