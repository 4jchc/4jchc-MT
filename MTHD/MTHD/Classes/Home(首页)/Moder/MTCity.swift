//
//  MTCity.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTCity: NSObject {
    
    /** 城市名称 */
    var name : String?

    /** 城市名称拼音 */
    var pinYin : String?
    var pinYinHead : String?
    
    /** 区域(存放的都是MTRegion模型) */
    var regions : NSArray?
    
    override static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        
        return ["regions" : MTRegion.classForCoder()]
    }
    

}
