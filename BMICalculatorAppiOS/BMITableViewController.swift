//
//  BMITableViewController.swift
//  BMICalculatorAppiOS
//
//  Created by Ashkan Goharfar on 9/25/1400 AP.
//
import RealmSwift
import UIKit
import SwiftUI

class BMITableViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource {

    public var data = [BMIListObject]()
    @IBOutlet var table: UITableView!
    private let realmDB = try! Realm()
//    data = realmDB.objects(BMIListObject)
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
//        data = realmDB.objects(ToDoListObject.self).map({ $0 })
        table.reloadData()
//        switchTaskIsComplete = false
        table.delegate = self
        table.dataSource = self
    }
    
    func render() {
        let bMIList = try! realmDB.objects(BMIListObject.self)
        for bmi in bMIList {
            data.append(bmi)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Here :::::::::::::::::")
        print(indexPath.row)
        print(data[indexPath.row].weight)
//        indexPathRow = indexPath.row
//        indexPathList.append(indexPath)
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
//        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "Weight: " + data[indexPath.row].weight
        
        var dateFormatter = DateFormatter()
//        cell?.detailTextLabel?.text = String(data[indexPath.row].currentDate)
        print("Date :::::::")

        dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss a"
        var formatteddate = dateFormatter.string(from: data[indexPath.row].currentDate)
        print(formatteddate)
        cell?.detailTextLabel?.text = formatteddate
        
        // Code to add switch in Table cell
        let switchView = UISwitch(frame: .zero)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)

//        if (data[indexPath.row]. == true) {
//            cell?.detailTextLabel?.text = "Completed"
//            switchView.setOn(true, animated: true)
//        }
//        else if (data[indexPath.row].isCompleted == false){
//            cell?.detailTextLabel?.text = "Pending"
//            switchView.setOn(false, animated: true)
//        }
//        if (data[indexPath.row].isCompleted == true) {
//            cell?.detailTextLabel?.text = "Completed"
//        }
//        else if (data[indexPath.row].isCompleted == false){
//            cell?.detailTextLabel?.text = "Pending"
//        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
//        label.center = CGPoint(x: 160, y: 285)
//        label.textAlignment = .center
        label.text = "BMI: " + data[indexPath.row].currentBMIImperial + data[indexPath.row].currentBMIMetric
        cell!.accessoryView = label
        return cell!
    }

    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let item = data[indexPath.row]
//
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: "edit") as? EditViewController else {
//            return
//        }
//        vc.item = item
//        vc.deletionHandler = { [weak self] in
//            self?.refresh()
//        }
//        vc.afterEditHandler = { [weak self] in
//            self?.refresh()
//        }
//
//        vc.navigationItem.largeTitleDisplayMode = .never
//        vc.title = item.item
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func pressedAddNewTaskButton()
//    {
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: "enter") as? EntryViewController else {
//            return
//        }
//        vc.afterSaveHandler = { [weak self] in
//            self?.refresh()
//        }
//        vc.title = "New Task"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    // This function will give all of data from Realm database and will reload our tableview
    func refresh()
    {
        // Update the data according to the database
        data = realmDB.objects(BMIListObject.self).map({ $0 })
        table.reloadData()
    }

    @objc func switchChanged(_ sender: UISwitch) {
//        indexPathRow = sender.tag
//        if (sender.isOn){
//            try! realmDB.write{
//                data[indexPathRow].isCompleted = true
//            }
//            afterSwitchHandler?()
//            if let cell = table.cellForRow(at: indexPathList[indexPathRow]) as? UITableViewCell{
//                cell.detailTextLabel?.text = "Completed"
//            }
//        }
//        else{
//            try! realmDB.write{
//                data[indexPathRow].isCompleted = false
//            }
//            afterSwitchHandler?()
//            if let cell = table.cellForRow(at: indexPathList[indexPathRow]) as? UITableViewCell{
//                cell.detailTextLabel?.text = "Pending"
//            }
//        }
//        print(data[indexPathRow].isCompleted)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
