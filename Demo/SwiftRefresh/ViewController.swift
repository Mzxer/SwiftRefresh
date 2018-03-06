//
//  ViewController.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/1/28.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit




//class RefreshFooter: UIView, SwiftRefreshFooterType {
//    func beginRefreshing() {
//
//    }
//}

class ViewController: UIViewController {

    var items = [1, 1, 1]
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sr.set(header: SwiftRefreshNormalHeader { [weak self] in
            debugPrint("refreshing")
            self?.fakeRequest()
        })
        
        tableView.sr.set(footer: SwiftRefreshNormalFooter {[weak self] in
            debugPrint("loading")
            self?.fakeLoadMore()
        })
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        tableView.neverAdjustsInset(on: self)
        
        tableView.estimatedRowHeight = 0
        // 不加这代码，contentSize 会发生变化，一直减少也不知道为什么
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        // 加下面的代码会导致一直循环加载，停留在原地
//        if #available(iOS 11.0, *) {
//            tableView.sr_y += view.safeAreaInsets.top
//            tableView.sr_height -= view.safeAreaInsets.top
//        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fakeRequest() {
        delay(2, task: {
            self.items = [1, 1, 1]
            self.tableView.reloadData()
            self.tableView.sr.header?.endRefreshing()
        })
    }
    
    func fakeLoadMore() {
        delay(2, task: {
            self.items.append(1)
            self.tableView.reloadData()
            self.tableView.sr.footer?.endRefreshing(hasMoreData: true)
        })
    }


}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .green
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
