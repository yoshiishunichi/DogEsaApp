//
//  FieldViewController.swift
//  DogEsaApp3
//
//  Created by 犬 on 2020/09/22.
//


import Foundation
import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth
import os

class FieldViewController: UIViewController{
    
    var users = [User]()
    
    var player: AVAudioPlayer?
    
    var userName = ""
    var email = ""
    var password = ""
    var login = false
    
    @IBOutlet weak var bgImageView: UIImageView!
    var dogImageView = UIImageView()
    let foodImageView = UIImageView()
    var dogStatus = false
    var foodWait = false
    var arrivalStatus = false
    var dying = false
    var dif = ""
    var esaDic:[String: Bool] = [:]
    var esaDelay:[String: String] = [:]
    var hiduke = ""
    var kinou = ""
    
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var navigationBarHeight: CGFloat = 0
    
    var name = ""
    var renzoku = 0
    var timeInt = Int()
    var time = Date()
    var firstYear = 0
    var firstMonth = 0
    var firstDay = 0
    
    
    @IBOutlet weak var serihuView: UIView!
    @IBOutlet weak var ueLabel: UILabel!
    @IBOutlet weak var sitaLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        // 通知の使用許可をリクエスト
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        self.bgImageView.addSubview(serihuView)
        self.view.bringSubviewToFront(serihuView)
        
        let defaults = UserDefaults.standard
        userName = defaults.string(forKey: "userName") ?? userName
        email = defaults.string(forKey: "email") ?? email
        password = defaults.string(forKey: "password") ?? password
        login = defaults.bool(forKey: "login")
        
        dogStatus = defaults.bool(forKey: "dogStatus")
        name = defaults.string(forKey: "name") ?? ""
        timeInt = defaults.integer(forKey: "timeInt")
        renzoku = defaults.integer(forKey: "renzoku")
        esaDic = defaults.value(forKey: "esaDic") as? [String : Bool] ?? [:]
        esaDelay = defaults.value(forKey: "esaDelay") as? [String: String] ?? [:]
        arrivalStatus = defaults.bool(forKey: "arrival")
        dying = defaults.bool(forKey: "dying")
        firstYear = defaults.integer(forKey: "firstYear")
        firstMonth = defaults.integer(forKey: "firstMonth")
        firstDay = defaults.integer(forKey: "firstDay")
        
