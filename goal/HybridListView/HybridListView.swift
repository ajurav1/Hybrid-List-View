//
//  Nehao
//
//  Created by Ajay Kumar on 22/12/17.
//  Copyright © 2017 Amit Tripathi. All rights reserved.
//

import Foundation

protocol HybridListViewDataSource:class {
    //table view DataSource
    func hybridListView(_ sender: HybridListView, numberOfRowsInContainer section: Int, headerSection:Int) -> Int
    func hybridListView(_ sender: HybridListView, cellForItemInContainer indexPath: IndexPath, headerSection:Int, tableView:UITableView) -> UITableViewCell
    
    //header view DataSource
    func hybridListView(_ sender: HybridListView, numberOfItemsInSection section: Int) -> Int
    func hybridListView(_ sender: HybridListView, cellForItemInSection headerSection:Int) -> UICollectionViewCell
    func hybridListView(_ sender: HybridListView, cellWillDisplay cell: UICollectionViewCell, headerSection:Int)
    func hybridListView(_ sender: HybridListView, sizeForHeaderItemInSection headerSection: Int) -> CGSize
}

protocol HybridListViewDelegate:class {
    //table view Delegate
    func hybridListView(_ sender: HybridListView, didSelectItemInContainer indexPath: IndexPath, headerSection:Int)
    
    //header view Delegate
    func hybridListView(_ sender: HybridListView, didSelectContainer headerSection:Int)
}
extension HybridListViewDataSource{
    //optional DataSource
    func hybridListView(_ sender: HybridListView, cellWillDisplay cell: UICollectionViewCell, headerSection:Int){
    }
}

class HybridListView:UIView{
    
    //MARK:- Oulets
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var bannerCollectionView: UICollectionView!
    @IBOutlet private(set) weak var listingCollectionView: UICollectionView!
    
    //MARK:- Public and private variables
    weak var dataSource:HybridListViewDataSource?
    weak var delegate:HybridListViewDelegate?
    var headerHeight:CGFloat = 70.0
    var headerBackgroundColor:UIColor = .blue
    var tableViewCellIdentifier:String?
    
    private var currentIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func initiate() -> HybridListView{
        return HybridListView.loadFromNib(named: "HybridListView") as! HybridListView
    }
    
    //MARK:- Overridden method(s)
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        listingCollectionView.register(UINib(nibName:"HYContainerView", bundle: nil), forCellWithReuseIdentifier: "HYContainerView")
        updateUI()
    }
    
    //MARK:- Public Method(s)
    public func updateUI(){
        bannerCollectionView.backgroundColor = headerBackgroundColor
        headerHeightConstraint.constant = headerHeight
    }
    public func reloadList(){
        bannerCollectionView.reloadData()
        listingCollectionView.reloadData()
    }
    public func reloadList(_ headerSection:Int){
        for case let cell as HYContainerView in listingCollectionView.visibleCells {
            if let indexPath = listingCollectionView.indexPath(for: cell) {
                if indexPath.item == headerSection{
                    cell.updateCellComponents(indexPath.item)
                }
            }
        }
    }
    
    //MARK:- Private Method(s)
    private func cellForListingCollectionView(_ indexPath: IndexPath) -> UICollectionViewCell{
        let cell = listingCollectionView.dequeueReusableCell(withReuseIdentifier: "HYContainerView", for: indexPath) as! HYContainerView
        cell.delegate = self
        cell.dataSource = self
        cell.cellIdentifier = tableViewCellIdentifier
        cell.updateCellComponents(indexPath.item)
        return cell
    }
    
    private func scrollBannerCollectionView(_ indexPath: IndexPath){
        if currentIndexPath == indexPath{
            return
        }
        currentIndexPath = indexPath
        callData(indexPath: indexPath)
        bannerCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    private func callData(indexPath:IndexPath){
        delegate?.hybridListView(self, didSelectContainer: indexPath.item)
    }
    
    private func scrollListingCollectionView(_ indexPath: IndexPath){
        currentIndexPath = indexPath
        listingCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    private func updateCurrentVisibleIndex(){
        var visibleRect = CGRect()
        visibleRect.origin = listingCollectionView.contentOffset
        visibleRect.size = listingCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath: IndexPath = listingCollectionView.indexPathForItem(at: visiblePoint){
            self.scrollBannerCollectionView(visibleIndexPath)
        }
    }
}
//MARK:- CollectionView DataSource, Delegate Method(s)
extension HybridListView: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource == nil{
            return 0
        }
        return (dataSource?.hybridListView(self, numberOfItemsInSection: section))!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView{
            return (dataSource?.hybridListView(self, cellForItemInSection: indexPath.item))!
        }
        return cellForListingCollectionView(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView{
            dataSource?.hybridListView(self, cellWillDisplay: cell, headerSection: indexPath.item)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView{
            return (dataSource?.hybridListView(self, sizeForHeaderItemInSection: indexPath.item))!
        }
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.scrollBannerCollectionView(indexPath)
        self.scrollListingCollectionView(indexPath)
    }
}

//MARK:- ScrollViewDelegate Method(s)
extension HybridListView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.listingCollectionView && scrollView.isDragging{
            updateCurrentVisibleIndex()
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.listingCollectionView{
            updateCurrentVisibleIndex()
        }
    }
}

//MARK:- ContainerView DataSource, Delegate Method(s)
extension HybridListView: HYContainerViewDelegate,HYContainerViewDataSource{
    //table view DataSource
    func hyContainerView(_ sender: HYContainerView, numberOfItemsInSection section: Int, headerSection:Int) -> Int{
        return (dataSource?.hybridListView(self, numberOfRowsInContainer: section, headerSection: headerSection))!
    }
    func hyContainerView(_ sender: HYContainerView, cellForItemAt indexPath: IndexPath, headerSection:Int, tableView:UITableView) -> UITableViewCell{
        return (dataSource?.hybridListView(self, cellForItemInContainer: indexPath, headerSection: headerSection, tableView: tableView))!
    }
    
    //table view Delegate
    func hyContainerView(_ sender: HYContainerView, didSelectItemAt indexPath: IndexPath, headerSection:Int){
        delegate?.hybridListView(self, didSelectItemInContainer: indexPath, headerSection: headerSection)
    }
}
