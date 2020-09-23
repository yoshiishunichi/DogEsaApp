//
//  EnterViewController.swift
//  DogEsaApp3
//
//  Created by 犬 on 2020/09/22.
//


import Foundation
import UIKit
import Firebase
import GoogleMobileAds

class EnterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var first = false
    var timeInt = 0
    
    //pickerviewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //pickerviewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeList.count
    }
    
    //pickerviewの最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeList[row]
    }
    
    //pickerviewのrowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        esaLabel.text = "エサやりの時間(" + timeList[row] + ")"
        timeInt = row
    }
    
    
    @IBOutlet weak var ketteiButton: UIButton!
    @IBAction func tappedKetteiButton(_ sender: Any) {
        
        let fieldNav = presentingViewController as! UINavigationController
        let field = fieldNav.viewControllers[0] as! FieldViewController
        
        if first{
            field.name = self.nameTextField.text ?? ""
            field.setText(ue: field.name + "を 飼いました!", sita: "よろしくね!")
        }
        else {
            field.name = self.nameTextField.text ?? ""
            field.setText(ue:"情報を編集しました", sita: "")
        }
        field.timeInt = timeInt
        field.saveData()
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var esaLabel: UILabel!
    @IBOutlet weak var errLabel: UILabel!
    
    let timeList = ["5時", "6時", "7時", "8時", "9時", "10時"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //admob
        let gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        gadBannerView.center = self.view.center
        gadBannerView.adUnitID = "ca-app-pub-1923099754481403/6673096314"
        gadBannerView.rootViewController = self;
        let request = GADRequest();
        
        gadBannerView.load(request)
        
        gadBannerView.frame = CGRect(x: 0, y: view.frame.height - gadBannerView.frame.height, width: view.frame.width, height: gadBannerView.frame.height)
        
        self.view.addSubview(gadBannerView)
        
        errLabel.textColor = .clear
        if !(first){
            let fieldNav = presentingViewController as! UINavigationController
            let field = fieldNav.viewControllers[0] as! FieldViewController
            nameTextField.text = field.name
            
            field.saveData()
            
            gadBannerView.center.y -= 40
        }
        
        ketteiButton.isEnabled = true
        ketteiButton.backgroundColor = .orange
        ketteiButton.layer.cornerRadius = 15
        ketteiButton.layer.borderWidth = 1
        ketteiButton.layer.borderColor = UIColor.gray.cgColor
        if (nameTextField.text?.isEmpty ?? false){
            ketteiButton.isEnabled = false
            ketteiButton.backgroundColor = .gray
        }
        
        nameTextField.delegate = self
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        timePickerView.selectRow(timeInt, inComponent: 0, animated: false)
    }
    
    @IBAction func tappedReturn(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EnterViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nameIsEmpty = nameTextField.text?.isEmpty ?? false
        
        if nameIsEmpty{
            ketteiButton.isEnabled = false
            ketteiButton.backgroundColor = .gray
            errLabel.textColor = .red
        }
        else if (nameTextField.text?.count ?? 0) > 5{
            ketteiButton.isEnabled = false
            ketteiButton.backgroundColor = .gray
            errLabel.textColor = .red
        }
        else{
            ketteiButton.isEnabled = true
            ketteiButton.backgroundColor = .orange
            errLabel.textColor = .clear
        }
    }
}

