//
//  MTCollectViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/14.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit


class MTCollectViewController: UICollectionViewController {
    
    private let reuseIdentifier = "deal"
    let MTDone = "完成"
    let MTEdit = "编辑"
    
    
    func MTString(str:String) -> String {
    
        return NSString(format: "  %@  ", str) as String
    }
    
    var currentPage = 0
    
    lazy var backItem: UIBarButtonItem = {
        return UIBarButtonItem.ItemWithImageTarget(self, action: "back", image: "icon_back", hightImage: "icon_back_highlighted")
    }()
    
    lazy var selectAllItem: UIBarButtonItem = {
        return UIBarButtonItem(title:self.MTString("全选"), style: UIBarButtonItemStyle.Done, target: self, action: "selectAll")
    }()
    
    lazy var unselectAllItem: UIBarButtonItem = {
        return UIBarButtonItem(title:self.MTString("全不选"), style: UIBarButtonItemStyle.Done, target: self, action: "unSelectAll")
    }()
    
    lazy var removeItem: UIBarButtonItem = {
        return UIBarButtonItem(title:self.MTString("删除"), style: UIBarButtonItemStyle.Done, target: self, action: "remove")
    }()
    
    
    
    lazy var editItem: UIBarButtonItem = {
        [unowned self] in
        return UIBarButtonItem(title: self.MTEdit, style: UIBarButtonItemStyle.Done, target: self, action: "edit:")
        }()
    
    lazy var deals: NSMutableArray = {
        return NSMutableArray()
    }()
    
//    lazy var noDataView: UIImageView = {
//        [unowned self] in
//        let v = UIImageView(image: UIImage(named: "icon_collect_empty"))
//        self.view.addSubview(v)
//        v.autoCenterInSuperview
//        v.hidden = true
//        return v
//        }()
    lazy var noDataView:UIImageView? = {
        
        let ani = UIImageView(image: UIImage(named: "icon_collects_empty"))
        ani.hidden = true
        self.view.addSubview(ani)
        ani.autoCenterInSuperview()
        

        return ani
    }()

    
    
    
    
    

    
    // 这是一个便利构造器
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
        
        title = "收藏的团购"
        collectionView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        
        // 返回
        // 左边的返回
        self.navigationItem.leftBarButtonItems = [self.backItem];
        collectionView?.alwaysBounceVertical = true
        navigationItem.rightBarButtonItems = [editItem]


        // 监听收藏状态改变的通知
        MTNotificationCenter.addObserver(self, selector: "collectStateChange:", name: MTCollectStateDidChangeNotification, object: nil)
        // 添加上啦加载

        self.collectionView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreDeals()
        })
        self.collectionView?.mj_footer.automaticallyHidden
        // 加载第一页的收藏数据
        loadMoreDeals()
        // 设置导航栏内容
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: MTEdit, style: UIBarButtonItemStyle.Done, target: self, action: "edit:")

    }

    func edit(item: UIBarButtonItem) {
        if item.title == MTEdit {
            item.title = MTDone
            
            // 设置左侧导航栏出现按钮
            navigationItem.leftBarButtonItems = [backItem, selectAllItem, unselectAllItem, removeItem]
            
//            // 设置cell进入编辑选项
//            for deal in deals {
//                deal.edit = true
//            }
//            
//            removeItem.enabled = false
//            
        } else {
            item.title = MTEdit
            
            navigationItem.leftBarButtonItems = [backItem]
            
//            for deal in deals {
//                deal.edit = false
//            }
        }
        collectionView?.reloadData()
    }

    func loadMoreDeals() {
        
        // 1.增加页码
        self.currentPage++;
        
        // 2.增加新数据
        self.deals.addObjectsFromArray(MTDealTool.collectDeals(self.currentPage) as [AnyObject])
        
        // 3.刷新表格
        collectionView?.reloadData()
        
        // 4.结束刷新

        self.collectionView?.mj_footer.endRefreshing()

    }
    
    func collectStateChange(notification:NSNotification) {
        
//        if ((notification.userInfo![MTIsCollectKey]?.boolValue) != nil){
//            // 收藏成功
//            self.deals.insertObject(notification.userInfo![MTIsCollectKey]!, atIndex: 0)
//    
//        }else {
//            // 取消收藏成功
//            self.deals.removeObject(notification.userInfo![MTIsCollectKey]!)
//          
//            
//        }
        currentPage = 0
        self.deals.removeAllObjects()

        loadMoreDeals()
    }

    
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
     当屏幕旋转,控制器view的尺寸发生改变调用
     */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator?) {
        
        // 根据屏幕宽度决定列数
        // 根据列数计算内边距
        
        let cols: CGFloat = (size.width == 1024) ? 3 : 2
        
        //MARK: 💗一定要是self.collectionViewLayout as! UICollectionViewFlowLayout 不然尺寸不对
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let inset = (size.width - cols * layout.itemSize.width) / (cols + 1)
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset)
        // 设置每一行之间的间距
        layout.minimumLineSpacing = inset
        print("**屏幕宽度***\(size.width)*****每一行之间的间距\(inset) ****\(cols * layout.itemSize.width)) ***\(cols)")
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        // 计算一遍内边距
        //self.viewWillTransitionToSize(CGSizeMake(collectionView.width, 0), withTransitionCoordinator:nil)
        // 控制尾部刷新控件的显示和隐藏

        self.collectionView?.mj_footer.hidden = ( self.deals.count == MTDealTool.collectDealsCount());
        print("***\(self.collectionView?.mj_footer.hidden)**\(self.deals.count)---\(MTDealTool.collectDealsCount())")
        // 控制"没有数据"的提醒
        self.noDataView!.hidden = (self.deals.count != 0);
        
        return self.deals.count;
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MTDealCell
        
        cell.deal = self.deals[indexPath.item] as? MTDeal
        
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailVc: MTDetailViewController = MTDetailViewController()
        detailVc.deal = self.deals[indexPath.item] as! MTDeal;
        presentViewController(detailVc, animated: true, completion: nil)
        
    }

    
    
    
    
    
    
    
 
//    func selectAll() {
//        for deal in deals {
//            deal.checking = true
//        }
//        collectionView?.reloadData()
//        
//        selectAllItem.enabled = false
//        unselectAllItem.enabled = true
//        removeItem.enabled = true
//    }
//    
//    func unSelectAll() {
//        for deal in deals {
//            deal.checking = false
//        }
//        collectionView?.reloadData()
//        
//        unselectAllItem.enabled = false
//        selectAllItem.enabled = true
//        removeItem.enabled = false
//    }
    
    
    
    
    
    
    


}
