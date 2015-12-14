//
//  MTDealsViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/14.
//  Copyright © 2015年 sijichcai. All rights reserved.
//


//  团购列表控制器(父类)
import UIKit


class MTDealsViewController: UICollectionViewController,DPRequestDelegate {
    
    private let reuseIdentifier = "deal"

    //MARK: -设置请求参数:交给子类去实现
    func setupParams(params:NSMutableDictionary){
        
    }
    
    /**
    *  设置请求参数:交给子类去实现
    */
    var params:NSMutableDictionary!
    
    /** 记录当前页码 */
    var  currentPage:Int = 1
    /** 总数 */
    var  totalCount:Int!
    
    /** 最后一个请求 */
    var lastRequest: DPRequest!
    
    /** 所有的团购数据 *///MARK: - 懒加载
    lazy var deals:NSMutableArray? = {
        
        let ani = NSMutableArray()
        
        return ani
    }()

    lazy var noDataView:UIImageView? = {
        // 添加一个"没有数据"的提醒
        let ani = UIImageView(image: UIImage(named:"icon_deals_empty"))
        self.view.addSubview(ani)
        ani.autoCenterInSuperview()
        return ani
        }()

        
     //这是一个便利构造器
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(305, 305)
        let cols: CGFloat = (UIScreen.mainScreen().bounds.width == 1024) ? 3 : 2
        
        let inset = (UIScreen.mainScreen().bounds.width - cols * layout.itemSize.width) / (cols + 1)
        
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset)
        
        layout.minimumLineSpacing = inset
        self.init(collectionViewLayout: layout)
    }



    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.collectionView?.registerNib(UINib(nibName: "MTDealCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.alwaysBounceVertical = true

        // Add Refresh
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadNewDeals()
        })
        self.collectionView?.mj_footer = MJRefreshAutoFooter(refreshingBlock: { () -> Void in
            self.loadMoreDeals()
        })

    }
    
    /**
     当屏幕旋转,控制器view的尺寸发生改变调用
     */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator?) {
        
        // 根据屏幕宽度决定列数
        let cols: CGFloat = (size.width == 1024) ? 3 : 2
        // 根据列数计算内边距
        let layout =  UICollectionViewFlowLayout()
        let inset = (size.width - cols * layout.itemSize.width) / (cols + 1)
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset)
        // 设置每一行之间的间距
        layout.minimumLineSpacing = inset
        
    }
    
    
    //MARK: - 跟服务器交互请求数据方法
    func loadDeals() {
        let api = DPAPI()
        
        let params: NSMutableDictionary = NSMutableDictionary()
        // 调用子类实现的方法
        self.setupParams(params)

        
        // 每页条数
        params["limit"] = "30"
        
        // 当前页码
        params["page"] = String(currentPage)
        print("***跟服务器交互请求数据方法\r\n**\(params)")
        lastRequest = api.requestWithURL("v1/deal/find_deals", params: params, delegate: self)
        self.collectionView?.reloadData()
    }

    
    func loadNewDeals() {
        currentPage = 1
        loadDeals()
    }
    
    func loadMoreDeals() {
        currentPage++
        loadDeals()
    }
    
    
    
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        
        MBProgressHUD.showSuccess("请求成功")
        print("**请求成功请求成功请求成功***\(result)")
        //MBProgressHUD.showError(, toView: self.view)
        if request != lastRequest {
            return
        }
        self.totalCount? = result["total_count"] as! Int
        
        // 1.取出团购的字典数组
        let newDeals: NSArray  = MTDeal.mj_objectArrayWithKeyValuesArray(result["deals"])
        if (self.currentPage == 1) { // 清除之前的旧数据
           self.deals!.removeAllObjects()
        }
       self.deals?.addObjectsFromArray(newDeals as [AnyObject])
        // 3.结束上拉加载
        self.collectionView?.mj_header.endRefreshing()
        self.collectionView?.mj_footer.endRefreshing()
        
        // 2.刷新表格
        collectionView!.reloadData()
        
        
    }
    
    
    
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        
        if (request != self.lastRequest){
           return
        }
        
        // 1.提醒失败
        MBProgressHUD.showError("网络繁忙,请求失败，请求失败,请稍后再试", toView: self.view)

        // 2.结束刷新
        self.collectionView?.mj_header.endRefreshing()
        self.collectionView?.mj_footer.endRefreshing()
        
        // 3.如果是上拉加载失败了
        if (self.currentPage > 1) {
            self.currentPage--
        }

        print("请求失败--%@", error);
    }
    


    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        // 计算一遍内边距
        self.viewWillTransitionToSize(CGSizeMake(collectionView.width, 0), withTransitionCoordinator:nil)
        
        // 控制尾部刷新控件的显示和隐藏
        //self.collectionView?.mj_footer.hidden = (self.totalCount == self.deals!.count);
        
        // 控制"没有数据"的提醒
        self.noDataView!.hidden = (self.deals!.count != 0);
        print("**numberOfItemsInSection***\( self.deals!.count)")
        return self.deals!.count;
    }


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MTDealCell
        
        cell.deal = self.deals![indexPath.item] as? MTDeal
        
        return cell
    }



    // MARK: UICollectionViewDelegate


}
