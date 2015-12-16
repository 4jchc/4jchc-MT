//
//  MTRestrictions.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/15.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTRestrictions: EVObject {
    
    /** int	是否需要预约，0：不是，1：是 */
    var is_reservation_required: NSNumber = 0
    
    /** int	是否支持随时退款，0：不是，1：是*/
    var is_refundable: NSNumber = 0
    
    var special_tips: String = ""
    

}
