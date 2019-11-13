//
//  MainViewController.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var nameTextField: UITextField!
    var isUpdateScreen : Bool = false
    
    
    @IBAction func nextButtonClick(_ sender: Any) {
        
        let userData = UserData()
        saveName()
        
        if (userData.avatarId == 0) {
            
            AlertHelper.warn(delegate: self, message: "_alert_choose_avatar".localized)
        }
        else if (userData.name.isEmpty) {
            
            AlertHelper.warn(delegate: self, message: "_alert_enter_name".localized)
        }
        else {
            
            if (isUpdateScreen) {
                
                self.navigationController?.popViewController(animated: true)
            }
            else {
                
                if let target = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                    target.navigationItem.hidesBackButton = true;
                    self.navigationController?.pushViewController(target, animated: true)
                }
            }
        }
    }
    
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let userData = UserData()
        isUpdateScreen = userData.hasAllDataFilled
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
        saveName()
    }
    
    func saveName() {
        
        var userData = UserData()
        let name : String = nameTextField.text ?? ""
        userData.name = name
        userData.save()
    }
    
    func setupUI() {
        
        nextButton.layer.cornerRadius = 10
        nameTextField.delegate = self
        pickColorButton.setTitle("_register_pick_color".localized, for: .normal)
    }
    
    func initData() {
        
        let userData = UserData()
        
        self.navigationItem.title = userData.hasAllDataFilled ? "_register_title".localized : "_profile_title".localized
        
        let buttonTitle = userData.hasAllDataFilled ? "_save".localized : "_next".localized
        nextButton.setTitle(buttonTitle, for: .normal)
        
        avatarButton.setImage(UIImage(named: String(format: "%@%d", Constants.kAvatarImagePrefix, userData.avatarId)), for: UIControlState.normal)
        self.view.backgroundColor = Constants.colors[userData.colorId]
        
        nameTextField.text = userData.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        return true
    }
}
