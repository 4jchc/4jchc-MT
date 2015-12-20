//
//  MTMapViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/18.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
import MapKit
class MTMapViewController: UIViewController ,MKMapViewDelegate,DPRequestDelegate{

    //    private var annotations: [SWAnnotation] = []
    //
    //    private var locationManage: CLLocationManager!
    
    private var city: NSString!
    
    private var category: String!
    /** 分类item */
    private var categoryItem: UIBarButtonItem!
    /** 分类popover */
    private var categoryPopover: UIPopoverController!
    private var selectedCategoryName: NSString!
    private var selectedSubCategory: String!
    
    private var lastRequest: DPRequest!
    ///#pragma mark -定位管理者 懒加载
    lazy var mgr:CLLocationManager! = {
        
        let ani = CLLocationManager()
        
        return ani
    }()
    @IBOutlet weak var mapView: MKMapView!
    
    
    /** 解码 */
    lazy var coder: CLGeocoder = {
        return CLGeocoder()
    }()
    override func loadView() {
        super.loadView()
        NSBundle.mainBundle().loadNibNamed("MTMapViewController", owner: self, options: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注意:在iOS8中, 如果想要追踪用户的位置, 必须自己主动请求隐私权限
        if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0{
            // 主动请求权限

            self.mgr.requestAlwaysAuthorization()
        }
        
        /// 设置不允许地图旋转
        self.mapView.rotateEnabled = false
        
        /// 成为mapVIew的代理
        self.mapView.delegate = self;
        // 左边的返回
        let backItem = UIBarButtonItem.ItemWithImageTarget(self, action: "back", image: "icon_back", hightImage: "icon_back_highlighted")
        self.title = "地图"
        // 设置地图跟踪用户位置改变
        self.mapView.userTrackingMode = MKUserTrackingMode.Follow
        
        
        // 设置左上角的分类菜单
        let categoryTopItem = MTHomeTopItem.item()
        categoryTopItem.addTarget(self, action: "categoryClick")
        
        let categoryItem = UIBarButtonItem(customView: categoryTopItem)
        self.categoryItem = categoryItem
        self.navigationItem.leftBarButtonItems = [backItem, categoryItem];
        // 监听分类改变
        MTNotificationCenter.addObserver(self, selector: "categoryDidChange:", name: MTCategoryDidChangeNotification, object: nil)
        
    }
    
    
    func categoryClick(){
        
        // 显示分类菜单
        self.categoryPopover = UIPopoverController(contentViewController: MTCategoryViewController())
        self.categoryPopover!.presentPopoverFromBarButtonItem(self.categoryItem, permittedArrowDirections: .Any, animated: true)
        //TODO:不支持9.0
        
    }
    func categoryDidChange(notification: NSNotification) {
        
        // 1.关闭popover
        self.categoryPopover!.dismissPopoverAnimated(true)
        
        // 2.获得要发送给服务器的类型名称
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

        
        // 3.删除之前的所有大头针
        self.mapView.removeAnnotations(self.mapView.annotations)
     
        
        // 4.重新发送请求给服务器
        self.mapView(self.mapView, regionDidChangeAnimated: true)
        
        // 5.更换顶部item的文字
        let topItem: MTHomeTopItem = self.categoryItem.customView as! MTHomeTopItem
        
        topItem.setIcon(category!.icon!, highIcon: category!.highlighted_icon!)
        topItem.title = category!.name
        
        topItem.subtitle = subcategoryName

    }
    deinit {
        
        MTNotificationCenter.removeObserver(self)
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: SWSelectedRegion, object: nil)
    }
    
    
    
    
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    ///定位
    @IBAction func backToUserLocation(sender: UIButton) {
        
        self.mapView.setCenterCoordinate(self.mapView.userLocation.coordinate, animated: true) 
    }
    //MARK: - MKMapViewDelegate

//    @available(iOS 9.0, *)
//    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {

//    }
    
