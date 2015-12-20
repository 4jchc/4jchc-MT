//
//  MTNavigationController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTNavigationController: UINavigationController {
    
    /** oc中initialize方法 */
//    override class func initialize () {
//        let bar = UINavigationBar.appearance()
//        bar.setBackgroundImage(UIImage(named: "bg_navigationBar_normal"), forBarMetrics: UIBarMetrics.Default)
//    //TODO:使用这个右边的按钮不行
////        let item:UIBarButtonItem = UIBarButtonItem.appearance()
////        item.setTitleTextAttributes([NSForegroundColorAttributeName :UIColor.RGB(21, 188, 173, 1)], forState: UIControlState.Normal)
////        item.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.RGB(1, 1, 1, 1)], forState: UIControlState.Disabled)
//       
//    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        let bar = UINavigationBar.appearance()
        bar.setBackgroundImage(UIImage(named: "bg_navigationBar_normal"), forBarMetrics: UIBarMetrics.Default)
        //TODO:使用这个右边的按钮不行
        let item:UIBarButtonItem = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSForegroundColorAttributeName :UIColor.RGB(21, 188, 173, 1)], forState: UIControlState.Normal)
        item.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.RGB(1, 1, 1, 1)], forState: UIControlState.Disabled)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }


}
