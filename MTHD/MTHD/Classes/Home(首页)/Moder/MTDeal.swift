//
//  MTDeal.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/13.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTDeal: NSObject {
    
    /** 团购单ID */
    var deal_id: String = ""
    /** 团购标题 */
    var title: String = ""
    /** 团购描述 */
    var desc: String = ""
    /** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber */
     /** 团购包含商品原价值 */
    var list_price: String = ""
    /** 团购价格 */
    var current_price: String = ""
    /** 团购当前已购买数 */
    var purchase_count: String = ""
    /** 团购图片链接，最大图片尺寸450×280 */
    var image_url: String = ""
    /** 小尺寸团购图片链接，最大图片尺寸160×100 */
    var s_image_url: String = ""
    /** string	团购发布上线日期 */
    var publish_date: String = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        
        return ["desc" : "description"]
    }

    
    
    
//    /** 团购发布上线日期 */
//    var publish_date: String = ""
//    /** 团购过期日期 */
//    var purchase_deadline: String = ""
//    /** 订单详情页面 */
//    var deal_h5_url: String = ""
//    
//    /** 编辑状态 */
//    var edit: Bool = false
//    /** 被选中 */
//    var checking: Bool = false
//    
//    /** 团购限制条件 */
//    var restrictions: SWRestrictions = SWRestrictions()
//    
//    /** 团购类型 */
//    var categories: [String] = []
//    
//    /** 地址 */
//    var businesses: [SWBusiness] = []

}
