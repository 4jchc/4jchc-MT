//
//  MTCityViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTCityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate{
    
    @IBOutlet weak var cover: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cityGroups : NSArray?
    //MARK: - 懒加载
    lazy var citySearchResult:MTCitySearchResultViewController! = {
        
        let ani = MTCitySearchResultViewController()
        self.addChildViewController(ani)
        self.view.addSubview(ani.view)
        ani.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top)
        ani.view.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.searchBar, withOffset: 15)
        ani.view.backgroundColor = UIColor.redColor()
        return ani
    }()
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 读取xib文件//TODO:读取xib文件
        NSBundle.mainBundle().loadNibNamed("MTCityViewController", owner: self, options: nil)
        
        // 2.设置导航栏
        navigationItem.title = "切换城市"
        navigationItem.leftBarButtonItem = UIBarButtonItem.ItemWithImageTarget(self, action: "close", image: "btn_navigation_close", hightImage: "btn_navigation_close_hl")
        tableView.sectionIndexColor = UIColor.blackColor()
        
        // 加载城市数据
        self.cityGroups = MTCityGroup.mj_objectArrayWithFilename("cityGroups.plist")
        self.searchBar.tintColor = UIColor.RGB(32, 191, 179, 1)
    }
    
    func close() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - UISearchBarDelegate
    
    // 当搜索栏开始编辑的时候
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        // 1.隐藏掉nav
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 2.显示遮盖
        
        //MARK: - 添加手势调用搜索框的编辑响应来移除遮盖
        self.cover.addGestureRecognizer(UITapGestureRecognizer(target: searchBar, action: "resignFirstResponder"))
        
        // 3.修改搜索框的背景图片
        
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield_hl")
        searchBar.setShowsCancelButton(true, animated: true)
        // 4.加上遮盖
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.cover.alpha = 0.4
            self.cover.endEditing(true)
        })
    }
    
    
    
    
    
    // 当搜索栏结束编辑的时候
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        print("searchBarTextDidEndEditing")
        // 1.隐藏掉nav
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // 2.修改搜索框的背景图片
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield")
        searchBar.setShowsCancelButton(false, animated: true)
        
        // 3.取消遮盖(在tableview上添加一个view)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.cover.alpha = 0.0
            
        })
        
        // 4.移除搜索结果
        self.citySearchResult.view.hidden = true
        searchBar.text = nil
    }
    
    /**
     *  搜索框里面的文字变化的时候调用
     */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true { //为空
            self.citySearchResult.view.hidden = true
        } else {
            self.citySearchResult.view.hidden = false
            print("**\r\n***\(searchText)")
            self.citySearchResult.searchText = searchText;
   
        }
        
        
        
    }
    
    // 当搜索栏的cancel键被点击
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - UITableViewDelegate
    

    

    
    
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        // 获得选中的城市
    //        let city : String! = cityGroups[indexPath.section].cities?[indexPath.row]
    //
    //        // 发出通知
    //        NSNotificationCenter.defaultCenter().postNotificationName(SWCityDidChangeNotification, object: nil, userInfo: [SWSelectedCityName: city])
    //
    //        // dismiss
    //        dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let group: MTCityGroup = self.cityGroups![section] as! MTCityGroup;
        return group.cities!.count;
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.cityGroups!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let ID:String = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID  as String)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID as String)
        }
        
        let group = self.cityGroups![indexPath.section] as! MTCityGroup
        cell!.textLabel?.text = group.cities![indexPath.row] as? String
        
        return cell!
    }
    
    
    
    
    
    
    
    
    
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return cityGroups?.valueForKeyPath("title") as? [String]
        
        /// return cityGroups.map{_ in title} as? [String]
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let group: MTCityGroup = self.cityGroups![section] as! MTCityGroup
        return group.title as? String
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 获得选中的城市
        let group = self.cityGroups![indexPath.section] as! MTCityGroup
        // 发出通知
        MTNotificationCenter.postNotificationName(MTCityDidChangeNotification, object: nil, userInfo: [MTSelectCityName : group.cities![indexPath.row]])
        
        // dissmiss自身
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    

    
}