        //ログイン画面への遷移
        if login != true && dogStatus != true{
            let storyboard = UIStoryboard(name: "SignUp", bundle:  nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            signUpViewController.modalPresentationStyle = .fullScreen
            self.present(signUpViewController, animated: true, completion: nil)
        }
        if userName == ""{
            self.setText(ue: "犬にエサをあげるアプリに", sita: "ようこそ！")
        }
        else{
            self.setText(ue: "犬にエサをあげるアプリに", sita: userName + "さん ようこそ！")
        }
        
        
        //画面のサイズ取得
        let navigationController: UINavigationController = UINavigationController()
        navigationBarHeight = navigationController.navigationBar.frame.size.height
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height - navigationBarHeight
        
        
        let date = Date()
        // 年月日をそれぞれ個別に取得
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        hiduke = String(year) + "年" + String(month) + "月" + String(day) + "日"
        let yds = yesterday(year: year, month: month, day: day)
        kinou = String(yds[0]) + "年" + String(yds[1]) + "月" + String(yds[2]) + "日"
        
        print("日付設定:", hiduke)
        if esaDic[hiduke] == nil{
            print(hiduke + "の辞書をfalseにします")
            print("昨日:" + kinou)
            esaDic[hiduke] = false
            arrivalStatus = false
            self.saveData()
        }
        
        if login{
            guard let userID = Auth.auth().currentUser?.uid else { return }
            uid = userID
            print("uid:", uid)
        }
        if (esaDic[kinou] == false || esaDic[kinou] == nil) && dogStatus == true{
            die()
        }
        if dying{
            die()
        }
        if dogStatus{
            dogImageView.image = UIImage(named: "犬")
            
            let scale:CGFloat = 0.5
            
            dogImageView.frame = CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: (dogImageView.image?.size.width)! * scale, height: (dogImageView.image?.size.height)! * scale)
            dogImageView.center = self.view.center
            self.bgImageView.addSubview(dogImageView)
            self.bgImageView.sendSubviewToBack(dogImageView)
            
            if userName != ""{
                setText(ue: userName + " さん", sita: "おかえりなさい!")
            }
            else{
                setText(ue: "おかえりなさい！", sita: "")
            }
            jump()
        }
    }
    
    var uid: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let date = Date()
        // 年月日をそれぞれ個別に取得
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        hiduke = String(year) + "年" + String(month) + "月" + String(day) + "日"
        let yds = yesterday(year: year, month: month, day: day)
        kinou = String(yds[0]) + "年" + String(yds[1]) + "月" + String(yds[2]) + "日"
        
        print("日付設定will:", hiduke)
        if esaDic[hiduke] == nil{
            print(hiduke + "の辞書をfalseにします")
            print("昨日:" + kinou)
            esaDic[hiduke] = false
            arrivalStatus = false
            self.saveData()
        }
        if dogStatus && (dying == false){
            jump()
        }
        if dogStatus{
            fetchUserInfoFromFireStore()
        }
        if login{
            guard let userID = Auth.auth().currentUser?.uid else { return }
            uid = userID
            print("uid:", uid)
        }
    }
    
    private func fetchUserInfoFromFireStore(){
        users = [User]()
        Firestore.firestore().collection("users").getDocuments{ (snapshots, err) in
            if let err = err{
                print("ユーザ情報の取得に失敗しました\(err)")
                return
            }
            snapshots?.documents.forEach({(snapshot) in
                let data = snapshot.data()
                let user = User.init(dic: data)
                self.users.append(user)
                self.users.forEach({
                    (user) in
                    print("user.username:", user.username)
                })
                
            })
            
        }
    }
    
    func addDog(){
        if dogStatus == false{
            dogImageView.image = UIImage(named: "犬")
            
            let scale:CGFloat = 0.5
            
            dogImageView.frame = CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: (dogImageView.image?.size.width)! * scale, height: (dogImageView.image?.size.height)! * scale)
            dogImageView.center = self.view.center
            self.bgImageView.addSubview(dogImageView)
            self.bgImageView.sendSubviewToBack(dogImageView)
            self.bgImageView.bringSubviewToFront(serihuView)
            dogStatus = true
            esaDic[kinou] = true
            dying = false
            
            let date = Date()
           
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            firstYear = year
            firstMonth = month
            firstDay = day

        }
        else{
            let alert: UIAlertController = UIAlertController(title: "既に犬がいます", message: "", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        self.saveData()
        if login{
            fetchUserInfoFromFireStore()
        }
    }
    
    func releaseDog(){
        
        dogImageView.removeFromSuperview()
        dogStatus = false
        arrivalStatus = false
        dying = false
        name = ""
        timeInt = 0
        renzoku = 0
        esaDic = [:]
        esaDelay = [:]
        firstYear = 0
        firstMonth = 0
        firstDay = 0
        
        setText(ue: "犬を 逃しました…", sita: "さよなら…")
        
        saveData()
        if self.login{
            let docRef = Firestore.firestore().collection("users").document(self.uid)
            docRef.updateData(["kaisuu": self.renzoku])
            self.fetchUserInfoFromFireStore()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if foodWait{
            print("エサ置くよ")
            if(location.y > self.view.frame.height - self.serihuView.frame.height - 20){
                setText(ue: "下すぎる", sita: "わよ")
            }
            else{
                foodImageView.image = UIImage(named: "エサ")
                foodImageView.frame = CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: (foodImageView.image?.size.width)! * 0.3, height: (foodImageView.image?.size.height)! * 0.3)
                foodImageView.center = location
                self.view.addSubview(foodImageView)
                self.view.bringSubviewToFront(foodImageView)
                foodWait = false
                UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
                    self.dogImageView.center.x = self.foodImageView.center.x
                    self.dogImageView.center.y = self.foodImageView.center.y - 50
                },completion: {
                    finished in
                    
                    self.foodImageView.removeFromSuperview()
                    self.esaDic[self.hiduke] = true
                    if self.arrivalStatus{
                        
                        self.renzoku += 1
                        if self.login{
                            let docRef = Firestore.firestore().collection("users").document(self.uid)
                            docRef.updateData(["kaisuu": self.renzoku])
                            self.fetchUserInfoFromFireStore()
                        }
                        self.setText(ue: "エサやり 成功!", sita: "(現在" + String(self.renzoku) + "回成功中)")
                        self.saveData()
                    }
                    else{
                        if self.login{
                            let docRef = Firestore.firestore().collection("users").document(self.uid)
                            docRef.updateData(["kaisuu": self.renzoku])
                            self.fetchUserInfoFromFireStore()
                        }
                        self.setText(ue: "明日は 時間通りエサやりしてね!", sita: "(" + self.dif + " 遅かったよ)")
                        self.esaDelay[self.hiduke] = self.dif
                        self.saveData()
                    }
                    UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
                        self.dogImageView.center = self.view.center
                    }, completion: {
                        finished in
                        self.jump()
                    })
                })
                
            }
        }
        print(location)
    }
    
    //データを保持
    func saveData(){
        let defaults = UserDefaults.standard
        defaults.set(dogStatus, forKey: "dogStatus")
        defaults.set(name, forKey: "name")
        defaults.set(timeInt, forKey: "timeInt")
        defaults.set(renzoku, forKey: "renzoku")
        defaults.set(esaDic, forKey: "esaDic")
        defaults.set(arrivalStatus, forKey: "arrival")
        defaults.set(esaDelay, forKey: "esaDelay")
        defaults.set(dying, forKey: "dying")
        defaults.set(userName, forKey: "userName")
        defaults.set(email, forKey: "email")
        defaults.set(password, forKey: "password")
        defaults.set(login, forKey: "login")
        defaults.set(firstYear, forKey: "firstYear")
        defaults.set(firstMonth, forKey: "firstMonth")
        defaults.set(firstDay, forKey: "firstDay")
    }
    
    func move(){
        
    }
    
    func moveAround(fig: UIView, figSize: CGFloat) {
        //一辺を動く時間
        let widthDuration: Double = 2.0
        //        let heightDuration: Double = widthDuration * Double(screenHeight/screenWidth)
        
        //初期位置を左上にセット
        fig.center = self.view.center
        
        //アニメーション
        UIView.animate(withDuration: widthDuration, delay: 0, options: .curveLinear, animations: {
            fig.center.x -= (self.screenWidth-figSize)
        }, completion: {
            finished in
            var transMiller = CGAffineTransform()
            transMiller = CGAffineTransform(scaleX: -1.0, y: 1.0)
            fig.transform = transMiller
            UIView.animate(withDuration: widthDuration, delay: 0, options: .curveLinear, animations: {
                fig.center.x += (self.screenWidth-figSize)
            },completion: nil)
        })
    }
    
    func die(){
        setText(ue: name + " は 死んでしまった…", sita: "さよなら " + name + "…")
        dogImageView.image = UIImage(named: "墓")
        
        let scale:CGFloat = 0.5
        
        dogImageView.frame = CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: (dogImageView.image?.size.width)! * scale, height: (dogImageView.image?.size.height)! * scale)
        dogImageView.center = self.view.center
        self.view.addSubview(dogImageView)
        dogStatus = false
        dying = true
        renzoku = 0
        if login{
            let docRef = Firestore.firestore().collection("users").document(self.uid)
            docRef.updateData(["kaisuu": self.renzoku])
            fetchUserInfoFromFireStore()
        }
        saveData()
    }
    
    func yesterday(year: Int, month: Int, day: Int) ->[Int]{
        var y = year
        var m = month
        var d = day
        
        var yd:[Int] = [y, m, d]
        if d == 1{
            if m == 1{
                y -= 1
                m = 12
                d = 31
            }
            else{
                m -= 1
                if m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10{
                    d = 31
                }
                else if m == 2{
                    if (y % 4 == 0){
                        d = 29
                    }
                    else{
                        d = 28
                    }
                }
                else{
                    d = 30
                }
            }
        }
        else{
            d -= 1
        }
        yd[0] = y
        yd[1] = m
        yd[2] = d
        return yd
    }
    
    func setText(ue: String, sita: String){
        self.ueLabel.text = ue
        self.sitaLabel.text = sita
    }
    
    func jump(){
        let soundURL = Bundle.main.url(forResource: "レトロジャンプ", withExtension: "mp3")
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseIn], animations: {
            self.dogImageView.center.y -= 50.0
            do {
                // 効果音を鳴らす
                self.player = try AVAudioPlayer(contentsOf: soundURL!)
                self.player?.play()
            } catch {
                print("エラー")
            }
        }, completion: {
            _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
                self.dogImageView.center.y += 50.0
            }, completion: {
                _ in
                UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseIn], animations: {
                    self.dogImageView.center.y -= 50.0
                    do {
                        // 効果音を鳴らす
                        self.player = try AVAudioPlayer(contentsOf: soundURL!)
                        self.player?.play()
                    } catch {
                        print("エラー")
                    }
                }, completion: {
                    _ in
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
                        self.dogImageView.center.y += 50.0
                    }, completion: nil)
                })
            })
        })
    }
}
