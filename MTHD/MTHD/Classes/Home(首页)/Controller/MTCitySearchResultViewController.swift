//
//  MTCitySearchResultViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/11.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTCitySearchResultViewController: UITableViewController {

    //MARK: - 懒加载

     var resultCities:NSArray?

    var searchText:NSString?{
        
        didSet{
            searchText = searchText!.lowercaseString;

            //MARK: - 过滤器NSPredicate
            // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
           // resultCities.removeAll(keepCapacity: false)
            
//            for var city:MTCity  in MTMetaTool.cities! {
//                // 城市的name中包含了searchText
//                // 城市的pinYin中包含了searchText beijing
//                // 城市的pinYinHead中包含了searchText
//                if ((city.name?.rangeOfString(searchText) != nil) || (city.pinYin?.rangeOfString(searchText) != nil) || (city.pinYinHead?.rangeOfString(searchText) != nil) ) {
//                    resultCities.append(city.name!)
//                }
//            }
//            tableView.reloadData()
            

            let predicate:NSPredicate = NSPredicate(format: "name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText!, searchText!, searchText!)
           
            self.resultCities = MTMetaTool.cities!.filteredArrayUsingPredicate(predicate)
           
            self.tableView.reloadData()
            
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        
        return  self.resultCities?.count ?? 0
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let ID:String = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID  as String)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID as String)
        }
        let city: MTCity = self.resultCities![indexPath.row] as! MTCity;
        cell!.textLabel!.text = city.name;
        return cell!
    }


    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        if  let e = self.resultCities?.count {
            
            return "共有\(e)个搜索结果"
        }else {
            
             return "共有\0个搜索结果"
        }
        //return "共有\(resultCities!.count)个搜索结果"
       
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 获得选中的城市
        let city = resultCities![indexPath.row]
        // 发出通知
        MTNotificationCenter.postNotificationName(MTCityDidChangeNotification, object: nil, userInfo: [MTSelectCityName : city.name])
        
        // dissmiss自身
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
