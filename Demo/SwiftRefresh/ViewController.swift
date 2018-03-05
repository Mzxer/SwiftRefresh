//
//  ViewController.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/1/28.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit


class RefreshHeader: SwiftRefreshHeader {}


//class RefreshFooter: UIView, SwiftRefreshFooterType {
//    func beginRefreshing() {
//
//    }
//}

class ViewController: UIViewController {

    var numberOfRows = 3
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sr.set(header: SwiftRefreshNormalHeader {
            debugPrint("refreshing")
            delay(2, task: {
                self.numberOfRows = 3
                self.tableView.sr.header?.endRefreshing()
                self.tableView.reloadData()
            })
        })
        
        tableView.sr.set(footer: SwiftRefreshNormalFooter {
            debugPrint("refreshing")
            delay(2, task: {
                self.numberOfRows += 3
                self.tableView.sr.footer?.endRefreshing(hasMoreData: true)
                self.tableView.reloadData()
            })
        })
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        tableView.neverAdjustsInset(on: self)
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        tableView.frame = view.bounds
        if #available(iOS 11.0, *) {
            tableView.sr_y += view.safeAreaInsets.top
            tableView.sr_height -= view.safeAreaInsets.top
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        tableView.sr.header?.beginRefreshing()
//        tableView.sr.header?.endRefreshing()
    }


}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
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
