//
//  MTHomeViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHomeViewController: MTDealsViewController,AwesomeMenuDelegate{
    
    let reuseIdentifier = "deal";
    /** 导航栏上的按钮 */
     
    /** 分类item */
    private var categoryItem : UIBarButtonItem!
    /** 排序item */
    private var sortItem : UIBarButtonItem!
    /** 地区item */
    private var regionItem : UIBarButtonItem!

    
    /** 请求参数 */
     /** 当前选中的城市名字 */
    private var selectedCityName : String!
    /** 当前选中的区域名字 */
    private var selectedRegionName : String!
    /** 当前选中的分类名字 */
    private var selectedCategoryName : String!
    /** 当前选中的排序 */
    private var selectedSort : MTSort!
    

    /** 分类popover */
    private var categoryPopover : UIPopoverController?
    /** 区域popover */
    private var regionPopover : UIPopoverController?
    /** 排序popover */
    private var sortPopover : UIPopoverController?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // 增加监听事件
//        setupNotification()
        
        // 设置导航栏属性
        self.setupLeftNav()
        self.setupRightNav()

        // 设置左下角菜单awesomemenu
        setupAwesomeMenu()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 增加监听事件
        self.setupNotification()
    }
    override func viewWillDisappear(animated: Bool) {
        MTNotificationCenter.removeObserver(self)
    }

    

    
    //MARK:设置左下角菜单
    func setupAwesomeMenu() {
        
        // 1.中间按钮
        let startItem = AwesomeMenuItem(image: UIImage(named: "icon_pathMenu_background_highlighted"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_mainMine_normal"), highlightedContentImage: nil)
        // 2.周边按钮
        let item0 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_collect_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_collect_highlighted"))
        let item1 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_scan_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_scan_highlighted"))
        let item2 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_mine_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_mine_highlighted"))
        let item3 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_more_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_more_highlighted"))
        
        let items = [item0, item1, item2, item3]
        
        let menu = AwesomeMenu(frame: CGRectZero, startItem: startItem, optionMenus: items)
        menu.alpha = 0.5
        menu.menuWholeAngle = CGFloat(M_PI_2)
        menu.startPoint = CGPoint(x: 50, y: 150)
        menu.delegate = self
        menu.rotateAddButton = false
        view.addSubview(menu)
        
        // 3.设置菜单永远在左下角
        menu.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 0)
        menu.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 0)
        menu.autoSetDimensionsToSize(CGSizeMake(200, 200))
        
    }
    
    //MARK: - AwesomeMenuDelegate
    func awesomeMenuWillAnimateOpen(menu: AwesomeMenu!) {
        // 替换菜单的图片
        menu.contentImage = UIImage(named:"icon_pathMenu_cross_normal")
        
        // 完全显示
        menu.alpha = 1.0;
    }

    func awesomeMenuWillAnimateClose(menu: AwesomeMenu!) {
        // 替换菜单的图片
        menu.contentImage = UIImage(named:"icon_pathMenu_mainMine_normal")
        
        // 半透明显示
        menu.alpha = 0.5;
    }

    func awesomeMenu(menu: AwesomeMenu!, didSelectIndex idx: Int) {
        // 半透明显示
        menu.alpha = 0.5;
        // 替换菜单的图片
        menu.contentImage = UIImage(named:"icon_pathMenu_mainMine_normal")

        if idx == 0 { // 收藏纪录
            let nav = MTNavigationController(rootViewController: MTCollectViewController())
            presentViewController(nav, animated: true, completion: nil)
        } else if idx == 1 {// 最近访问记录
            let nav = MTNavigationController(rootViewController: MTRecentViewController())
            presentViewController(nav, animated: true, completion: nil)
        }
    }
 

    
    // MARK: - 设置导航栏内容
    func setupLeftNav() {
        

        // 1.LOGO
        let logoItem = UIBarButtonItem(image: UIImage(named: "icon_meituan_logo"), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        logoItem.enabled = false
        
        // 2. 类别
        let categoryTopItem = MTHomeTopItem.item()
        categoryTopItem.addTarget(self, action: "categoryClick")

        let categoryItem = UIBarButtonItem(customView: categoryTopItem)
        self.categoryItem = categoryItem
        

        // 3. 地区
        let regionTopItem = MTHomeTopItem.item()
        regionTopItem.addTarget(self, action: "districtClick")

        let regionItem = UIBarButtonItem(customView: regionTopItem)
        self.regionItem = regionItem


        // 4.排序
        let sortTopItem = MTHomeTopItem.item()
        sortTopItem.addTarget(self, action: "sortClick")
        sortTopItem.title = "排序"
        sortTopItem.setIcon("icon_sort", highIcon: "icon_sort_highlighted")
        let sortItem = UIBarButtonItem(customView: sortTopItem)
        self.sortItem = sortItem
        
        // 添加到导航栏
        navigationItem.leftBarButtonItems = [logoItem, categoryItem, regionItem, sortItem]
        
        
    }
    
    func setupRightNav() {
        
        // 地图按钮
        let map = UIBarButtonItem.ItemWithImageTarget(self, action: "map", image: "icon_map", hightImage: "icon_map_highlighted")
      
        //该按钮的尺寸(间距)
        map.customView!.width = 60;
        
        // 搜索按钮
        let search = UIBarButtonItem.ItemWithImageTarget(self, action: "search", image: "icon_search", hightImage: "icon_search_highlighted")

        search.customView!.width = 60;
        
        // 2.加入到导航栏
        navigationItem.rightBarButtonItems = [map,search]
        
    
    }
    
    

 
    
    
    
    
    
    func setupNotification(){
        
        
        // 监听城市改变
        MTNotificationCenter.addObserver(self, selector: "cityDidChange:", name: MTCityDidChangeNotification, object: nil)
        
        // 监听排序改变
        MTNotificationCenter.addObserver(self, selector: "sortDidChange:", name: MTSortDidChangeNotification, object: nil)
        
        // 监听分类改变
        MTNotificationCenter.addObserver(self, selector: "categoryDidChange:", name: MTCategoryDidChangeNotification, object: nil)
        
        // 监听区域改变
        MTNotificationCenter.addObserver(self, selector: "regionDidChange:", name: MTRegionDidChangeNotification, object: nil)
        
        
        
    }
    deinit {
        
        MTNotificationCenter.removeObserver(self)
        
        
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: SWSelectedRegion, object: nil)
    }
    
    
    // MARK: - 增加监听通知
    func cityDidChange(notification: NSNotification) {
        
        // 1.更换顶部区域item的文字
        self.selectedCityName = notification.userInfo?[MTSelectCityName] as! String
        let topItem = regionItem.customView as? MTHomeTopItem
        topItem!.title = "\(selectedCityName) - 全部"
        topItem!.subtitle = ""

        // 2.刷新表格数据
        self.collectionView?.mj_header.beginRefreshing()
  
    }
    
    
    func categoryDidChange(notification: NSNotification) {
        
        let category  = notification.userInfo![MTSelectCategory] as? MTCategory
        let subcategoryName  = notification.userInfo![MTSelectSubcategoryName] as? String
        
        if (subcategoryName == nil || subcategoryName == "全部") { // 点击的数据没有子分类
            self.selectedCategoryName = category!.name;
        } else {
            self.selectedCategoryName = subcategoryName;
        }
        if (self.selectedCategoryName == "全部分类") {
            self.selectedCategoryName = nil;
        }
        
        // 1.更换顶部item的文字
        let topItem: MTHomeTopItem = self.categoryItem.customView as! MTHomeTopItem
        
        topItem.setIcon(category!.icon!, highIcon: category!.highlighted_icon!)
        topItem.title = category!.name
     
        topItem.subtitle = subcategoryName
        
        // 2.关闭popover
        self.categoryPopover!.dismissPopoverAnimated(true)
        
        // 3.刷新表格数据
        self.collectionView?.mj_header.beginRefreshing()

    }
    

    
    func regionDidChange(notification: NSNotification){
        
        let region: MTRegion  = notification.userInfo![MTSelectRegion] as! MTRegion
        let subregionName  = notification.userInfo?[MTSelectSubregionName] as? String
        
        if (subregionName == nil || subregionName == "全部") { // 点击的数据没有子分类
            
            self.selectedRegionName = region.name! as String
        } else  {
            
            self.selectedRegionName = subregionName;
            print("*\r\n\r\n\r\n子分类\(selectedRegionName)")
        }
        
        
        if (self.selectedRegionName == "全部") {
            
            self.selectedRegionName = nil;
        }

        // 1.更换顶部item的文字
        let topItem: MTHomeTopItem = self.regionItem.customView as! MTHomeTopItem
        
        topItem.title = "\(selectedCityName) - \(region.name)"
        
        topItem.subtitle = subregionName
        
        // 2.关闭popover
        self.regionPopover!.dismissPopoverAnimated(true)
        
        // 3.刷新表格数据
        self.collectionView?.mj_header.beginRefreshing()

    }
    
    func sortDidChange(notification: NSNotification){
    
        self.selectedSort = notification.userInfo![MTSelectSort] as! MTSort
    
        // 1.更换顶部排序item的文字

        let topItem: MTHomeTopItem = self.sortItem.customView as! MTHomeTopItem
        topItem.subtitle = self.selectedSort.label
        // 2.关闭popover
        self.sortPopover!.dismissPopoverAnimated(true)
        
        // 3.刷新表格数据
        self.collectionView?.mj_header.beginRefreshing()
    
    }
    
    
    //MARK: - 实现父类提供的方法
    override func setupParams(params: NSMutableDictionary) {
        // 城市
        params["city"] = self.selectedCityName ?? "全国"
        // 分类(类别)
        if (self.selectedCategoryName != nil) {
            
            if selectedCategoryName == "全部" {
                MBProgressHUD.showError("请选择一个分类",toView: self.view)
            } else {
                params["category"] = selectedCategoryName
            }
            
        }
        // 区域
        if (self.selectedRegionName != nil) {
            params["region"] = self.selectedRegionName;
        }
        // 排序
        if (self.selectedSort != nil) {
            print("*****\(self.selectedSort.value)******\(self.selectedSort)")
            params["sort"] = (self.selectedSort.value);
            
        }
        
    }




    //MARK: -  顶部item点击方法

    func search(){
        

        if ((self.selectedCityName) != nil) {
            let searchVc: MTSearchViewController = MTSearchViewController()
            searchVc.cityName = self.selectedCityName;
            let nav =  MTNavigationController(rootViewController: MTSearchViewController())
            self.presentViewController(nav, animated: true, completion: nil)
        } else {
            MBProgressHUD.showError("请选择城市后再搜索",toView:self.view)
   
        }
          
    }

    
    func map() {
        let nav = MTNavigationController(rootViewController: MTMapViewController())
        presentViewController(nav, animated: true, completion: nil)
    }

    
    
    func categoryClick(){
      
        // 显示分类菜单
        self.categoryPopover = UIPopoverController(contentViewController: MTCategoryViewController())
        self.categoryPopover!.presentPopoverFromBarButtonItem(self.categoryItem, permittedArrowDirections: .Any, animated: true)
        //TODO:不支持9.0

    }
    
    
    func districtClick(){
        // 显示区域菜单
        //TODO:不支持9.0
        // 得到当前选中城市的区域
        let region: MTRegionViewController = MTRegionViewController()
        if ((self.selectedCityName) != nil) {
            // 获得当前选中城市
            
            let predicate: NSPredicate = NSPredicate(format: "name = %@", self.selectedCityName)
            let city: MTCity = MTMetaTool.cities?.filteredArrayUsingPredicate(predicate).first as! MTCity
            print("**\r\n***\(city.regions?.count)")
            region.regions = city.regions;
        }
        
        // 显示区域菜单
        self.regionPopover = UIPopoverController(contentViewController: region)
         self.regionPopover!.presentPopoverFromBarButtonItem(regionItem, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
       
        region.popover = self.regionPopover;

    }
    
    func sortClick(){
        
        // 显示排列菜单

        self.sortPopover = UIPopoverController(contentViewController: MTSortViewController())
        self.sortPopover!.presentPopoverFromBarButtonItem(sortItem, permittedArrowDirections: .Any, animated: true)

        print("sortClick");

    }

    
    
    
    



}
