//
//  ViewController.swift
//  goal
//
//  Created by Ajay Kumar on 03/05/18.
//  Copyright © 2018 Ajay Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var swipeview: UIView!
    var currentIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    lazy var hybridListView = HybridListView.initiate()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addPlansListView()
        
    }
    private func addPlansListView() {
        hybridListView.dataSource = self
        hybridListView.delegate = self
        hybridListView.tableViewCellIdentifier = "cellReuseIdentifier"
        hybridListView.bannerCollectionView.register(UINib(nibName:"TransactionTypeCell", bundle: nil), forCellWithReuseIdentifier: "TransactionTypeCell")
        hybridListView.headerHeight = 50
        hybridListView.headerBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.558868838)
        hybridListView.updateUI()
        swipeview.addSubview(hybridListView)
//        Utility.addEqualConstraints(for: hybridListView, inSuperView: swipeview)
    }
}
extension ViewController:HybridListViewDataSource{
    //table view DataSource
    func hybridListView(_ sender: HybridListView, numberOfRowsInContainer section: Int, headerSection:Int) -> Int{
        return 20
    }
    func hybridListView(_ sender: HybridListView, cellForItemInContainer indexPath: IndexPath, headerSection:Int, tableView:UITableView) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Cell data"
        return cell
    }
    
    //header view DataSource
    func hybridListView(_ sender: HybridListView, numberOfItemsInSection section: Int) -> Int{
        return 3
    }
    func hybridListView(_ sender: HybridListView, cellForItemInSection headerSection:Int) -> UICollectionViewCell{
        let indexPath = IndexPath(item: headerSection, section: 0)
        let cell = hybridListView.bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "TransactionTypeCell", for: indexPath)
        return cell
    }
    func hybridListView(_ sender: HybridListView, sizeForHeaderItemInSection headerSection: Int) -> CGSize{
        return getCategoryCollectionViewSize(headerSection)
    }
    
    
    fileprivate func getCategoryCollectionViewSize(_ section: Int)-> CGSize {
//        let label = UILabel(frame: CGRect(x:0,y: 0,width: 250,height: 50))
//        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
////        label.text = headerArray[section]
//        var width = label.intrinsicContentSize.width+20
//        if width < 70{
//            width = 70
//        }
        return CGSize(width: self.view.frame.size.width/3, height: hybridListView.bannerCollectionView.frame.size.height)
    }
    
}

extension ViewController:HybridListViewDelegate{
    //table view Delegate
    func hybridListView(_ sender: HybridListView, didSelectItemInContainer indexPath: IndexPath, headerSection:Int){
        
    }
    
    //header view Delegate
    func hybridListView(_ sender: HybridListView, didSelectContainer headerSection:Int){
        let indexPath = IndexPath(item: headerSection, section: 0)
        currentIndexPath = indexPath
        configureFrameViews()
    }
    fileprivate func configureFrameViews(){
        for case let cell as TransactionTypeCell in hybridListView.bannerCollectionView.visibleCells {
            if let indexPath = hybridListView.bannerCollectionView.indexPath(for: cell) {
                configureFrameViews(cell, indexPath.item)
            }
        }
    }
    
    //optional header view DataSource
    func hybridListView(_ sender: HybridListView, cellWillDisplay cell: UICollectionViewCell, headerSection:Int){
        if let bannerCell = cell as? TransactionTypeCell{
            configureFrameViews(bannerCell, headerSection)
        }
    }
    fileprivate func configureFrameViews(_ cell: TransactionTypeCell, _ section: Int){
        if section == currentIndexPath.item{
            cell.processHighlightedView(true)
            return
        }
        cell.processHighlightedView(false)
    }
}

