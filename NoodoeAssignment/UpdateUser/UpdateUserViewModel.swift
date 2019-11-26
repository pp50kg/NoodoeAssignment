//
//  UpdateUserViewModel.swift
//  NoodoeAssignment
//
//  Created by YuChen Hsu on 2019/11/26.
//  Copyright © 2019 Adam Hsu. All rights reserved.
//

import UIKit

protocol UpdateUserDelegate {
    
    func updateSuccess(updateModel:UpdateModel)

    func updateFial()
}

class UpdateUserViewModel: NSObject {
    var delegate:UpdateUserDelegate?
    
    func requestUpdateUser(requestModel:UpdateUserRequestModel){
        let requesrDictionary = requestModel.tansferToDictionary()
        
        let requestName = "users/"+NoodoeApplication.sharedInstance.objectId
        
        NetworkManager.sharedInstance.requestPUT(actionName: requestName, requestDictionary: requesrDictionary) { (response) in

                    if (response != nil){
                        let responseModel = UpdateModel()
                        responseModel.updatedAt = response!["updatedAt"] as! String
        
                        self.delegate?.updateSuccess(updateModel: responseModel)
                    }else{
                        self.delegate?.updateFial()
                    }
                }
    }
}

class UpdateUserRequestModel: NSObject {
    var timezone = ""
    
    func tansferToDictionary() -> Dictionary<String, Any> {
        
        let returnDictionary = ["timezone":Int(self.timezone)]
        
        return returnDictionary
    }
}
