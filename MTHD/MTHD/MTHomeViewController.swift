//
//  MTHomeViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHomeViewController: UICollectionViewController,DPRequestDelegate {
    
    let reuseIdentifier = "Cell";
    /** 导航栏上的按钮 */
     
    /** 分类item */
    private var categoryItem : UIBarButtonItem!
    /** 排序item */
    private var sortItem : UIBarButtonItem!
    /** 地区item */
    private var regionItem : UIBarButtonItem!
    /** 地区item */
   // private var districtItem : UIBarButtonItem!
    

    /** 分类popover */
    private var categoryPopover : UIPopoverController?
    /** 区域popover */
    private var regionPopover : UIPopoverController?
    /** 排序popover */
    private var sortPopover : UIPopoverController?
    
    
    
    /** 请求参数 */
    /** 当前选中的城市名字 */
    private var selectedCityName : String!
    /** 当前选中的区域名字 */
    private var selectedRegionName : String!
    /** 当前选中的分类名字 */
    private var selectedCategoryName : String!
    /** 当前选中的排序 */
    private var selectedSort : MTSort!


    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        
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
       self.loadNewDeals()
    
        
    }
    
    func categoryDidChange(notification: NSNotification) {
        
        let category: MTCategory  = notification.userInfo![MTSelectCategory] as! MTCategory
        let subcategoryName: String  = notification.userInfo![MTSelectSubcategoryName] as! String
        
        if (subcategoryName.isEmpty == true || subcategoryName == "全部") { // 点击的数据没有子分类
            self.selectedCategoryName = category.name;
        } else {
            self.selectedCategoryName = subcategoryName;
        }
        if (self.selectedCategoryName == "全部分类") {
            self.selectedCategoryName = nil;
        }
        
        // 1.更换顶部item的文字
        let topItem: MTHomeTopItem = self.categoryItem.customView as! MTHomeTopItem
        
        topItem.setIcon(category.icon!, highIcon: category.highlighted_icon!)
        topItem.title = category.name
     
        topItem.subtitle = subcategoryName
        
        // 2.关闭popover
        self.categoryPopover!.dismissPopoverAnimated(true)
        
        // 3.刷新表格数据
        self.loadNewDeals()

    }
    

    
    func regionDidChange(notification: NSNotification){
        
        let region: MTRegion  = notification.userInfo![MTSelectRegion] as! MTRegion
        let subregionName: String  = notification.userInfo![MTSelectSubregionName] as! String
        
        if (subregionName.isEmpty == true || subregionName == "全部") { // 点击的数据没有子分类
            self.selectedRegionName = region.name! as String
        } else {
            self.selectedRegionName = subregionName;
        }
        if (self.selectedRegionName == "全部分类") {
            self.selectedRegionName = nil;
        }

        // 1.更换顶部item的文字
        let topItem: MTHomeTopItem = self.regionItem.customView as! MTHomeTopItem
        
        topItem.title = "\(selectedCityName) - \(region.name)"
        
        topItem.subtitle = subregionName
        
        // 2.关闭popover
        self.regionPopover!.dismissPopoverAnimated(true)
        
        // 3.刷新表格数据
        self.loadNewDeals()

    }
    
    func sortDidChange(notification: NSNotification){
    
        self.selectedSort = notification.userInfo![MTSelectSort] as! MTSort
    
        // 1.更换顶部排序item的文字

        let topItem: MTHomeTopItem = self.sortItem.customView as! MTHomeTopItem
        topItem.subtitle = self.selectedSort.label
        // 2.关闭popover
        self.sortPopover!.dismissPopoverAnimated(true)
        
        // 3.刷新表格数据
        self.loadNewDeals()
    
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: -  顶部item点击方法
    func categoryClicked(){
      
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

    
    
    
    
    //MARK:  - 跟服务器交互
    func loadNewDeals(){

        let api = DPAPI()
        let params: NSMutableDictionary = NSMutableDictionary()
        // 城市
        params["city"] = self.selectedCityName;
        // 每页的条数
        params["limit"] = 5
        // 分类(类别)
        if ((self.selectedCategoryName) != nil) {
            params["category"] = self.selectedCategoryName;
        }
        // 区域
        if ((self.selectedRegionName) != nil) {
            params["region"] = self.selectedRegionName;
        }
        // 排序
        if ((self.selectedSort) != nil) {
            params["sort"] = (self.selectedSort.value);
        }
        api.requestWithURL("v1/deal/find_deals", params: params, delegate: self)

        print("请求参数:%@", params);
    }
    
    
    
    
    
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        //print("请求成功--%@", result);
        
    }
    
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        
        //MBProgressHUD.showError("网络繁忙，请稍后再试")
        //print("请求失败--%@", error);
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
