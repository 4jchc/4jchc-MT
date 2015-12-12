//
//  MTHomeViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHomeViewController: UICollectionViewController {
    
    let reuseIdentifier:NSString = "Cell";
    /** 导航栏上的按钮 */
    /** 分类item */
    private var categoryItem : UIBarButtonItem!
    /** 地区item */
    private var districtItem : UIBarButtonItem!
    
    /** 排序item */
    private var sortItem : UIBarButtonItem!
    
    private var regionItem : UIBarButtonItem!

    private var mapItem : UIBarButtonItem!
    private var searchItem : UIBarButtonItem!
    
//    /** popover控制器 */
//    private var categoryPopover : UIPopoverController?
//    private var regionPopover : UIPopoverController?
//    private var sortPopover : UIPopoverController?
//    
//    /** 请求参数 */
//    private var selectedCity : String!
//    private var selectedRegion : String!
//    private var selectedCategory : String!
//    private var selectedSubCategory : String?
//    private var selectedSort : SWSort!


    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        self.collectionView!.backgroundColor = UIColor.RGB(230, 230, 230, 1)
        
        
        // 设置导航栏属性
        self.setupLeftNav()
        self.setupRightNav()
//
//        // 增加监听事件
        setupNotification()
//        
//        // 继承父类协议
//        delegate = self
//        
//        // 设置左下角菜单
//        setupAwesomeMenu()
    }
    
    
    
    // MARK: - 设置导航栏内容
    func setupLeftNav() {
        

        // 1.LOGO
        let logoItem = UIBarButtonItem(image: UIImage(named: "icon_meituan_logo"), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        logoItem.enabled = false
        
        // 2. 类别
        let categoryTopItem = MTHomeTopItem.item()
        categoryTopItem.addTarget(self, action: "categoryClicked")

        let categoryItem = UIBarButtonItem(customView: categoryTopItem)
        self.categoryItem = categoryItem
        

        // 3. 地区
        let districtTopItem = MTHomeTopItem.item()
        districtTopItem.addTarget(self, action: "districtClick")

        let districtItem = UIBarButtonItem(customView: districtTopItem)
        self.districtItem = districtItem
        
        // 4.排序
        let sortTopItem = MTHomeTopItem.item()
        sortTopItem.addTarget(self, action: "sortClick")

        let sortItem = UIBarButtonItem(customView: sortTopItem)
        self.sortItem = sortItem
        
        // 添加到导航栏
        navigationItem.leftBarButtonItems = [logoItem, categoryItem, districtItem, sortItem]
    }
    
    func setupRightNav() {
        
        // 地图按钮
        let map = UIBarButtonItem.ItemWithImageTarget(self, action: "map", image: "icon_map", hightImage: "icon_map_highlighted")
        self.mapItem = map
        //该按钮的尺寸(间距)
        map.customView!.width = 60;
        
        // 搜索按钮
        let search = UIBarButtonItem.ItemWithImageTarget(self, action: "search", image: "icon_search", hightImage: "icon_search_highlighted")
        self.searchItem = search

        search.customView!.width = 60;
        
        // 2.加入到导航栏
        navigationItem.rightBarButtonItems = [map,search]
        
    
    }
    
    // MARK: - 增加监听事件
    func setupNotification(){
        
        // 监听城市改变
        MTNotificationCenter.addObserver(self, selector: "cityDidChange:", name: MTCityDidChangeNotification, object: nil)

        MTNotificationCenter.addObserver(self, selector: "categoryDidChange:", name: SWCategoryDidChangeNotification, object: nil)
        
        
        MTNotificationCenter.addObserver(self, selector: "regionDidChange:", name: SWRegionDidChangeNotification, object: nil)
        
        MTNotificationCenter.addObserver(self, selector: "sortDidChange:", name: SWSortDidChangeNotification, object: nil)
        
    }
    deinit {
        
        MTNotificationCenter.removeObserver(self)
      

        //NSNotificationCenter.defaultCenter().removeObserver(self, name: SWSelectedRegion, object: nil)
    }
    
    func cityDidChange(notification: NSNotification) {
        
        // 1.更换顶部区域item的文字

        let cityName = notification.userInfo?[MTSelectCityName] as! String
        let topItem = districtItem.customView as! MTHomeTopItem
        topItem.title = "\(cityName) - 全部"
        topItem.subtitle = ""
        
        // TODO: - 刷新表格数据
       // collectionView?.headerBeginRefreshing()
    
        
    }
    
    //MARK: -  顶部item点击方法
    func categoryClicked(){
      
        // 显示分类菜单
        //TODO:不支持9.0
        let popover:UIPopoverController = UIPopoverController(contentViewController: MTCategoryViewController())
        popover.presentPopoverFromBarButtonItem(self.categoryItem, permittedArrowDirections: .Any, animated: true)
    }
    
    
    func districtClick(){
        // 显示区域菜单
        //TODO:不支持9.0
        let popover:UIPopoverController = UIPopoverController(contentViewController: MTDistrictViewController())
        popover.presentPopoverFromBarButtonItem(self.districtItem, permittedArrowDirections: .Any, animated: true)

    }
    
    func sortClick(){
        
        print("sortClick");
    }

    
    
    
    
    
    
    //MARK: -  <UICollectionViewDataSource>
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0;
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier as String, forIndexPath: indexPath)
        return cell
    }
    

    

    
    
    
    
}
