//
//  MenuViewController.swift
//  DogEsaApp3
//
//  Created by 犬 on 2020/09/22.
//


import UIKit
import Firebase
import GoogleMobileAds

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var difHour = Int()
    var difMin = Int()
    
    private let cellId = "cellId"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = menuTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewDogCell
        if indexPath.row == 8{
            cell.cellLabel.text = "犬を逃す"
            cell.cellLabel.textColor = .red
        }
        if indexPath.row == 1{
            cell.cellLabel.text = "エサをあげる"
        }
        if indexPath.row == 2{
            cell.cellLabel.text = "プロフィール"
        }
        if indexPath.row == 3{
            cell.cellLabel.text = "情報を編集"
        }
        if indexPath.row == 4{
            cell.cellLabel.text = "ランキング"
        }
        if indexPath.row == 6{
            cell.cellLabel.text = "開発者Twitter"
        }
        if indexPath.row == 5{
            cell.cellLabel.text = "エサやり結果をツイート"
        }
        if indexPath.row == 7{
            cell.cellLabel.text = "プッシュ通知を設定"
        }
        if indexPath.row == 9{
            cell.cellLabel.text = ""
            //admob
            let gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
            gadBannerView.center = self.view.center
            gadBannerView.adUnitID = "ca-app-pub-1923099754481403/6673096314"
            gadBannerView.rootViewController = self;
            let request = GADRequest();
            
            gadBannerView.load(request)
            
            gadBannerView.frame = CGRect(x: 0, y: cell.frame.height - gadBannerView.frame.height, width: cell.frame.width, height: gadBannerView.frame.height)
            
            cell.addSubview(gadBannerView)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 通知セル
        if indexPath.row == 7{
            let storyboard = UIStoryboard(name: "Push", bundle: nil)
            let pushViewController = storyboard.instantiateViewController(identifier: "PushViewController") as! PushViewController
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dying{
                let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                    completion: {bool in
                        self.dismiss(animated: true, completion: nil)
                        pushViewController.timeInt = fieldViewController.timeInt
                        field.present(pushViewController, animated: true, completion: nil)
                        
                })
            }
        }
        
        //飼うcell
        if indexPath.row == 0{
            
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dying{
                let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    
                    let alert: UIAlertController = UIAlertController(title: "もう一度,犬を飼いますか？", message: "今度こそ責任を持って育ててくださいね", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        UIView.animate(
                            withDuration: 0.2,
                            delay: 0,
                            options: .curveEaseIn,
                            animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                            completion: {bool in
                                self.dismiss(animated: true, completion: nil)
                                let storyboard = UIStoryboard(name: "Enter", bundle: nil)
                                let enterViewController = storyboard.instantiateViewController(identifier: "EnterViewController") as! EnterViewController
                                enterViewController.modalPresentationStyle = .fullScreen
                                enterViewController.first = true
                                fieldViewController.present(enterViewController, animated: true, completion: nil)
                        })
                        fieldViewController.addDog()
                    })
                    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("いいえ")
                    })
                    alert.addAction(cancelAction)
                    alert.addAction(defaultAction)
                    
                    self.present(alert, animated: true, completion: nil)
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.login == false && fieldViewController.dogStatus == false{
                let alert: UIAlertController = UIAlertController(title: "犬を飼う前にアカウント登録をしてください", message: "登録しますか？", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    UIView.animate(
                        withDuration: 0.2,
                        delay: 0,
                        options: .curveEaseIn,
                        animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                        completion: {bool in
                            self.dismiss(animated: true, completion: nil)
                            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
                            let signUpViewController = storyboard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
                            signUpViewController.modalPresentationStyle = .fullScreen
                            signUpViewController.fromDog = true
                            fieldViewController.present(signUpViewController, animated: true, completion: nil)
                    })
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    let alert: UIAlertController = UIAlertController(title: "アカウント登録をせずに犬を飼います", message: "ランキングに参加できませんがよろしいですか？", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        UIView.animate(
                            withDuration: 0.2,
                            delay: 0,
                            options: .curveEaseIn,
                            animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                            completion: {bool in
                                self.dismiss(animated: true, completion: nil)
                                let storyboard = UIStoryboard(name: "Enter", bundle: nil)
                                let enterViewController = storyboard.instantiateViewController(identifier: "EnterViewController") as! EnterViewController
                                enterViewController.modalPresentationStyle = .fullScreen
                                enterViewController.first = true
                                fieldViewController.present(enterViewController, animated: true, completion: nil)
                        })
                        fieldViewController.addDog()
                    })
                    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("いいえ")
                    })
                    alert.addAction(cancelAction)
                    alert.addAction(defaultAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                })
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
                
            }
            else if fieldViewController.login == false && fieldViewController.dogStatus == true{
                let alert: UIAlertController = UIAlertController(title: "既に犬がいます", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                let dogStatus = fieldViewController.dogStatus
                if dogStatus{
                    let alert: UIAlertController = UIAlertController(title: "既に犬がいます", message: "", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
                else{
                    let alert: UIAlertController = UIAlertController(title: "本当に犬を飼いますか？", message: "責任を持って育ててくださいね", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        UIView.animate(
                            withDuration: 0.2,
                            delay: 0,
                            options: .curveEaseIn,
                            animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                            completion: {bool in
                                self.dismiss(animated: true, completion: nil)
                                let storyboard = UIStoryboard(name: "Enter", bundle: nil)
                                let enterViewController = storyboard.instantiateViewController(identifier: "EnterViewController") as! EnterViewController
                                enterViewController.modalPresentationStyle = .fullScreen
                                enterViewController.first = true
                                fieldViewController.present(enterViewController, animated: true, completion: nil)
                        })
                        fieldViewController.addDog()
                    })
                    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("いいえ")
                    })
                    alert.addAction(cancelAction)
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        //逃がしcell
        if indexPath.row == 8{
            
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dying{
                let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                let dogStatus = fieldViewController.dogStatus
                
                if dogStatus{
                    let alert: UIAlertController = UIAlertController(title: "本当に犬を逃しますか？", message: "この操作は取り消せません", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        
                        UIView.animate(
                            withDuration: 0.2,
                            delay: 0,
                            options: .curveEaseIn,
                            animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                            completion: {bool in
                                self.dismiss(animated: true, completion: nil)
                        })
                        fieldViewController.releaseDog()
                        
                        print("OK")
                    })
                    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("いいえ")
                    })
                    alert.addAction(cancelAction)
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
                else{
                    let alert: UIAlertController = UIAlertController(title: "犬がいません", message: "", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        //エサやりcell
        if indexPath.row == 1{
            
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dying{
                let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                let dogStatus = fieldViewController.dogStatus
                
                if dogStatus{
                    if fieldViewController.esaDic[fieldViewController.hiduke] ?? false{
                        let alert: UIAlertController = UIAlertController(title: "今日はエサやり終わってます", message: "また明日よろしくね", preferredStyle:  UIAlertController.Style.alert)
                        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                        })
                        alert.addAction(defaultAction)
                        
                        present(alert, animated: true, completion: nil)
                    }
                    else{
                        
                        if self.compTime(timeInt: fieldViewController.timeInt){
                            fieldViewController.arrivalStatus = true
                        }
                        else{
                            fieldViewController.arrivalStatus = false
                            if difHour == 0{
                                fieldViewController.dif = String(difMin) + "分"
                            }
                            else{
                                fieldViewController.dif = String(difHour) + "時間" + String(difMin) + "分"
                            }
                        }
                        let alert: UIAlertController = UIAlertController(title: "エサをあげますか？", message: "エサを置く場所をタップしてね", preferredStyle:  UIAlertController.Style.alert)
                        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                            fieldViewController.foodWait = true
                            fieldViewController.setText(ue: "エサの場所を", sita: "タップしてね")
                            
                            UIView.animate(
                                withDuration: 0.2,
                                delay: 0,
                                options: .curveEaseIn,
                                animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                                completion: {bool in
                                    self.dismiss(animated: true, completion: nil)
                            })
                            
                        })
                        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                        })
                        alert.addAction(cancelAction)
                        alert.addAction(defaultAction)
                        
                        present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    let alert: UIAlertController = UIAlertController(title: "犬がいません", message: "", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        //情報cell
        if indexPath.row == 2{
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dying{
                let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let profileViewController = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
                let dogStatus = fieldViewController.dogStatus
                if dogStatus{
                    UIView.animate(
                        withDuration: 0.2,
                        delay: 0,
                        options: .curveEaseIn,
                        animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                        completion: {bool in
                            self.dismiss(animated: true, completion: nil)
                            profileViewController.timeInt = fieldViewController.timeInt
                            field.present(profileViewController, animated: true, completion: nil)
                            
                    })
                    
                }
                else{
                    let alert: UIAlertController = UIAlertController(title: "犬がいません", message: "", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        //編集cell
        if indexPath.row == 3{
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dying{
                let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                if fieldViewController.dogStatus{
                    UIView.animate(
                        withDuration: 0.2,
                        delay: 0,
                        options: .curveEaseIn,
                        animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                        completion: {bool in
                            self.dismiss(animated: true, completion: nil)
                            let storyboard = UIStoryboard(name: "Enter", bundle: nil)
                            let enterViewController = storyboard.instantiateViewController(identifier: "EnterViewController") as! EnterViewController
                            enterViewController.first = false
                            enterViewController.timeInt = fieldViewController.timeInt
                            fieldViewController.present(enterViewController, animated: true, completion: nil)
                    })
                }
                else{
                    let alert: UIAlertController = UIAlertController(title: "犬がいません", message: "", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        //ランキングcell
        if indexPath.row == 4{
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dying{
                let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.dogStatus == false{
                let alert: UIAlertController = UIAlertController(title:"犬がいません", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else if fieldViewController.login == false{
                let alert: UIAlertController = UIAlertController(title: "アカウントがないので\nランキングに参加できません", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                let storyboard = UIStoryboard(name: "Ranking", bundle: nil)
                let rankingViewController = storyboard.instantiateViewController(identifier: "RankingViewController") as! RankingViewController
                rankingViewController.users = fieldViewController.users
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                    completion: {bool in
                        self.dismiss(animated: true, completion: nil)
                        field.present(rankingViewController, animated: true, completion: nil)
                        
                })
            }
        }
        
        //俺のTwittercell
        if indexPath.row == 6{
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                let alert: UIAlertController = UIAlertController(title: "開発者のTwitterを開きます", message: "気軽にご意見ください", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    let url = NSURL(string: "https://twitter.com/ganja_tuber")
                    if UIApplication.shared.canOpenURL(url! as URL){
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    }
                })
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
        }
        
        //ツイートcell
        if indexPath.row == 5{
            let field = self.presentingViewController as! UINavigationController
            let fieldViewController = (field.viewControllers[0] as! FieldViewController)
            
            if fieldViewController.foodWait{
                let alert: UIAlertController = UIAlertController(title: "エサやりの途中ですよ！", message: "", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                
                present(alert, animated: true, completion: nil)
            }
            else{
                if fieldViewController.dying{
                    let alert: UIAlertController = UIAlertController(title: "死んでしまいました…", message: "", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    
                    present(alert, animated: true, completion: nil)
                }
                else if fieldViewController.esaDic[fieldViewController.hiduke] == false || fieldViewController.esaDic[fieldViewController.hiduke] == nil{
                    if fieldViewController.dogStatus{
                        let alert: UIAlertController = UIAlertController(title: "今日のエサやりをしてください", message: "", preferredStyle:  UIAlertController.Style.alert)
                        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                        })
                        alert.addAction(defaultAction)
                        
                        present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert: UIAlertController = UIAlertController(title: "まだ犬がいません", message: "", preferredStyle:  UIAlertController.Style.alert)
                        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                        })
                        alert.addAction(defaultAction)
                        
                        present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    if fieldViewController.arrivalStatus{
                        let text = "”犬にエサをあげるアプリ”で犬にエサをあげたよ\n\n今日は時間通り！\n #犬にエサをあげるアプリ"
                        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        if let encodedText = encodedText,
                            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    else{
                        let dif = fieldViewController.esaDelay[fieldViewController.hiduke] ?? ""
                        let text = "”犬にエサをあげるアプリ”で犬にエサをあげたよ\n\n今日は" + dif + "遅れた… \n #犬にエサをあげるアプリ"
                        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        if let encodedText = encodedText,
                            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //メニューの位置を取得
        let menuPos = self.menuView.layer.position
        //初期位置を画面の外側にするため、メニュー幅の分だけマイナス
        self.menuView.layer.position.x = -self.menuView.frame.width
        //表示用のアニメーション作成
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {self.menuView.layer.position.x = menuPos.x},
            completion: {bool in}
        )
    }
    
    //メニューエリア外タップ時
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches{
            if touch.view?.tag == 1{
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                    completion: {bool in
                        self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    //現在時刻の取得
    func compTime(timeInt: Int) -> Bool{
        let date = Date()
        let dateFormatter = DateFormatter()
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        print("現在時刻:" + dateFormatter.string(from: date))
        
        // 年月日時分秒をそれぞれ個別に取得
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let setTime = String(year) + "年" + String(month) + "月" + String(day) + "日 " + String(timeInt + 5) + ":" + String(00) + ":" + String(00)
        
        let setTimeDate = dateFormatter.date(from: setTime)
        
        print("設定時刻:" + dateFormatter.string(from: setTimeDate!))
        
        if setTimeDate! >= date{
            return true
        }
        else{
            
            //時間差を求める
            let cal = Calendar(identifier: .gregorian)
            let diff = cal.dateComponents([.minute], from: setTimeDate!, to: date)
            difHour = Int(diff.minute!)/60
            difMin = diff.minute! % 60
            return false
        }
    }
    
}

class NewDogCell: UITableViewCell{
    
    
    @IBOutlet weak var cellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
