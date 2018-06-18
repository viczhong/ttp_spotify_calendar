//
//  CreateEventTableViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/17/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class CreateEventTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!

    let dateFormatter = DateFormatter()

    var event: Event?
    var dateString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self

        populateFields()
        print(eventTimeStringToDateComponents(event!.timeStart))

        print(String(describing: event), String(describing: dateString))
        print(startTimePicker.date)
    }

    @IBAction func finishButtonTapped(_ sender: Any) {
        createEvent()

//        startTimePicker.setDate(<#T##date: Date##Date#>, animated: <#T##Bool#>)
    }

    func populateFields() {
        if let event = event {
            titleTextField.text = event.title

            //            makeDate(year: event.year, month: event.month, day: event.day, hr: <#T##Int#>, min: <#T##Int#>)

        }

    }

    func eventTimeStringToDateComponents(_ str: String) -> DateComponents {

        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let date = dateFormatter.date(from: "\(dateString!) \(event!.timeStart)")
        
        print(Date())

        return DateComponents()
//        return DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
    }

    func createEvent() {

    }

    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int) -> Date {
        let calendar = Calendar.current
        // calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min)
        return calendar.date(from: components)!
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateEventTableViewController: UITextFieldDelegate {

}
