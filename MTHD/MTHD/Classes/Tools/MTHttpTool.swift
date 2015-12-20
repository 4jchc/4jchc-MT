//
//  MTHttpTool.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/18.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHttpTool: NSObject,DPRequestDelegate {


    let completionBlock: (NSData, NSError) -> Void = { (data, error) in
        // ...
    }

     var _api:DPAPI = DPAPI()
//    override class func initialize(){
//        self._api = DPAPI()
//    }

    
    func request(url:String, pamras:NSMutableDictionary, success:(json:AnyObject!)->Void,failure:(error:NSError!)->Void) {
        
        let request:DPRequest = self._api.requestWithURL(url, params: pamras, delegate: self)
        request.success = success
        request.failure = failure
    }
    
    
    /// DPRequestDelegate
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        if request.success != nil{
            request.success(result)
        }
    }
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        
        if request.failure != nil{
            request.failure(error)
        }
    }
    


}
