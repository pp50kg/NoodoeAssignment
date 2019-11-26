//
//  UserSettingViewController.swift
//  NoodoeAssignment
//
//  Created by YuChen Hsu on 2019/11/26.
//  Copyright © 2019 Adam Hsu. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController,UpdateUserDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var timeZoneTextField: UITextField!
    @IBOutlet weak var rightButton: UIButton!
    
    var emailString = ""
    var timeZoneString = ""
    var loadingView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.text = emailString
        self.timeZoneTextField.text = timeZoneString
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editAction(_ sender: Any) {
        rightButton.isSelected = !rightButton.isSelected
        
        if rightButton.isSelected {
            rightButton.setTitle("Save", for: .normal)
            timeZoneTextField.isEnabled = true
            timeZoneTextField.becomeFirstResponder()
        }else{
            rightButton.setTitle("Edit", for: .normal)
            timeZoneTextField.isEnabled = false
            timeZoneTextField.resignFirstResponder()
            
            let updateReqModel = UpdateUserRequestModel()
                    
            updateReqModel.timezone = self.timeZoneTextField.text!
                    
            let updateUserViewModel = UpdateUserViewModel()
            updateUserViewModel.delegate = self
                    
            updateUserViewModel.requestUpdateUser(requestModel: updateReqModel)
            loadingView = Bundle.main.loadNibNamed("BlackLoadingView", owner: self, options: nil)?.first as! UIView
                    
            self.view.addSubview(loadingView)
        }
    }
}

// MARK: - UpdateUserDelegate 實作
extension UserSettingViewController{
    func updateSuccess(updateModel:UpdateModel){
        DispatchQueue.main.async(execute: {
          self.loadingView.removeFromSuperview()
            
        })
    }

    func updateFial(){
        DispatchQueue.main.async(execute: {
          self.loadingView.removeFromSuperview()
        })
    }
}
