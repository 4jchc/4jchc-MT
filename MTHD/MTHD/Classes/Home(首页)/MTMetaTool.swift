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
    
    lazy var cities:NSArray? = {
        
        let ani = MTCity.mj_objectArrayWithFilename("cities.plist")
        
        return ani
    }()
    
    lazy var categories:NSArray? = {
        
        let ani = MTCity.mj_objectArrayWithFilename("categories.plist")
        
        return ani
    }()

    lazy var sorts:NSArray? = {
        
        let ani = MTCity.mj_objectArrayWithFilename("sorts.plist")
        
        return ani
    }()

    



}
