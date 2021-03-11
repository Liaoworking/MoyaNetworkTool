//
//  API.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 3/30/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import Foundation
import ObjectMapper


class ZhihuItemModel: Mappable{
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
        ga_prefix <- map["ga_prefix"]
        images <- map["images"]
        multipic <- map["multipic"]
        type <- map["type"]
        id <- map["id"]
    }
    
	var title:  String?
	var ga_prefix: String?
	var images: String?
	var multipic: String?
	var type: Int?
	var id: Int?
}
