//
//  MTDealTool.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/15.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTDealTool: NSObject {
    
    
    
    static var db: FMDatabase?
    //MARK: - 懒加载
    
    override class func initialize(){
        // 1.打开数据库
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        let path = documentPath.stringByAppendingPathComponent("n.sqlite")
        print("*****\(path)")
        // 2.创表
        // 创建FMDatabaseQueue对象会自动打开数据库,如果数据库不存在会创建数据库
        // 后续的所有数据库操作都是通过dbQueue来调用
        db = FMDatabase(path: path)
        if db!.open() == false {
            return
        }
        // 2.创表
        let sql:String = "CREATE TABLE IF NOT EXISTS t_collect_deal (id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"
        let sqq:String = "CREATE TABLE IF NOT EXISTS t_recent_deal (id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"
        db!.executeUpdate(sql, withArgumentsInArray: nil)
        db!.executeUpdate(sqq, withArgumentsInArray: nil)
    }
    
    



    /// 返回第page页的收藏团购数据:page从1开始
   class func collectDeals(page: Int) -> NSArray {
        let size: Int = 2
        let pos: Int = (page - 1) * size
        
        let sql = "SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT ?, ?"
        let set = db!.executeQuery(sql, withArgumentsInArray: [pos, size])
        let result = NSMutableArray()
        while set!.next() {
            let data = set!.objectForColumnName("deal") as! NSData
            let deal = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! MTDeal
            result.addObject(deal)
        }
        return result
    }
    
    /// 收藏一个团购
   class func addCollectDeal(deal: MTDeal) {
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(deal)
        let sql = "INSERT INTO t_collect_deal(deal, deal_id) VALUES(?, ?)"
         db!.executeUpdate(sql, withArgumentsInArray: [data, deal.deal_id])
    }
    
    /// 取消收藏一个团购
    class func removeCollectDeal(deal: MTDeal) {
        //TODO:不可以写成这样,不能识别
       // db!.executeUpdate("DELETE FROM t_collect_deal WHERE deal_id = \(deal.deal_id);",withArgumentsInArray: nil)
        let apl = "DELETE FROM t_collect_deal WHERE deal_id = ?"
        
        db!.executeUpdate(apl, withArgumentsInArray: [deal.deal_id])
    }
    
    
    /// 团购是否收藏
    class func isCollected(deal: MTDeal) -> Bool {
        let sql = "SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = ?;"
        let set =  db!.executeQuery(sql, withArgumentsInArray:[deal.deal_id])
        if set == nil {
            return false
        }
        set!.next()//#warning 索引从1开始
        return set!.intForColumn("deal_count") == 1
    }

    /// 团购收藏个数
    class func collectDealsCount() -> Int {
        let sql = "SELECT count(*) AS deal_count FROM t_collect_deal;"
        let set =  db!.executeQuery(sql,withArgumentsInArray: nil)
        set!.next()
        return Int(set!.intForColumn("deal_count"))
    }

    
    
    
    
    

    
//   class func addRecentDeal(deal: MTDeal) {
//        
//        let data = NSKeyedArchiver.archivedDataWithRootObject(deal)
//        let sql = "INSERT INTO t_recent_deal(deal, deal_id) VALUES(?, ?)"
//        let suc =  db!.executeUpdate(sql, withArgumentsInArray: [data, deal.deal_id])
//    }
//    
//
//    
//   class func removeRecentDeal(deal: MTDeal) {
//       db!.executeUpdate("DELETE FROM t_recent_deal WHERE deal_id = '\(deal.deal_id)';")
//    }
//    

    


}
