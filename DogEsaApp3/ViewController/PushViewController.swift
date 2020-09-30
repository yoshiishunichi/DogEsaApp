//
//  PushViewController.swift
//  DogEsaApp3
//
//  Created by 犬 on 2020/09/30.
//

import Foundation
import UIKit
import os


class PushViewController: UIViewController, UNUserNotificationCenterDelegate{
    var timeInt = 0
    var status = false
    
    @IBAction func pushSetButton(_ sender: Any) {
        os_log("setlocalNotfication")
        // 設定に必要なクラスをインスタンス化
        var notificationTime = DateComponents()
        var trigger: UNNotificationTrigger
        // 5分前に通知
        notificationTime.hour = timeInt + 4
        notificationTime.minute = 55
        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
        
        // UNMutableNotificationContentクラスをインスタンス化
        let content = UNMutableNotificationContent()

        // 通知のメッセージセット
        content.title = ""
        content.body = "あと5分でエサやり時間です！"
        content.sound = UNNotificationSound.default
        
        // 通知スタイルを指定
        let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)

        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        statusLabel.text = "現在の通知の状態:オン"
        status = true
        saveStatus()
        setButton.isEnabled = false
        stopButton.isEnabled = true
        setButton.layer.borderWidth = 0.5
        setButton.layer.cornerRadius = 15
        setButton.backgroundColor = .gray
        
        stopButton.layer.borderWidth = 0.5
        stopButton.layer.cornerRadius = 15
        stopButton.backgroundColor = .orange
    }
    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func pushStopButton(_ sender: Any) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["uuid"])
        statusLabel.text = "現在の通知の状態:オフ"
        status = false
        setButton.isEnabled = true
        stopButton.isEnabled = false
        
        setButton.layer.borderWidth = 0.5
        setButton.layer.cornerRadius = 15
        setButton.backgroundColor = .orange
        
        stopButton.layer.borderWidth = 0.5
        stopButton.layer.cornerRadius = 15
        stopButton.backgroundColor = .gray
        saveStatus()
        
    }
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        status = defaults.bool(forKey: "status")
        if status{
            statusLabel.text = "現在の通知の状態:オン"
            setButton.isEnabled = false
            stopButton.isEnabled = true
            setButton.layer.borderWidth = 0.5
            setButton.layer.cornerRadius = 15
            setButton.backgroundColor = .gray
            
            stopButton.layer.borderWidth = 0.5
            stopButton.layer.cornerRadius = 15
            stopButton.backgroundColor = .orange
            
        }
        else{
            statusLabel.text = "現在の通知の状態:オフ"
            setButton.isEnabled = true
            stopButton.isEnabled = false
            
            setButton.layer.borderWidth = 0.5
            setButton.layer.cornerRadius = 15
            setButton.backgroundColor = .orange
            
            stopButton.layer.borderWidth = 0.5
            stopButton.layer.cornerRadius = 15
            stopButton.backgroundColor = .gray
            
        }
        // 通知許可の取得
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }
    func saveStatus(){
        let defaults = UserDefaults.standard
        defaults.set(status, forKey: "status")
    }
}
