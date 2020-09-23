//
//  SignUpViewController.swift
//  DogEsaApp3
//
//  Created by 犬 on 2020/09/22.
//


import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GoogleMobileAds

class SignUpViewController: UIViewController{
    
    var fromDog = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameErrLabel: UILabel!
    @IBOutlet weak var passErrLabel: UILabel!
    @IBOutlet weak var mailErrLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBAction func tappedNoButton(_ sender: Any) {
        let fieldNav = self.presentingViewController as! UINavigationController
        let fieldViewController = fieldNav.viewControllers[0] as! FieldViewController
        fieldViewController.userName = ""
        fieldViewController.email = ""
        fieldViewController.password = ""
        fieldViewController.login = false
        fieldViewController.setText(ue: "犬にエサをあげるアプリに ようこそ！", sita: "(アカウント登録なし)")
        fieldViewController.saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = .gray
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.gray.cgColor
        
        nameTextField.delegate = self
        passTextField.delegate = self
        emailTextField.delegate = self
        
        nameErrLabel.textColor = .clear
        passErrLabel.textColor = .clear
        mailErrLabel.textColor = .clear
        
        if fromDog{
            noButton.setTitle("キャンセル", for: .normal)
        }
        else{
            noButton.setTitle("アカウント登録せずに始める", for: .normal)
        }
        
        //admob
        let gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        gadBannerView.center = self.view.center
        gadBannerView.adUnitID = "ca-app-pub-1923099754481403/6673096314"
        gadBannerView.rootViewController = self;
        let request = GADRequest();
        
        gadBannerView.load(request)
        
        gadBannerView.frame = CGRect(x: 0, y: view.frame.height - gadBannerView.frame.height, width: view.frame.width, height: gadBannerView.frame.height)
        
        self.view.addSubview(gadBannerView)
    }
    @IBAction func tappedRegisterButton(_ sender: Any) {
        
        guard let email = emailTextField.text else {return}
        guard let password = passTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (res, err) in
            if let err = err{
                print("認証情報の保存に失敗。\(err)")
                if password.count < 6{
                    self.passErrLabel.textColor = .red
                }
                else{
                    self.mailErrLabel.textColor = .red
                }
                return
            }
            else{
                print("認証情報の保存に成功")
                
                guard let uid = res?.user.uid else{return}
                guard let username = self.nameTextField.text else{return}
                let docData = [
                    "email": email,
                    "username": username,
                    "createAt": Timestamp(),
                    "kaisuu": 0,
                    "dogName": ""
                    ] as [String : Any]
                
                Firestore.firestore().collection("users").document(uid).setData(docData){
                    (err) in
                    if let err = err{
                        print("データベースに保存失敗\(err)")
                        return
                    }
                    else{
                        print("データベースに保存成功")
                        let fieldNav = self.presentingViewController as! UINavigationController
                        let fieldViewController = fieldNav.viewControllers[0] as! FieldViewController
                        fieldViewController.userName = self.nameTextField.text ?? ""
                        fieldViewController.email = self.emailTextField.text ?? ""
                        fieldViewController.password = self.passTextField.text ?? ""
                        fieldViewController.login = true
                        fieldViewController.saveData()
                        if fieldViewController.userName == ""{
                            fieldViewController.setText(ue: "犬にエサをあげるアプリに", sita: "ようこそ！")
                        }
                        else{
                            fieldViewController.setText(ue: "犬にエサをあげるアプリに", sita: fieldViewController.userName + "さん ようこそ！")
                        }
                        self.dismiss(animated: true, completion: nil)
                        if self.fromDog{
                            let storyboard = UIStoryboard(name: "Enter", bundle: nil)
                            let enterViewController = storyboard.instantiateViewController(identifier: "EnterViewController") as! EnterViewController
                            enterViewController.modalPresentationStyle = .fullScreen
                            enterViewController.first = true
                            fieldViewController.present(enterViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
        if fromDog{
            let fieldNav = self.presentingViewController as! UINavigationController
            let fieldViewController = fieldNav.viewControllers[0] as! FieldViewController
            if fromDog{
                fieldViewController.addDog()
            }
            
        }
    }
    @IBAction func returnName(_ sender: Any) {
    }
    @IBAction func returnEmail(_ sender: Any) {
    }
    @IBAction func returnPass(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nameIsEmpty = nameTextField.text?.isEmpty ?? false
        let passIsEmpty = passTextField.text?.isEmpty ?? false
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        mailErrLabel.textColor = .clear
        if (passTextField.text?.count ?? 0) > 5{
            passErrLabel.textColor = .clear
        }
        if passIsEmpty || emailIsEmpty{
            registerButton.isEnabled = false
            registerButton.backgroundColor = .gray
            if 0 < (nameTextField.text?.count ?? 0) && (nameTextField.text?.count ?? 0) < 11{
                nameErrLabel.textColor = .clear
            }
            else{
                nameErrLabel.textColor = .red
            }
        }
        else if nameIsEmpty || (nameTextField.text?.count ?? 0) > 10{
            registerButton.isEnabled = false
            registerButton.backgroundColor = .gray
            nameErrLabel.textColor = .red
        }
        else{
            registerButton.isEnabled = true
            registerButton.backgroundColor = .orange
            nameErrLabel.textColor = .clear
        }
    }
}
