//
//  LoginViewModel.swift
//  NoodoeAssignment
//
//  Created by YuChen Hsu on 2019/11/26.
//  Copyright © 2019 Adam Hsu. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    
    func loginSuccess(loginModel:LoginModel)

    func loginFial()
}

class LoginViewModel: NSObject {
    var delegate:LoginDelegate?
    
    func requestLogin(requestModel:LoginRequestModel){
        var requestArray:Array<URLQueryItem> = Array()
        let requesrDictionary = requestModel.tansferToDictionary()
        
        for key in requesrDictionary.keys {
            let item = URLQueryItem(name: key, value: requesrDictionary[key])
            
            requestArray.append(item)
        }
        NetworkManager.sharedInstance.requestByGET(actionName:"login" ,requestArray: requestArray) { (response) in
           
            if (response != nil){
                let responseModel = LoginModel()
                responseModel.username = response!["username"] as! String
                responseModel.timezone = response!["timezone"] as! Int
                responseModel.sessionToken = response!["sessionToken"] as! String
                responseModel.objectId = response!["objectId"] as! String
                
                self.delegate?.loginSuccess(loginModel: responseModel)
            }else{
                self.delegate?.loginFial()
            }
        }
    }
    
}

class LoginRequestModel: NSObject {
    var username = ""
    var password = ""
    
    func tansferToDictionary() -> Dictionary<String, String> {
        
        let returnDictionary = ["username":self.username,"password":self.password]
        
        return returnDictionary
    }
}
