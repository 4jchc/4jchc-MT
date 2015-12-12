//
//  MTSortViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/12.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTSortButton: UIButton {
    
    private var sort : MTSort! {
        didSet {
            setTitle(sort.label, forState: UIControlState.Normal)
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        self.setBackgroundImage(UIImage(named: "btn_filter_normal"), forState: UIControlState.Normal)
        self.setBackgroundImage(UIImage(named: "btn_filter_selected"), forState: UIControlState.Highlighted)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






class MTSortViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let sorts = MTMetaTool.sorts!

        let btnW : CGFloat = 100
        let btnH : CGFloat = 30
        let btnMargin : CGFloat = 10

        let count = sorts.count;
        let btnX:CGFloat = 15;
        let btnStartY:CGFloat = 15;
        var height:CGFloat = 0;


        
        // 3.设置button位置
        for i in 0..<count {
            
            // 初始化button数组
            let button = MTSortButton()
            // 传递模型
            button.sort = sorts[i] as! MTSort;
            button.width = btnW;
            button.height = btnH;
            button.x = btnX;
            button.y = btnStartY + CGFloat(i) * (btnH + btnMargin);
            button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)

            button.tag = i;
            view.addSubview(button)
            
            height = CGRectGetMaxY(button.frame);
        }
        
        
        // 设置控制器在popover中的尺寸
        let width: CGFloat = btnW + 2 * btnX;
        height += btnMargin;
        self.preferredContentSize = CGSizeMake(width, height);

        
    }
    // MARK: - 按键触发事件（通过view.tag来区分是哪个按钮）
    func buttonClicked(button: MTSortButton) -> Void {
        print("clicked \(button.tag)")
        
        // 发送通知
        MTNotificationCenter.postNotificationName(MTSortDidChangeNotification, object: nil, userInfo: [MTSelectSort: button.sort])
        
        // dismiss popover
        //self.popover?.dismissPopoverAnimated(true)
    }


}
