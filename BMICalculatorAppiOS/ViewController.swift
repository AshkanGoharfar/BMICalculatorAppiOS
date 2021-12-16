//
//  ViewController.swift
//  BMICalculatorAppiOS
//
//  Created by Ashkan Goharfar on 9/25/1400 AP.
//

import RealmSwift
import UIKit

/**
 * Create To do list object for database and other purposes as it includes a tasks parameters like name of the task, description of the task and etc.
 */
class BMIListObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var gender: String = ""
    @objc dynamic var scroingType: Bool = false
    @objc dynamic var currentDate: Date = Date()
    @objc dynamic var weight: String = ""
    @objc dynamic var height: String = ""
    @objc dynamic var currentBMIImperial: String = ""
    @objc dynamic var currentBMIMetric: String = ""
    @objc dynamic var currentBMIMessage: String = ""
}


class ViewController: UIViewController {

    private let realmDB = try! Realm()
    private var data = [BMIListObject]()
    
    
    @IBOutlet var datePickerItem: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bMITypeLabel: UILabel!
    @IBOutlet weak var weightTypeLabel: UILabel!
    @IBOutlet weak var heightTypeLabel: UILabel!
    
    @IBOutlet weak var currentBMIValue: UILabel!
    
    @IBOutlet weak var bMIMessageString: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let realmDB = try! Realm()
//        try! realmDB.write {
//          realmDB.deleteAll()
//        }
        title = "Personal Information Screen"
        view.backgroundColor = .systemGray6
        
        let buttonDone = UIButton(frame: CGRect(x: 30, y:760, width: 70, height: 50))
        view.addSubview(buttonDone)
        buttonDone.backgroundColor = .systemMint
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
//        datePickerItem.setDate(Date(), animated: true)
        }
    
    
    
    @objc func didTapDoneButton () {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BMITable") as? BMITableViewController else {
            return
        }
        vc.title = "BMI Tracking Screen"
        vc.navigationItem.largeTitleDisplayMode = .never


        if let weight = weightTextField.text, !weight.isEmpty{
//            let dateIssued = Date().timeIntervalSinceNow
//            let calendar = Calendar.current
            realmDB.beginWrite()
            
            let newItem = BMIListObject()
//            newItem.date = date
            newItem.name = nameTextField.text!
            newItem.age = ageTextField.text!
            newItem.id = ""
            newItem.gender = genderTextField.text!
            newItem.weight = weightTextField.text!
            newItem.height = heightTextField.text!
            newItem.currentDate = datePickerItem.date
            newItem.currentBMIImperial = calculateBMIImperial()
            newItem.currentBMIMetric = calculateBMIMetric()
            newItem.currentBMIMessage = showBMIMessage()

            if (bMITypeLabel.text == "Imperial"){
                newItem.scroingType = false
            }
            else if (bMITypeLabel.text == "Metric"){
                newItem.scroingType = true
            }

            realmDB.add(newItem)
            try! realmDB.commitWrite()
            // ? means that the completionhandler is optional
            
            navigationController?.popToRootViewController(animated: true)
        }
        else{
            print("Nothing!")
        }

        nameTextField.text = ""
        ageTextField.text = ""
        genderTextField.text = ""
        weightTextField.text = ""
        heightTextField.text = ""
        bMITypeLabel.text = "Metric"
        weightTypeLabel.text = "(Kilograms)"
        heightTypeLabel.text = "(Meters)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // This function will give all of data from Realm database and will reload our tableview
    func refresh()
    {
        // Update the data according to the database
        data = realmDB.objects(BMIListObject.self).map({ $0 })
    }
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        nameTextField.text = ""
        ageTextField.text = ""
        genderTextField.text = ""
        weightTextField.text = ""
        heightTextField.text = ""
        bMITypeLabel.text = "Metric"
        weightTypeLabel.text = "(Kilograms)"
        heightTypeLabel.text = "(Meters)"
    }
        
    
    @IBAction func scrollingTypeSwitchPressed(_ sender: UISwitch) {
        if (sender.isOn){
            bMITypeLabel.text = "Metric"
            weightTypeLabel.text = "(Kilograms)"
            heightTypeLabel.text = "(Meters)"
        }
        else{
            bMITypeLabel.text = "Imperial"
            weightTypeLabel.text = "(Pounds)"
            heightTypeLabel.text = "(Inches)"

        }
    }
    
    
    @IBAction func calculateBMIButtonDidPressed(_ sender: UIButton) {
        if (weightTextField.text != "" && heightTextField.text != ""){
            if (bMITypeLabel.text == "Imperial"){
                calculateBMIImperial()
            }
            else if (bMITypeLabel.text == "Metric"){
                calculateBMIMetric()
            }
        }
    }
    
    func showBMIMessage() -> String {
        if (currentBMIValue.text != ""){
            if (Double(currentBMIValue.text!)! < 16){
                bMIMessageString.text = "Sever Thinness"
            }
            else if (Double(currentBMIValue.text!)! >= 16 && Double(currentBMIValue.text!)! < 17){
                bMIMessageString.text = "Moderate Thinness"
            }
            else if (Double(currentBMIValue.text!)! >= 17 && Double(currentBMIValue.text!)! < 18.5){
                bMIMessageString.text = "Mild Thinness"
            }
            else if (Double(currentBMIValue.text!)! >= 18.5 && Double(currentBMIValue.text!)! < 25){
                bMIMessageString.text = "Normal"
            }
            else if (Double(currentBMIValue.text!)! >= 25 && Double(currentBMIValue.text!)! < 30){
                bMIMessageString.text = "Overweight"
            }
            else if (Double(currentBMIValue.text!)! >= 30 && Double(currentBMIValue.text!)! < 35){
                bMIMessageString.text = "Obese Class I"
            }
            else if (Double(currentBMIValue.text!)! >= 35 && Double(currentBMIValue.text!)! < 40){
                bMIMessageString.text = "Obese Class II"
            }
            else if (Double(currentBMIValue.text!)! >= 40){
                bMIMessageString.text = "Obese Class III"
            }
        }
        return bMIMessageString.text!
    }
    
    func calculateBMIImperial() -> String {
        currentBMIValue.text = String(round(1000*(Double(weightTextField.text!)! * 730) / (Double(heightTextField.text!)! * Double(heightTextField.text!)!))/1000)
        showBMIMessage()
        return currentBMIValue.text!
    }
    
    func calculateBMIMetric() -> String {
        currentBMIValue.text = String(round(1000*(Double(weightTextField.text!)!) / (Double(heightTextField.text!)! * Double(heightTextField.text!)!))/1000)
        showBMIMessage()
        return currentBMIValue.text!
    }
}

