//
//  HistoryPickerView.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import UIKit

protocol HistoryPickerViewDelegate{
    func historyPicked(for queryString:String)
    func historyDeleted()
}


class HistoryPickerView: UIView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var historyPickerViewDelegate:HistoryPickerViewDelegate?
    
    
    lazy var historyViewModel:HistoryViewModel = {
        return HistoryViewModel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initViewModel(for: historyViewModel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initViewModel(for: historyViewModel)
    }
    
    func initViewModel(for viewModel:HistoryViewModel){
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showErrorMessageClosure = { [weak self] in
            UIHelper.showErrorMessage(title: viewModel.errorTitle!, message: viewModel.errorMessage!)
        }
    }
    
    
    private func setupView(){
        Bundle.main.loadNibNamed("HistoryPicker", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: .main), forCellReuseIdentifier: UIConstants.Cell.HISTORY_TV_CELL)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchData(){
        self.historyViewModel.fetchData()
    }
}

typealias HistoryPickerViewDelegates = HistoryPickerView
extension HistoryPickerViewDelegates:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyCellViewModel = historyViewModel.getHistoryCellViewModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.Cell.HISTORY_TV_CELL) as! HistoryTableViewCell
        cell.historyCellViewModel = historyCellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyPickerViewDelegate!.historyPicked(for: historyViewModel.userPressed(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            historyViewModel.removeHistoryCell(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            historyPickerViewDelegate!.historyDeleted()
        }
    }
    
}
