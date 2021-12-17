//
//  EditViewController.swift
//  BMICalculatorAppiOS
//
//  Created by Ashkan Goharfar on 9/25/1400 AP.
//
import RealmSwift
import UIKit

class EditViewController: UIViewController {
    public var bMIRecord: BMIListObject?
    // We are going to call this function once the item has been deleted and we are goiing to referesh list as it doesnt exist anymore
    public var deletionHandler: (() -> Void)?
    
    public var afterEditHandler: (() -> Void)?

    private let realmDB = try! Realm()
    


    @IBOutlet var datePickerItem: UIDatePicker!
    @IBOutlet weak var nameLabelEditScreen: UILabel!
    @IBOutlet weak var ageLabelEditScreen: UILabel!
    @IBOutlet weak var genderLabelEditScreen: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var bMITypeLabel: UILabel!
    @IBOutlet weak var weightTypeLabel: UILabel!
    @IBOutlet weak var heightTypeLabel: UILabel!
    
    @IBOutlet weak var currentBMIValue: UILabel!
    
    @IBOutlet weak var bMIMessageString: UILabel!
    
    
    // Take date object formatting to string and we use static in order to create it one time and store minimum size in memory
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Personal Edit Information Screen"
        view.backgroundColor = .systemGray6
        
        let buttonDone = UIButton(frame: CGRect(x: 30, y:760, width: 70, height: 50))
        view.addSubview(buttonDone)
        buttonDone.backgroundColor = .systemMint
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
//        print("BMI record !!!!!!!!!!!!!!!!!!")
//        print(bMIRecord?.name)
        nameLabelEditScreen.text = bMIRecord?.name
        ageLabelEditScreen.text = bMIRecord?.age
        genderLabelEditScreen.text = bMIRecord?.gender
        datePickerItem.setDate(Date(), animated: true)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss a"
        var formatteddate = dateFormatter.string(from: bMIRecord!.currentDate)
        dateLabel?.text = formatteddate
        if (bMIRecord?.scroingType == false){
            bMITypeLabel.text = "Imperial"
        }
        else {
            bMITypeLabel.text = "Metric"
        }
        
        weightTextField.text = bMIRecord?.weight
        heightTextField.text = bMIRecord?.height

        if (bMIRecord?.scroingType == false){
            currentBMIValue.text = bMIRecord?.currentBMIImperial
        }
        else {
            currentBMIValue.text = bMIRecord?.currentBMIMetric
        }
        bMIMessageString.text = bMIRecord?.currentBMIMessage
        datePickerItem.setDate(Date(), animated: true)
        
