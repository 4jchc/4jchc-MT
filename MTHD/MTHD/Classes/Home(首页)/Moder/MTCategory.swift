//
//  MTCategory.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTCategory: NSObject {
    
    /** 类别名称 */
    var name : String?
    
    /** 子类别:里面都是字符串(子类别的名称) */
    var subcategories : NSArray?
    
    /** 显示在下拉菜单的小图标 */
    var small_highlighted_icon : String?
    var small_icon : String?
    
    /** 显示在导航栏顶部的大图标 */
    var highlighted_icon : String?
    var icon : String?
    
    /** 显示在地图上的图标 */
    var map_icon : String?
    
    
}
