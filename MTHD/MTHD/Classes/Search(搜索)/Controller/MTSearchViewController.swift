//
//  MTSearchViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/14.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTSearchViewController: MTDealsViewController,UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 左边的返回
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.ItemWithImageTarget(self, action: "back", image: "icon_back ", hightImage: " icon_back_highlighted")

        
        //    UIView *titleView = [[UIView alloc] init];
        //    titleView.width = 300;
        //    titleView.height = 35;
        //    titleView.backgroundColor = [UIColor redColor];
        //    self.navigationItem.titleView = titleView;
        
        // 中间的搜索框
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "请输入关键词";
        searchBar.delegate = self;
        self.navigationItem.titleView = searchBar;
        //    searchBar.frame = titleView.bounds;
        //    [titleView addSubview:searchBar];
    }

    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }

   //MARK: -  搜索框代理
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // 进入下拉刷新状态, 发送请求给服务器
        self.collectionView?.mj_header.beginRefreshing()
        // 退出键盘
        searchBar.resignFirstResponder()
        
    }
    //MARK:  - 实现父类提供的方法
    override func setupParams(params: NSMutableDictionary) {
        params["city"] = "北京";
        let bar: UISearchBar  = self.navigationItem.titleView as! UISearchBar
        params["keyword"] = bar.text;
    }



}