        let switchDemo=UISwitch(frame:CGRect(x: 327, y: 235, width: 0, height: 0))
        switchDemo.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
        switchDemo.setOn(false, animated: false)
        if (bMIRecord?.scroingType == false){
            bMITypeLabel.text = "Imperial"
            switchDemo.setOn(false, animated: false)
        }
        else {
            bMITypeLabel.text = "Metric"
            switchDemo.setOn(true, animated: false)
        }
        self.view.addSubview(switchDemo)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    }
    
    
    @objc func switchStateDidChange(_ sender:UISwitch!)
    {

        if (sender.isOn){
//            isCompletedFlag = true
            try! realmDB.write {
                bMIRecord?.scroingType = true
            }
            bMITypeLabel.text = "Metric"
            weightTypeLabel.text = "(Kilograms)"
            heightTypeLabel.text = "(Meters)"
        }
        else{
//            isCompletedFlag = false
            try! realmDB.write {
                bMIRecord?.scroingType = false
            }
            bMITypeLabel.text = "Imperial"
            weightTypeLabel.text = "(Pounds)"
            heightTypeLabel.text = "(Inches)"
        }
    }

    @objc private func didTapDelete()
    {
        guard let deletedItem = self.bMIRecord else{
            return
        }
        realmDB.beginWrite()
        realmDB.delete(deletedItem)
        try! realmDB.commitWrite()
        
        // we use ? because the function is optional
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }

    
    @objc func didTapDoneButton () {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BMITable") as? BMITableViewController else {
            return
        }
        vc.title = "BMI Tracking Screen"
        vc.navigationItem.largeTitleDisplayMode = .never


        if let weight = weightTextField.text, !weight.isEmpty{
//            realmDB.beginWrite()
//
//            let newItem = BMIListObject()
//            newItem.name = nameLabelEditScreen.text!
//            newItem.age = ageLabelEditScreen.text!
//            newItem.id = ""
//            newItem.gender = genderLabelEditScreen.text!
//            newItem.weight = weightTextField.text!
//            newItem.height = heightTextField.text!
//            newItem.currentDate = datePickerItem.date
//            newItem.currentBMIMessage = showBMIMessage()
//
//            if (bMITypeLabel.text == "Imperial"){
//                newItem.scroingType = false
//                newItem.currentBMIImperial = calculateBMIImperial()
//                newItem.currentBMIMetric = ""
//            }
//            else if (bMITypeLabel.text == "Metric"){
//                newItem.scroingType = true
//                newItem.currentBMIMetric = calculateBMIMetric()
//                newItem.currentBMIImperial = ""
//            }
//
//            realmDB.add(newItem)
//            try! realmDB.commitWrite()
//            // ? means that the completionhandler is optional
//
//            navigationController?.popToRootViewController(animated: true)
            let date = datePickerItem.date
            try! realmDB.write {
            bMIRecord?.currentDate = date
            if (bMITypeLabel.text == "Imperial"){
                bMIRecord?.scroingType = false
                bMIRecord?.currentBMIImperial = calculateBMIImperial()
                bMIRecord?.currentBMIMetric = ""
            }
            else if (bMITypeLabel.text == "Metric"){
                bMIRecord?.scroingType = true
                bMIRecord?.currentBMIMetric = calculateBMIMetric()
                bMIRecord?.currentBMIImperial = ""
            }
            
            bMIRecord?.weight = weightTextField.text!
            bMIRecord?.height = heightTextField.text!
            
            bMIRecord?.id = ""
            bMIRecord?.currentBMIMessage = showBMIMessage()
            
            }
        }
        else{
            print("Nothing!")
        }

        nameLabelEditScreen.text = ""
        ageLabelEditScreen.text = ""
        genderLabelEditScreen.text = ""
        weightTextField.text = ""
        heightTextField.text = ""
        bMITypeLabel.text = "Metric"
        weightTypeLabel.text = "(Kilograms)"
        heightTypeLabel.text = "(Meters)"
        currentBMIValue.text = ""
        bMIMessageString.text = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // This function will give all of data from Realm database and will reload our tableview
//    func refresh()
//    {
//        // Update the data according to the database
//        data = realmDB.objects(BMIListObject.self).map({ $0 })
//    }
    
    
        
    @IBAction func resetButtonPressed(_ sender: UIButton) {
            weightTextField.text = ""
            heightTextField.text = ""
            bMITypeLabel.text = "Metric"
            weightTypeLabel.text = "(Kilograms)"
            heightTypeLabel.text = "(Meters)"
            currentBMIValue.text = ""
            bMIMessageString.text = ""
    }
    

//    @IBAction func scoringSwitchPressed(_ sender: UISwitch) {
//            if (sender.isOn){
//                bMITypeLabel.text = "Metric"
//                weightTypeLabel.text = "(Kilograms)"
//                heightTypeLabel.text = "(Meters)"
//            }
//            else{
//                bMITypeLabel.text = "Imperial"
//                weightTypeLabel.text = "(Pounds)"
//                heightTypeLabel.text = "(Inches)"
//            }
//    }
    
    
    @IBAction func calculateBMIButtonPressed(_ sender: UIButton) {
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
