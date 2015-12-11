//
//  UIBarButtomItem+Extension.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/8.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import Foundation
import UIKit

// 1.增加自定义图片的高亮和普通状态
// 2.添加行为action
extension UIBarButtonItem{
    
    /**
     *  创建一个item
     *
     *  @param target    点击item后调用哪个对象的方法
     *  @param action    点击item后调用target的哪个方法
     *  @param image     图片
     *  @param highImage 高亮的图片
     *
     *  @return 创建完的item
     */ //ItemWithImageTarget
    class func ItemWithImageTarget(target:AnyObject?,action:Selector,image:NSString,hightImage:NSString) ->UIBarButtonItem{
        
        let btn:UIButton = UIButton(type: UIButtonType.Custom)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        // 设置图片可以改尺寸不会被拉升(2个item的距离)
        btn.setImage(UIImage(named: image as String), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: hightImage as String), forState: UIControlState.Highlighted)
        //设置背景图片会被拉升
//        btn.setBackgroundImage(UIImage(named: image as String), forState: UIControlState.Normal)
//        btn.setBackgroundImage(UIImage(named: hightImage as String), forState: UIControlState.Highlighted)
//        // 设置尺寸
//        btn.frame.size = btn.currentBackgroundImage!.size;
        
        if let size = btn.currentImage?.size{
            
            btn.frame.size = size
        }
        
        return UIBarButtonItem(customView: btn)
        
    }
}
