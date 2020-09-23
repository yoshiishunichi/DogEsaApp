//
//  RankingViewController.swift
//  DogEsaApp3
//
//  Created by 犬 on 2020/09/22.
//


import Foundation
import UIKit

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let cellId = "cellId"
    var cellNumber = Int()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNumber
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rankingTableView.dequeueReusableCell(withIdentifier: cellId) as! RankingCell
        
        for i in 0...(cellNumber - 1){
            if indexPath.row == i{
                cell.rankLabel.text = String(i+1) + "位"
                cell.nameLabel.text = users[i].username + "さん"
                cell.kaisuuLabel.text = String(users[i].kaisuu) + "回"
            }
        }
        return cell
    }
    
    
    @IBOutlet weak var rankingTableView: UITableView!
    var users = [User]()
    var numbers: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        
        numbers = users.count
        if numbers < 100{
            cellNumber = numbers
        }
        else{
            cellNumber = 100
        }
        users = users.sorted(by: {(a, b) -> Bool in
            return a.kaisuu > b.kaisuu
        })
        
    }
}

class RankingCell: UITableViewCell{
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kaisuuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
