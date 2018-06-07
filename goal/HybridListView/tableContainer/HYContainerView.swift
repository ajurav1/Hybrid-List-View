 //  Created by Ajay Kumar on 22/12/17.
 //  Copyright © 2017 Ajay Kumar. All rights reserved.
 //
 
 import UIKit
 
 
 protocol HYContainerViewDelegate: class{
    func hyContainerView(_ sender: HYContainerView, didSelectItemAt indexPath: IndexPath, headerSection:Int)
 }
 
 protocol HYContainerViewDataSource: class{
    func hyContainerView(_ sender: HYContainerView, numberOfItemsInSection section: Int, headerSection:Int) -> Int
    func hyContainerView(_ sender: HYContainerView, cellForItemAt indexPath: IndexPath, headerSection:Int, tableView:UITableView) -> UITableViewCell
 }
 
 class HYContainerView: UICollectionViewCell {
    
    //MARK: IBOUTLET(S)
    @IBOutlet private(set) weak var tblProductList: UITableView!
    
    //MARK:CONSTANT(S) AND VARIABLE(S)
    weak var delegate:HYContainerViewDelegate?
    weak var dataSource:HYContainerViewDataSource?
    var section = 0
    var cellIdentifier:String?
    
    //MARK:LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        tblProductList.rowHeight = UITableViewAutomaticDimension
        tblProductList.estimatedRowHeight = 75
        tblProductList.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    //MARK: PUBLIC METHOD(S)
    func updateCellComponents(_ section:Int){
        self.section = section
        if cellIdentifier != nil{
            tblProductList.register(UINib(nibName:cellIdentifier!, bundle: nil), forCellReuseIdentifier: cellIdentifier!)
        }
        tblProductList.reloadData()
    }
    
    // MARK: - ScrollView Delegate Method(s)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tblProductList{
            //tableView did scroll
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.tblProductList{
            //tableView end decelerating
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.tblProductList{
            //tableView end dragging
        }
    }
 }
 extension HYContainerView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == nil{
            return 0
        }
        return (dataSource?.hyContainerView(self, numberOfItemsInSection: section, headerSection: self.section))!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (dataSource?.hyContainerView(self, cellForItemAt: indexPath, headerSection: self.section, tableView:tblProductList))!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.delegate?.hyContainerView(self, didSelectItemAt: indexPath, headerSection: self.section)
    }
 }
