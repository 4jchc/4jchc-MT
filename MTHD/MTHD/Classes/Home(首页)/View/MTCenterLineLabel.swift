//
//  MTCenterLineLabel.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/13.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTCenterLineLabel: UILabel {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));
    }

    
    
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画线
    // 设置起点
    //    CGContextMoveToPoint(ctx, 0, rect.size.height * 0.5);
    //    // 连线到另一个点
    //    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height * 0.5);
    //    // 渲染
    //    CGContextStrokePath(ctx);
    }

