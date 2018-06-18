//
//  DateEventTableViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/17/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class DateEventTableViewController: UITableViewController {

    var dateStringLong: String!
    var sortedEvents = [Event]()
    var valueToPass: Event?
    var dateManager: DateManager!
    var events: [Event]? {
        didSet {
            events?.sort(by: {
                dateManager.eventTimeStringToDate(navigationItem.title, $0.startTime)! < dateManager.eventTimeStringToDate(navigationItem.title, $1.startTime)!
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "eventCell")
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell

        if let event = events?[indexPath.row] {
            cell.timeLabel.text = "\(event.startTime) - \(event.endTime) "
            cell.eventLabel.text = event.title
        }

        return cell
    }
    

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    // TODO: - Add Delete Functions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //            tableView.deleteRows(at: [indexPath], with: .fade)
        }  
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        valueToPass = events?[indexPath.row]
        performSegue(withIdentifier: "editEventAtDateSegue", sender: self)
    }

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


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "editEventAtDateSegue",
            let createEventTVC = segue.destination as? CreateEventTableViewController {
            createEventTVC.event = valueToPass
            createEventTVC.dateManager = dateManager
            createEventTVC.dateString = navigationItem.title
        }

        if segue.identifier == "createEventAtDateSegue",
            let createEventTVC = segue.destination as? CreateEventTableViewController {
            createEventTVC.dateString = navigationItem.title
        }

    }


}
