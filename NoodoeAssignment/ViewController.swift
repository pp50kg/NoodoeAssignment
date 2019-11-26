//
//  ViewController.swift
//  NoodoeAssignment
//
//  Created by YuChen Hsu on 2019/11/25.
//  Copyright © 2019 Adam Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,LoginDelegate {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var loadingView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Action
    @IBAction func loginAction(_ sender: Any) {
        if accountTextField.text == ""
        {
            accountTextField.becomeFirstResponder()
            return
        }
        if passwordTextField.text  == ""
        {
            passwordTextField.becomeFirstResponder()
            return
        }
        
        let logingReqModel = LoginRequestModel()
//        logingReqModel.username = "test2@qq.com"
//        logingReqModel.password = "test1234qq"
        
        logingReqModel.username = accountTextField.text!
        logingReqModel.password = passwordTextField.text!
        
        let loginViewModel = LoginViewModel()
        loginViewModel.delegate = self
        
        loginViewModel.requestLogin(requestModel: logingReqModel)
        loadingView = Bundle.main.loadNibNamed("BlackLoadingView", owner: self, options: nil)?.first as! UIView
        
        self.view.addSubview(loadingView)
        self.view.endEditing(true)
    }
}

// MARK: - LoginDelegate 實作
extension ViewController{
    
    func loginSuccess(loginModel:LoginModel){
        NoodoeApplication.sharedInstance.objectId = loginModel.objectId
        NoodoeApplication.sharedInstance.sessionToken = loginModel.sessionToken
        NoodoeApplication.sharedInstance.username = loginModel.username
        
        DispatchQueue.main.async(execute: {
          self.loadingView.removeFromSuperview()
          let userSettingVC = UserSettingViewController()
            userSettingVC.emailString = loginModel.username
            userSettingVC.timeZoneString = String(format:"%d", loginModel.timezone)
          self.navigationController?.pushViewController(userSettingVC, animated: true)
        })

    }

    func loginFial(){
        DispatchQueue.main.async(execute: {
          self.loadingView.removeFromSuperview()
        })
    }
}