        // 用户位置更新时调用(第一次定位)
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        // 让地图显示到用户所在的位置
        //self.mapView.setCenterCoordinate(userLocation.location!.coordinate, animated: true)
        // 1.设置显示区域大小
        // 让地图显示到用户所在的位置
        let region = MKCoordinateRegionMake(userLocation.location!.coordinate, MKCoordinateSpanMake(0.3, 0.3))
        self.mapView.setRegion(region, animated: false)
        // 经纬度 --> 城市名 : 反地理编码
        // 城市名 --> 经纬度 : 地理编码
        
        self.coder.reverseGeocodeLocation(userLocation.location!) { (placemarks, error) -> Void in
            print("*****\(placemarks)******\(error)")
            if (error != nil || placemarks!.isEmpty == true) {
                
                MBProgressHUD.showError("定位失败", toView: self.view)
                return
            
            }
            let pm:CLPlacemark = (placemarks?.first)!
            let city:NSString = (pm.locality != nil) ? pm.locality! : pm.addressDictionary!["State"] as! NSString
            print("*city****\(city)")
            self.city = city.substringToIndex(city.length - 1)
            
           // self.city = self.city!.substringToIndex(self.city!.endIndex.advancedBy(-1))//最后一个Index-1
            
            // 第一次发送请求给服务器
            
            self.mapView(self.mapView, regionDidChangeAnimated: true)
           
        }

    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        
        // TODO : - 用户区域发生改变的时候，重新发生请求
        if city == nil { return }
        // 发送请求给服务器
        let api = DPAPI()
        // 城市
        print("***用户区域发生改变的时候**\(city)")
        let params: NSMutableDictionary = ["city": self.city]
        // 类别
        print("**category**\(selectedCategoryName)")
        if selectedCategoryName != nil {
            params["category"] = self.selectedCategoryName
            
        }
        params["latitude"] = String("\(mapView.region.center.latitude)")
        params["longitude"] = String("\(mapView.region.center.longitude)")
        params["radius"] = "5000"
        
        self.lastRequest = api.requestWithURL("v1/deal/find_deals", params: params, delegate: self)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 返回nil,意味着交给系统处理
        
        if annotation.isKindOfClass(MTDealAnnotation.classForCoder()) == false{
            return nil
        }
        // 创建大头针控件
        let ID = "test"
        var annoView = mapView.dequeueReusableAnnotationViewWithIdentifier(ID)
        if annoView == nil {
            annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: ID)

        }
        
        let annotation = annotation as! MTDealAnnotation
        // 设置模型(位置\标题\子标题)
        annoView!.annotation = annotation 
        // 设置图片
        
        guard let icon = annotation.icon else {return nil}
        annoView!.image = UIImage(named: icon)
        ///显示标题
        annoView!.canShowCallout = true

       annoView?.annotation
        return annoView

    }
    

    
    
    //MARK: - 请求代理
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        
        if (request != self.lastRequest) {
            return
        }
        MBProgressHUD.showError("网络繁忙，请稍后再试",toView: self.view)
        print(error)
    }
    
    
    
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        
        if (request != self.lastRequest) {
            return
        }
        let deals:NSArray = MTDeal.mj_objectArrayWithKeyValuesArray(result["deals"])
        for deal in deals {
            let deal = deal as? MTDeal
            // 获得团购所属的类型

            let category: MTCategory?  = MTMetaTool.categoryWithDeal(deal!) != nil ?MTMetaTool.categoryWithDeal(deal!) : nil
             print("类型*\(category?.map_icon)")
            for business in deal!.businesses  {
                let business = business as! MTBusiness
                let anno:MTDealAnnotation = MTDealAnnotation()
                anno.coordinate = CLLocationCoordinate2DMake(Double(business.latitude), Double(business.longitude))
                anno.title = business.name;
                anno.subtitle = deal!.title;
                if let category = category{
                    anno.icon = category.map_icon
                }
                
                let annos = mapView.annotations as NSArray
                if annos.containsObject(anno){
                    break
                }
//                if annos.contains({ (dealAnnotation) -> Bool in
//                    if dealAnnotation is MTDealAnnotation{
//                        
//                        return dealAnnotation.isEqual(anno)
//                    }
//                    return false
//                }){
//                    continue
//                }

                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.mapView.addAnnotation(anno)
                })
                
                
            }
        }

    }
    
    
    
}
