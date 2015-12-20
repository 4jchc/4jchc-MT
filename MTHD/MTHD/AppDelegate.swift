 //
//  AppDelegate.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        
        self.window?.rootViewController = MTNavigationController(rootViewController: MTHomeViewController())

            
            
        self.window?.makeKeyAndVisible()
      
        return true
    }
    
    // 当其他应用跳转到本应用时就会调用这个方法 - 处理支付宝客户端返回结果

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

//        var result:AlixPayResult = AlixPayResult()
//        if url.description.isEmpty == false && url.host?.compare("safepay") == NSComparisonResult.OrderedAscending{
//            
//        let query:NSString = (url.query?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)! as NSString
//           
//             result = AlixPayResult(string: query as String)
//        }
//        if (result.statusCode == 9000) {
//            /*
//            *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//            */
//            let verifier:DataVerifier = CreateRSADataVerifier(AlipayPubKey);
//            if verifier.verifyString(result.description, withSign: result.signString){
//                //验证签名成功，交易结果无篡改
//                //交易成功
//                
//            } else { // 失败
//                
//            }
//        } else {
//            // 失败
//            
//        }
//        
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

