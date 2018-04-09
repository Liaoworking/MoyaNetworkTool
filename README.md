[文章简书地址](https://www.jianshu.com/p/adee88ddcd06)


踩坑踩了4天总算把基于Moya的网络框架搭建完毕

看网上关于Moya的教程不太多，大多都是一样的，还有一些年久失修。这里专门讲讲关于moya的搭建及容易遇到的一些坑。


# 重要的东西放到最前面

#### 1.最好的教材是官方文档和Demo，Moya有[中文文档](https://github.com/Moya/Moya/tree/master/docs_CN)。

#### 2.尝试一些不一样的东西会让开发更有趣。

#### 3.写案例不给Demo不太好吧。



# 为什么选择moya：

   一开始网络框架的选型有Alamofire和Moya。

   Alamofire可以说是Swift版本的AFN，啃AFN的老啃了几年了，AFN的确博大精深，有很多值得开发者去学校的地方。但开发这么多年，AFN实在是啃不动了。试着封装了一下Alamofire。感觉和AFN封装大同小异。

 和技术群里的一些大佬讨论了一下,大多数也是推荐Moya，至于聊天记录里面提及的 ***包含?地址的问题*** 我们在稍后的内容里去解决。后来咬咬牙就决定使用Moya用新项目的网络框架。


![image](http://upload-images.jianshu.io/upload_images/1724449-6cbaec8a9dd62115?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# About Moya

已经有大神把Moya的基本使用和各个模块的介绍说的很清楚了，这里就不赘述了，建议把框架的基本使用了解一番[【iOS开发】Moya入坑记-用法解读篇](http://www.codertian.com/2017/01/21/iOS-moya-ru-keng-usage/)  

上文作为入门是一篇不错的文章，但作为实际开发过程中，健壮全方位考虑的网络框架来说的来说还有很多用法并没有提及。 而且网上很多文章都是老版本，看的时候会感觉有些懵。。。所以我就写了本文😑

# **Let's Begin**


#### **封装的目录结构**

安装好Moya后我们 **创建好三个空的Swift文件** 

![image](http://upload-images.jianshu.io/upload_images/1724449-1632f5a42d3c9ea1?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们大致可将网络框架拆分成

 ***API.swift*** ---将来我们的接口列表和不同的接口的一些配置在里面完成，最长打交道的地方。

 ***NetworkManager.swift*** ---基本框架配置及封装写到这里

 ***MoyaConfig.swift*** ---这个其实可有可无的，习惯上把baseURL和一些公用字符串放进来

OK我们正式开始coding！

API.swift中先创建一个API的枚举，枚举值是接口名， 并创建遵守TargetType协议的extention。

这里我写三个测试的Api。第一个是无参，第二个是普通写法(我看官方文档好像是这种 ***多参数*** 都写进去的，实际开发过程中感觉有些麻烦)，第三个是直接把所有参数包装成字典传进来的文艺写法。。

![image](http://upload-images.jianshu.io/upload_images/1724449-56416a46e74e8f54?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

直接点击 **错误代码补全** 即可自动补全所有的协议

```swift
import Foundation
import Moya

enum API {
    case testApi//无参数的接口
    //有参数的接口
    case testAPi(para1:String,para2:String)//普遍的写法
    case testApiDict(Dict:[String:Any])//把参数包装成字典传入--推荐使用
}

extension API:TargetType{
    
    //baseURL 也可以用枚举来区分不同的baseURL，不过一般也只有一个BaseURL
    var baseURL: URL {
        return URL.init(string: "http://news-at.zhihu.com/api/")!
    }
    //不同接口的字路径
    var path: String {
        switch self {
        case .testApi:
            return "4/news/latest"
        case .testAPi(let para1, _):
            return "\(para1)/news/latest"
        case .testApiDict:
            return "4/news/latest"
//        default:
//            return "4/news/latest"
        }
    }
    
    /// 请求方式 get post put delete
    var method: Moya.Method {
        switch self {
        case .testApi:
            return .get
        default:
            return .post
        }
    }
    
    /// 这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    /// 这个就是API里面的核心。嗯。。至少我认为是核心，因为我就被这个坑过
    //类似理解为AFN里的URLRequest
    var task: Task {
        switch self {
        case .testApi:
            return .requestPlain
        case let .testAPi(para1, _)://这里的缺点就是多个参数会导致parameters拼接过长
        //后台的content-Type 为application/x-www-form-urlencoded时选择URLEncoding            
            return .requestParameters(parameters: ["key":para1], encoding: URLEncoding.default)
        case let .testApiDict(dict)://所有参数当一个字典进来完事。
            //后台可以接收json字符串做参数时选这个
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)

        }
    }
    
    /// 设置请求头header
    var headers: [String : String]? {
        //同task，具体选择看后台 有application/x-www-form-urlencoded 、application/json
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
}
```

上面api.swift设置完毕


### NetworkManager.swift

下面就开始构建我们的请求相关的东西
主要是完成对于Provider的完善及个性化设置。

首先先看一个最简单的网络请求, 我们所有的请求都是来自于这个provider对象，测试一下 我们就能发出请求并拿到返回的结果。

```swift
        let provier = MoyaProvider<API>()
        provier.request(.testApi) { (result) in
            switch result {
            case let .success(response):
                print(response)
            case let .failure(error):
                    print("网络连接失败")
                    break
            }
        }
```

当然，对应情况复杂的项目这个是 ***远远不够滴！***

so~ 下面开始对provider进行改造

先看看最丰满的provider是什么样子的
![image.png](https://upload-images.jianshu.io/upload_images/1724449-848eb746a18c03a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当我看到这一个个扑朔迷离的参数时我的表情是这样的(⊙﹏⊙)b

![image.png](https://upload-images.jianshu.io/upload_images/1724449-08ec60bb78118fc9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点进去看源码才发现Moya已经帮我们把每个参数都默认实现了一遍。***我们可以根据自己的设计需求设置参数***
每个参数什么意思也不赘述了，[Moya 的初始化](https://www.jianshu.com/p/7286503db415)  这篇文章也都说了。

#### 上文需要指正的地方是：

![image.png](https://upload-images.jianshu.io/upload_images/1724449-0f482299295f6d84.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

文中 endpointClosure 的使用举例中 target.parameters 已经没有这个属性了。现在版本的Moya用的task代替的。
Moya官方不希望在所有的请求中统一添加参数，不过我们可以自己去定义endPointClosure实现相应的效果 
详情参照：[Add additional parameters to all requests](https://github.com/Moya/Moya/issues/1482) 里面有具体的解决方案。


#### 根据实际项目需求去除了不太常用的 ***stubClosure*** ,   ***callbackQueue*** ,  ***trackInflights*** 后我的Provider长这样

```swift
let Provider = MoyaProvider<API>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

```

下面我们就开始动手构建我们的networkManager

```swift
import Foundation
import Moya
import Alamofire
import SwiftyJSON

/// 超时时长
private var requestTimeOut:Double = 30
///endpointClosure
private let myEndpointClosure = { (target: API) -> Endpoint in
///这里的endpointClosure和网上其他实现有些不太一样。
///主要是为了解决URL带有？无法请求正确的链接地址的bug
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    switch target {
    case .easyRequset:
        return endpoint
    case .register:
        requestTimeOut = 5//按照项目需求针对单个API设置不同的超时时长
        return endpoint
    default:
        requestTimeOut = 30//设置默认的超时时长
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


/// NetworkActivityPlugin插件用来监听网络请求
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
```



### NetworkManager.swift 基本写完  还剩一点下面再说。
这个时候我们的网络请求就会长这样：

```swift
        Provider.request(.testApi) { (result) in
            switch result {
            case let .success(response):
                print(response)
                //做相应的数据处理  这里我用的是HandyJson
            case let .failure(error):
                print("网络连接失败")
                //提示用户网络链接失败
                break
            }
        }
```



### 像我这种懒得一比的开发者，当然不想每一次都写这么多result判断。写好多重复的代码。

![image.png](https://upload-images.jianshu.io/upload_images/1724449-d983e7464f41bf69.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 于是我决定再次封装。。。

来来，我们再次回到NetworkManager.swift 封装provider请求。

## 思路：

1.后台返回错误的时候我统一把error msg显示给用户

2.只有返回正确的时候才把数据提取出来进行解析。 对应的网络请求的hud全部封装到请求里面。

这个是针对于大多数请求。个别展示效果不同的请求自己老老实实用provider.request写就行。
下面我们在NetworkManager.swift中进行二次封装

```swift
///先添加一个闭包用于成功时后台返回数据的回调
typealias successCallback = ((String) -> (Void))
///再次用一个方法封装provider.request()
func NetWorkRequest(_ target: API, completion: @escaping successCallback ){
    //先判断网络是否有链接 没有的话直接返回--代码略
    
    //显示hud
    Provider.request(target) { (result) in
        //隐藏hud
        switch result {
        case let .success(response):
            do {
                //这里转JSON用的swiftyJSON框架
                let jsonData = try JSON(data: response.data)
                //判断后台返回的code码没问题就把数据闭包返回 ，我们后台是0000 以实际后台约定为准。            
                if jsonData[RESULT_CODE].stringValue == "0000"{
                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                }else{
                    //flag 不为0000 HUD显示错误信息
                    print("flag不为0000 HUD显示后台返回message"+"\(jsonData[RESULT_MESSAGE].stringValue)")
                }
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
```

### MoyaConfig.swift 这个就是放一些公用字符串
 觉得麻烦可以放在NetworkManager.swift中  看个人爱好
代码如下

```swift

import Foundation
/// 定义基础域名
let Moya_baseURL = "http://news-at.zhihu.com/api/"

/// 定义返回的JSON数据字段
let RESULT_CODE = "flag"      //状态码
let RESULT_MESSAGE = "message"  //错误消息提示

```

这个时候我们再去用封装好的网络工具优雅的进行网络请求

```swift
   NetWorkRequest(.testApi) { (response) -> (Void) in
          //用HandyJSON对返回的数据进行处理
        }
```

