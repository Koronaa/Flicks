//
//  HistoryViewModel.swift
//  Flicks
//
//  Created by Sajith Konara on 11/3/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation
class HistoryViewModel{
    
    var reloadTableViewClosure:(()->())?
    var showErrorMessageClosure:(()->())?
    
    var selectedHistory:History?
    var errorTitle:String?
    
    private var historyData:[History] = []
    
    private var historyCellViewModels:[HistoryCellViewModel] = []{
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    var errorMessage:String?{
        didSet{
            self.showErrorMessageClosure?()
        }
    }
    
    var numberOfCells:Int{
        return historyCellViewModels.count
    }
    
    func fetchData(){
        if let historyArray = UserDefaultsManager.getHistory(){
            if historyArray.count > 0{
                self.historyData = historyArray
                self.historyCellViewModels = historyArray.map({HistoryCellViewModel(titleLabel: $0.keyword)})
                return
            }
        }
        errorTitle = "No Data"
        errorMessage = "No History Data available"
    }
    
    func setData(for query:String){
        let historyArray = UserDefaultsManager.getHistory() ?? []
        if !historyArray.contains(where: { $0.keyword.lowercased() == query.lowercased()
        }){
            var tempHistoryArray = historyArray
            tempHistoryArray.append(History(keyword: query))
            UserDefaultsManager.setHistory(for: tempHistoryArray)
        }
        
    }
    
    func userPressed(at indexpath:IndexPath) -> String{
        let history = historyData[indexpath.row]
        return history.keyword
    }
    
    func getHistoryCellViewModel(at indexPath:IndexPath) -> HistoryCellViewModel{
        return historyCellViewModels[indexPath.row]
    }
    
    func removeHistoryCell(at indexPath:IndexPath){
        historyCellViewModels.remove(at: indexPath.row)
        historyData.remove(at: indexPath.row)
        UserDefaultsManager.setHistory(for: historyData)
    }
    
}
