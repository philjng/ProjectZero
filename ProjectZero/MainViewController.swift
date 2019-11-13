//
//  MainViewController.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
///Users/phing/ProjectZero/ProjectZero/Main.storyboard

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var nameTextField: UITextField!
    var isUpdateScreen : Bool = false
    
    
    @IBAction func nextButtonClick(_ sender: Any) { // rename to join  / create room button action
        
        let userData = UserData()
        saveName()

        if (userData.name.isEmpty) {
            
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
        isUpdateScreen = userData.hasDataFilled
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
        
        nameTextField.delegate = self
    }
    
    func initData() {
        
        let userData = UserData()
        
        self.navigationItem.title = userData.hasDataFilled ? "_register_title".localized : "_profile_title".localized
                
        
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
