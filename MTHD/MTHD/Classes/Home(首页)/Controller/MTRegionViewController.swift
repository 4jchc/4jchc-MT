//
//  MTRegionViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTRegionViewController: UIViewController ,MTHomeDropdownDataSource, MTHomeDropdownDelegate{

    var regions:NSArray?

    /** 这里是弱引用popoverController 否则会造成循环引用，因为popoverController初始化时会关联一个控制器(self) */
    weak var popover : UIPopoverController?
    
    
    @IBOutlet private var changeCity: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 读取xib文件//TODO:读取xib文件
        NSBundle.mainBundle().loadNibNamed("MTRegionViewController", owner: self, options: nil)
    
        // 创建下拉菜单
        let title: UIView  = self.view.subviews.first!
        // 设置下拉菜单
        let dropdown = MTHomeDropdown.dropdown()
        dropdown.dateSource = self;
        dropdown.delegate = self;
        dropdown.y = title.height
        //dropdown.autoresizingMask = UIViewAutoresizing.None
        //dropdown.backgroundColor = UIColor.blackColor()
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
        let currentcontroller = UIApplication.sharedApplication().keyWindow?.rootViewController
        currentcontroller!.presentViewController(nav, animated: true, completion: nil)
       
    }
        // self.presentedViewController会引用着被modal出来的控制器
        // modal出来的是MTNavigationController
        // dismiss掉的应该也是MTNavigationController

    
    
    
    
    
    
    //MARK: - MTHomeDropdownDataSource
    /**
    *  左边表格一共有多少行
    */
    func numberOfRowsInMainTable(homeDropdown:MTHomeDropdown) -> Int {
        
        print("*****\(self.regions?.count)")
    
        return self.regions?.count ?? 0
    }
    
    /**
     *  左边表格每一行的标题
     *  @param row          行号
     */
    func titleForRowInMainTable(homeDropdown:MTHomeDropdown, row: Int) -> String {
        
        let region: MTRegion = self.regions![row] as! MTRegion;
        return region.name! ?? ""
      
    }
    
    /**
     *  左边表格每一行的子数据
     *  @param row          行号
     */
    func subdataForRowInMainTable(homeDropdown:MTHomeDropdown, row: Int) -> NSArray? {
        
        if let region = self.regions?[row] as? MTRegion{
            
            return region.subregions
        }
        
        return nil

    }
    

    //MARK: -  MTHomeDropdownDelegate

    func didSelectRowInMainTable(row: Int) -> Void {
        
        
        // 假如点击的main row是全部或者右侧没有subregion 则发送通知
        let region: MTRegion = self.regions![row] as! MTRegion;
        if((row == 0) || (region.subregions?.count == 0)) {
            
            // 发出通知
            MTNotificationCenter.postNotificationName(MTRegionDidChangeNotification, object: nil, userInfo: [MTSelectRegion : region])
            //dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func didSelectRowInSubTable(subrow: Int, mainRow: Int) -> Void {
        
        let region: MTRegion = self.regions![mainRow] as! MTRegion;
        
        // 点击右边栏则直接发送通知
        MTNotificationCenter.postNotificationName(MTRegionDidChangeNotification, object: nil, userInfo: [MTSelectRegion : region, MTSelectSubregionName : region.subregions![subrow]])
        
        //dismissViewControllerAnimated(true, completion: nil)
    }

}
