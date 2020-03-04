//
//  ViewController.swift
//  Demo
//
//  Created by ZERONES on 17/02/20.
//  Copyright © 2020 ZERONES. All rights reserved.
//

import UIKit
import Firebase

class SignIn: UIViewController {

    //MARK:- Outlet
    @IBOutlet var lblError: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var AppImage: UIImageView!
        
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.SetUpVC()
        
        self.view.applyGradient(locations:  [0.1, 1.1])
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0 * 2 * 60.0
        rotationAnimation.duration = 300.0
        rotationAnimation.isCumulative = false
        rotationAnimation.repeatCount = Float.infinity
        self.AppImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    //MARK:- VIewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.lblError.isHidden = true
        }
        else
        {
            let net = appDelegate.InternetConnectionErrorApp(view: self.view)
            net.isUserInteractionEnabled = true
            net.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeNetView)))
        }
    }
    
    @objc func removeNetView()
    {
        if(Reachability.isConnectedToNetwork() == true)
        {
            appDelegate.RemoveNetworkLostView()
        }
        else
        {
            print("*******************************-: Network Reachability Error :-*******************************")
            //appDelegate.RemoveNetworkLostView()
        }
    }
    
    //MARK:- Action
    @IBAction func btnLogin(_ sender: Any)
    {
        guard let Email = self.txtEmail.text, let Pass = self.txtPass.text else { return}
      
        if Email.isEmpty
        {
            self.lblError.isHidden = false
            self.lblError.text = "Enter Email Address"
        }
        else if !Email.isValidEmail()
        {
            self.lblError.isHidden = false
            self.lblError.text = "Enter Valid Email Address"
        }
        else if Pass.isEmpty
        {
            self.lblError.isHidden = false
            self.lblError.text = "Enter password"
        }
        else if Pass.count < 8
        {
            self.lblError.isHidden = false
            self.lblError.text = "password must be minimam charater 8"
        }
        else
        {
          let LoginManager = FirebaseManager()
            
            LoginManager.SignIn(email: Email, pass: Pass) {[weak self] (success) in
                
                if (success)
                {
                    let ref = Database.database().reference().child("users")
                    ref.observe(.childAdded, with: { snapshot in
                        let dict = snapshot.value as! [String: Any]
                        let UserName = dict["username"] as? String ?? ""
                        let EmailAddress = dict["email"] as? String ?? ""
                        let Password = dict["password"] as? String ?? ""
                        let ProfilePic = dict["profilepicurl"] as? String ?? ""
                        let UserId = snapshot.key
                        
                        if EmailAddress == Email && Password == Pass
                        {
                            print("UserId:- \(UserId), $$ UserName:- \(UserName), $$ EmailAddress:- \(EmailAddress), $$ Password:- \(Password), $$ ProfilePic:- \(ProfilePic)")
                           
                            NSUserDefaultClass.sharedInstance.setIsLoggin(isLoggin: true)
                            
                            let Data = LoginClass(Id: UserId, Name: UserName, Email: EmailAddress, Password: Password, profile_pic: ProfilePic)
                            NSUserDefaultClass.sharedInstance.setUserDetails(logindata: Data)
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                            let HomeVC = storyBoard.instantiateViewController(withIdentifier: "TapBarVC") as! TapBarVC
                            self?.navigationController?.pushViewController(HomeVC, animated: true)
                        }
                    })
                }
                else
                {
                  self?.lblError.isHidden = false
                  self?.lblError.text = "Email Address Or Password Are Not Correct"
                }
            }
        }
    }
    @IBAction func btnRegister(_ sender: Any)
    {
        self.performSegue(withIdentifier: "Register", sender: self)
    }
}

//MARK:- Function
extension SignIn
{
  func SetUpVC()
  {
    self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    self.txtPass.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    
    self.txtEmail.keyboardType = .emailAddress
    
    self.txtEmail.delegate = self
    self.txtPass.delegate = self
    
    self.btnLogin.layer.borderWidth = 1
    self.btnLogin.layer.borderColor = #colorLiteral(red: 1, green: 0.6666666667, blue: 0.1882352941, alpha: 1)
    self.btnRegister.layer.borderWidth = 1
    self.btnRegister.layer.borderColor = #colorLiteral(red: 1, green: 0.6666666667, blue: 0.1882352941, alpha: 1)
    
    self.btnRegister.backgroundColor = UIColor.orange
    self.btnLogin.backgroundColor = UIColor.orange
    
    self.txtEmail.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
    self.txtPass.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
   
    self.txtEmail.layer.cornerRadius = self.txtEmail.frame.height/2
    self.txtPass.layer.cornerRadius = self.txtPass.frame.height/2
    
    self.btnLogin.layer.cornerRadius = self.btnLogin.frame.height/2
    self.btnRegister.layer.cornerRadius = self.btnRegister.frame.height/2
    
  }
}

//MARK:- UItextField DeleGate Method
extension SignIn: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtEmail
        {
            self.lblError.isHidden = true
        }
        else if textField == txtPass
        {
           self.lblError.isHidden = true
        }
        
      return true
        
    }
}
 
