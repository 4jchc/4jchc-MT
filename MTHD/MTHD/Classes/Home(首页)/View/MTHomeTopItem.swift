//
//  MTHomeTopItem.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHomeTopItem: UIView {

 
    @IBOutlet weak var iconButton: UIButton!
    
    static func item() ->MTHomeTopItem{
        
        return NSBundle.mainBundle().loadNibNamed("MTHomeTopItem", owner: nil, options: nil).first as! MTHomeTopItem
    }
    override func awakeFromNib() {
        self.autoresizingMask = UIViewAutoresizing.None
    }

    
    /** 把按钮点击放在方法里面调用.按钮为私有的
    *  设置点击的监听器
    *
    *  @param target 监听器
    *  @param action 监听方法
    */
    func addTarget(target:AnyObject,action:Selector){
        
        self.iconButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)

    }
}