//
//  NetworkManager.swift
//  NoodoeAssignment
//
//  Created by YuChen Hsu on 2019/11/25.
//  Copyright © 2019 Adam Hsu. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    
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
        print("init...")
    }
    
    func requestByGET(actionName:String,requestArray:Array<URLQueryItem>, completionHandler: @escaping (Dictionary<String, AnyObject>?) -> Void) {
        
        var urlComponents = URLComponents(string: "https://watch-master-staging.herokuapp.com/api/"+actionName)!

        urlComponents.queryItems = requestArray
        
        var request = URLRequest(url: urlComponents.url!)
        request.setValue("vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(NoodoeApplication.sharedInstance.sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                completionHandler(json)
            } catch {
                completionHandler(nil)
                print("error")
            }
        }).resume()
    }
    
    func requestPUT(actionName:String,requestDictionary:Dictionary<String,Any>, completionHandler: @escaping (Dictionary<String, AnyObject>?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://watch-master-staging.herokuapp.com/api/"+actionName)!)
        
        request.setValue("vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(NoodoeApplication.sharedInstance.sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestDictionary, options: [])
        
        request.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                completionHandler(json)
            } catch {
                completionHandler(nil)
                print("error")
            }
        }).resume()
    }
    
//    func requestByPost() {
//
//        var request = URLRequest(url: URL(string: "https://watch-master-staging.herokuapp.com/api/users/WkuKfCAdGq")!)
//
//        request.setValue("vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.addValue(NoodoeApplication.sharedInstance.sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let params = ["timezone":8] as Dictionary<String, Any>
//        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//        request.httpMethod = "POST"
//
//        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            print(response!)
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//                print(json)
//            } catch {
//                print("error")
//            }
//        }).resume()
//    }
}
