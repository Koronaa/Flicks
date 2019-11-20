//
//  UserDefaultsManager.swift
//  Flicks
//
//  Created by Sajith Konara on 11/2/19.
//  Copyright © 2019 Sajith Konara. All rights reserved.
//

import Foundation
struct UserDefaultsKey {
    static let history = "history"
}

class UserDefaultsManager{
    
    private static func set(value val:Any?, for key:String){
        guard let val = val else {return}
        UserDefaults.standard.set(val, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private static func getValue(forKey key:String) -> Any?{
        return UserDefaults.standard.value(forKey:key)
    }
    
    static func setHistory(for history:[History]){
        let historyData = NSKeyedArchiver.archivedData(withRootObject: history)
        set(value: historyData, for: UserDefaultsKey.history)
    }
    
    static func getHistory() -> [History]?{
        guard let value = UserDefaultsManager.getValue(forKey: UserDefaultsKey.history) as? Data else
        {return nil}
        let historyData = NSKeyedUnarchiver.unarchiveObject(with: value) as! [History]
        return historyData
    }
    
    static func deleteUserDefaults(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
