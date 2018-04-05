//
//  API.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 3/30/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//

import Foundation
class GHItem: HandyJSON{
	var title:  String?
	var ga_prefix: String?
	var images: String?
	var multipic: String?
	var type: Int?
	var id: Int?
    
    //用HandyJSON必须要实现这个方法
	required init() {}
}
