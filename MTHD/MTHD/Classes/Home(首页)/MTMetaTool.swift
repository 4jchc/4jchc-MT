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

    
    /** 判断deal类型 */
   static func categoryWithDeal(deal: MTDeal) -> MTCategory? {

        let cs = self.categories
    
    if deal.categories.firstObject == nil {
        return nil
    }
        let cname = deal.categories.firstObject
   
        for c in cs! {
           let cc = c as! MTCategory
            print("cname\(cname) -cc.name \(cc.name)")
            if cname?.isEqualToString(cc.name!) == true {
                print("****cc1*\(cc.map_icon)")
                return cc
            }
            print("cname\(cname) -map_icon \(cc.map_icon)cc.subcategories \(cc.subcategories)")
      
            print("***是否包含**\(cc.subcategories?.containsObject(cname as! String))")
            
            if let a = cc.subcategories  {
                if a.containsObject(cname!){
                    print("****cc2*\(cc.map_icon)")
                    return cc
                }
            }

        }

        return nil
    }

}
