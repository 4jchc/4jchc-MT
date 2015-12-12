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

class MTCategoryViewController: UIViewController {


    override func loadView(){
        // 1.加载分类数据
        let dropdown:MTHomeDropdown = MTHomeDropdown.dropdown()
        dropdown.categories = MTCategory.mj_objectArrayWithFilename("categories.plist")

        // 2.设置下拉视图尺寸
        
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
    
}



