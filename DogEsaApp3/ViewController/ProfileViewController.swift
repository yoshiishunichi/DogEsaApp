//
//  ProfileViewController.swift
//  DogEsaApp3
//
//  Created by 犬 on 2020/09/22.
//


import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var timeInt = 0
    var renzoku = 0
    
    var users = [User]()
    
    let cellId = "cellId"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldNav = presentingViewController as! UINavigationController
        let field = fieldNav.viewControllers[0] as! FieldViewController
        let name = field.name
        let username = field.userName
        let email = field.email
        users = field.users
        
        users = users.sorted(by: {(a, b) -> Bool in
            return a.kaisuu > b.kaisuu
        })
        
        let cell = profileTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileTableViewCell
        if indexPath.row == 0{
            cell.label.text = "あなたの名前"
            if field.login{
                cell.content.text = username
            }
            else{
                cell.content.text = "アカウント登録なし"
            }
        }
        if indexPath.row == 1{
            cell.label.text = "犬の名前"
            cell.content.text = name
        }
        if indexPath.row == 2{
            cell.label.text = "エサやりの時間"
            cell.content.text = String(timeInt + 5) + ":00"
        }
        if indexPath.row == 3{
            self.renzoku = field.renzoku
            cell.label.text = "エサやり成功回数"
            cell.content.text = String(renzoku) + "回"
        }
        if indexPath.row == 4{
            cell.label.text = "今日のエサやり履歴"
            print(field.hiduke)
            if field.esaDic[field.hiduke] ?? false{
                if field.arrivalStatus{
                    cell.content.text = "エサやり完了(時間通り!)"
                }
                else{
                    cell.content.text = "エサやり完了(" + (field.esaDelay[field.hiduke] ?? "") + "遅れ)"
                }
            }
            else{
                cell.content.text = "エサやり終わってません"
            }
        }
        if indexPath.row == 5{
            cell.label.text = "初めて出会った日"
            cell.content.text = String(field.firstYear) + "年" + String(field.firstMonth) + "月" + String(field.firstDay) + "日"
        }
        if indexPath.row == 6{
            cell.label.text = "あなたの順位"
            if field.login{
                
                var rank = 0
                for i in 0...(users.count - 1){
                    if users[i].email == email{
                        rank = i
                        break
                    }
                }
                cell.content.text = String(rank + 1) + "位"
            }
            else{
                cell.content.text = "アカウント登録なし"
            }
        }
        return cell
        
    }
    
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
    }
}

class ProfileTableViewCell: UITableViewCell{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
