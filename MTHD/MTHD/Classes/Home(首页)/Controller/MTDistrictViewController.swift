//
//  MTDistrictViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTDistrictViewController: UIViewController {



    /** 这里是弱引用popoverController 否则会造成循环引用，因为popoverController初始化时会关联一个控制器(self) */
    weak var popover : UIPopoverController?
    
    
    @IBOutlet private var changeCity: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 读取xib文件//TODO:读取xib文件
        NSBundle.mainBundle().loadNibNamed("MTDistrictViewController", owner: self, options: nil)
    
        // 创建下拉菜单
        let title: UIView  = self.view.subviews.first!
        // 设置下拉菜单
        let dropdown = MTHomeDropdown.dropdown()
        
        dropdown.y = title.height
        //dropdown.autoresizingMask = UIViewAutoresizing.None
        dropdown.backgroundColor = UIColor.blackColor()
        self.view.addSubview(dropdown)
        // 设置控制器在popover中的尺寸
        self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame))

    }
    
    ///切换城市
    @IBAction func changeCity(sender: AnyObject) {
        // dismiss popover控制器
        self.popover?.dismissPopoverAnimated(true)
        
        // modal出一个选择地区的控制器
        let city = MTCityViewController()
        let nav = MTNavigationController(rootViewController: city)
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(nav, animated: true, completion: nil)
       
    }
        // self.presentedViewController会引用着被modal出来的控制器
        // modal出来的是MTNavigationController
        // dismiss掉的应该也是MTNavigationController

    
    


}
