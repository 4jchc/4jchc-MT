//
//  MTCategoryViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//


// iPad中控制器的view的尺寸默认都是1024x768, MTHomeDropdown的尺寸默认是300x340
// MTCategoryViewController显示在popover中,尺寸变为480x320, MTHomeDropdown的尺寸也跟着减小:0x0
import UIKit

class MTCategoryViewController: UIViewController,MTHomeDropdownDataSource, MTHomeDropdownDelegate {


    
    override func loadView(){
        // 1.加载分类数据
        let dropdown:MTHomeDropdown = MTHomeDropdown.dropdown()

        dropdown.dateSource = self;
        dropdown.delegate = self;
        // 设置该控制器在popover控制器内的尺寸
        self.preferredContentSize = dropdown.size
        //MARK: 不跟着父控件的伸缩而伸缩 放到加载xib的awakeFromNib()中
        //dropdown.autoresizingMask = UIViewAutoresizing.None

        self.view = dropdown;
    
        // 设置控制器view在popover中的尺寸
        self.preferredContentSize = dropdown.size;
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadView()

    }
    

    
    
    
    
    
    
    //MARK: - MTHomeDropdownDataSource
    /**
    *  左边表格一共有多少行
    */
    func numberOfRowsInMainTable(homeDropdown:MTHomeDropdown) -> Int {
        
        
        return MTMetaTool.categories!.count ?? 0
    }
    
    /**
     *  左边表格每一行的子数据
     *  @param row          行号
     */
    func subdataForRowInMainTable(homeDropdown:MTHomeDropdown, row: Int) -> NSArray? {
        

        let category: MTCategory = MTMetaTool.categories![row] as! MTCategory;
        return category.subcategories;
        
    }
    /**
     *  左边表格每一行的标题
     *  @param row          行号
     */
    func titleForRowInMainTable(homeDropdown:MTHomeDropdown, row: Int) -> String {
        

        let category: MTCategory = MTMetaTool.categories![row] as! MTCategory;
        return category.name! ?? ""
        
    }
    
    func iconForRowInMainTable(homeDropdown: MTHomeDropdown, row: Int) -> String {
        
        let category: MTCategory = MTMetaTool.categories![row] as! MTCategory;
        return category.small_icon!;
    }
    
    
    func selectedIconForRowInMainTable(homeDropdown: MTHomeDropdown, row: Int) -> String {
         let category: MTCategory = MTMetaTool.categories![row] as! MTCategory;
        return category.small_highlighted_icon!;
    }
    
    
    
    
    //MARK: - MTHomeDropdownDelegate
    
    func didSelectRowInMainTable(row: Int) -> Void {
 
        // 假如点击的main row是全部或者右侧没有subregion 则发送通知
        let category: MTCategory = MTMetaTool.categories![row] as! MTCategory;
        if((row == 0) || (category.subcategories?.count == 0)) {
            
            // 发出通知
            MTNotificationCenter.postNotificationName(MTCategoryDidChangeNotification, object: nil, userInfo: [MTSelectCategory : category])
            //dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func didSelectRowInSubTable(subrow: Int, mainRow: Int) -> Void {
        
        let category: MTCategory = MTMetaTool.categories![mainRow] as! MTCategory;
        
        // 点击右边栏则直接发送通知
        MTNotificationCenter.postNotificationName(MTCategoryDidChangeNotification, object: nil, userInfo: [MTSelectCategory : category, MTSelectSubcategoryName : category.subcategories![subrow]])
        
        //dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    
}



