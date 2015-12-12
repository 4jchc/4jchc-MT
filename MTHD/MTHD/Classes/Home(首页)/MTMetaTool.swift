//
//  MTMetaTool.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/12.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTMetaTool: NSObject {
    
    //MARK: - 懒加载
    
   static var cities:NSArray? = {
        
        let ani = MTCity.mj_objectArrayWithFilename("cities.plist")
        
        return ani
    }()
    
    static var categories:NSArray? = {
        
        let ani = MTCategory.mj_objectArrayWithFilename("categories.plist")
        
        return ani
    }()

    static var sorts:NSArray? = {
        
        let ani = MTSort.mj_objectArrayWithFilename("sorts.plist")
        
        return ani
    }()

    



}
