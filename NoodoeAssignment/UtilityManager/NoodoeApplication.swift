//
//  NoodoeApplication.swift
//  NoodoeAssignment
//
//  Created by YuChen Hsu on 2019/11/26.
//  Copyright © 2019 Adam Hsu. All rights reserved.
//

import UIKit

class NoodoeApplication: NSObject {
    
    static let sharedInstance = NoodoeApplication()
    
    var objectId = ""
    var sessionToken = ""
    var username = ""
    
    
    private let internalQueue = DispatchQueue(label: "SingletionInternalQueue", qos: .default, attributes: .concurrent)
    private var _dataCount: Int = 0
    
    var dataCount: Int {
        get {
            return internalQueue.sync {
                _dataCount
            }
        }
        
        set(newValue) {
            // barrier flag => 告訴佇列，這個特定工作項目，必須在沒有其他平行執行的項目時執行
            internalQueue.async(flags: .barrier) {
                self._dataCount = newValue
            }
        }
    }
    
    private override init() {
        
    }
    
}
