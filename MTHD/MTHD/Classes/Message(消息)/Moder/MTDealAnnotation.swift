//
//  MTDealAnnotation.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/18.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
import MapKit
class MTDealAnnotation: NSObject ,MKAnnotation{
    

    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var title: String?
    
    var subtitle: String?
    /** 图片名 */
    var icon: String?
    
//    init(coordinate: CLLocationCoordinate2D, title: String,  subtitle: String = "",  icon: String = "") {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//        self.icon = icon
//        
//        super.init()
//    }
    override func isEqual(object: AnyObject?) -> Bool {
        return (self.title! as NSString).isEqual(object!.title)
    }
    


}
