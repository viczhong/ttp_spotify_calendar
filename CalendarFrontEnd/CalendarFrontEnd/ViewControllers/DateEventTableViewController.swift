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
    var valueToPass: Event?
    var dateManager: DateManager!
    var events: [Event]? {
        didSet {
            sortedEvents = events!.sorted { $0.dateTimeString < $1.dateTimeString }
        }
    }
    
    var sortedEvents = [Event]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "eventCell")
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell

        let event = sortedEvents[indexPath.row]
        cell.timeLabel.text = "\(event.startTime) - \(event.endTime)"
        cell.eventLabel.text = event.title

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dateManager.delete(sortedEvents[indexPath.row]) { [weak self] (data) in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            let events = try JSONDecoder().decode([Event].self, from: data)
                            self?.events = events
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        valueToPass = sortedEvents[indexPath.row]
        performSegue(withIdentifier: "editEventAtDateSegue", sender: self)
    }

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
            createEventTVC.dateManager = dateManager
            createEventTVC.dateString = navigationItem.title
        }
    }

}
