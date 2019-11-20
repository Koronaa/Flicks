//
//  ViewController.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var historyPickerView: HistoryPickerView!
    @IBOutlet weak var historyPickerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLabel: UILabel!
    
    var searchBar:UISearchBar?
    var noOfItems:Int?
    var currentPage:Int = 1
    let cellHeight:CGFloat = 170.0
    var cellWidth:CGFloat?
    var enteredQuery:String?
    
    lazy var flickerResponseViewModel:FlickerResponseViewModel = {
        return FlickerResponseViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupSearchBar()
        searchBar!.delegate = self
        historyPickerView.historyPickerViewDelegate = self
        setupView()
        setupViewModel(for: flickerResponseViewModel)
    }
    
    private func setupView(){
        setInfoMessage(message: "Type a keyword or a phrase and press \"Search\"")
    }
    
    private func setupSearchBar(){
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search Photos"
        searchBar?.showsSearchResultsButton = true
        self.navigationItem.titleView = searchBar
    }
    
    private func setupCollectionView(){
        let widthPadding:CGFloat = 50.0
        let heightPadding:CGFloat = 150.0
        self.cellWidth = (UIScreen.main.bounds.width - widthPadding)/2.0
        self.noOfItems = Int(((UIScreen.main.bounds.height - heightPadding)/cellHeight) * 2.0) + 2
    }
    
    private func setupViewModel(for viewModel:FlickerResponseViewModel){
        viewModel.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self!.collectionView.reloadData()
                UIHelper.hide(view: self!.infoLabel)
                UIHelper.show(view: self!.collectionView)
                self!.historyPickerView.historyViewModel.setData(for: self!.enteredQuery!)
            }
        }
        
        viewModel.updateLoadingClosure = { [weak self] in
            let isLoading = viewModel.isLoading
            if isLoading{
                UIHelper.showHUD()
            }else{
                UIHelper.hideHUD()
            }
        }
        
        viewModel.showErrorMessageClosure = { [weak self] in
            UIHelper.showErrorMessage(message: viewModel.errorMessage!)
            self!.setInfoMessage(message: viewModel.errorMessage!)
        }
    }
    
    
    private func refreshView(){
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideHistoryPickerView(){
        historyPickerViewTopConstraint.constant = -330.0
        searchBar!.showsCancelButton = false
        dismissKeyBoard()
        refreshView()
    }
    
    private func setInfoMessage(message:String){
        UIHelper.hide(view: collectionView)
        UIHelper.show(view: infoLabel)
        infoLabel.text = message
    }
    
    private func showHistoryPickerView(){
        historyPickerViewTopConstraint.constant = 0.0
        searchBar!.showsCancelButton = true
        searchBar!.becomeFirstResponder()
        refreshView()
    }
    
    func dismissKeyBoard(){
        searchBar!.resignFirstResponder()
        self.view.endEditing(true)
    }
}


typealias HomeVCDelegates = HomeViewController
extension HomeVCDelegates:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,
HistoryPickerViewDelegate{
    
    // MARK: collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickerResponseViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCellViewModel = flickerResponseViewModel.getCellViewModel(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.Cell.PHOTO_CV_CELL, for: indexPath) as! PhotoCollectionViewCell
        cell.photoCellViewModel = photoCellViewModel
        cell.setupCell(imageWidth: self.cellWidth! - 20.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyBoard()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row == flickerResponseViewModel.numberOfCells - 1{
            if currentPage + 1 <= flickerResponseViewModel.getTotalPages(){
                flickerResponseViewModel.fetchData(for: self.enteredQuery!, pageNo: currentPage + 1, itemsPerPage: noOfItems!)
                self.currentPage = currentPage + 1
            }
        }
    }
    
    // MARK: SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyBoard()
        hideHistoryPickerView()
        if let queryString = searchBar.text{
            if queryString.count > 0{
                flickerResponseViewModel.fetchData(for: queryString, pageNo: 1, itemsPerPage: noOfItems!)
                self.enteredQuery = queryString
                self.currentPage = 1
            }
        }
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        historyPickerView.fetchData()
        if historyPickerView.historyViewModel.numberOfCells > 0{
            searchBar.showsCancelButton = true
            showHistoryPickerView()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideHistoryPickerView()
    }
    
    // MARK: HistoryPicker
    func historyPicked(for queryString: String) {
        searchBar!.text = queryString
        searchBar!.showsCancelButton = false
        flickerResponseViewModel.fetchData(for: queryString, pageNo: 1, itemsPerPage: noOfItems!)
        self.currentPage = 1
        self.enteredQuery = queryString
        dismissKeyBoard()
        hideHistoryPickerView()
    }
    
    func historyDeleted() {
        self.historyPickerView.fetchData()
    }
    
}
