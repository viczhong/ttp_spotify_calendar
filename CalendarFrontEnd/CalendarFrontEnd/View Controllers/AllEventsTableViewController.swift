//
//  AllEventsTableViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/18/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class AllEventsTableViewController: UITableViewController {

    var dateManager: DateManager!
    var events = [Event]() {
        didSet {
            sortedEvents = events.sorted { $0.dateTimeString < $1.dateTimeString}
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

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        dateManager = appDelegate.dateManager

        dateManager.getEvents { [weak self] (_, events) in
            DispatchQueue.main.async {
                if let events = events {
                    self?.events = events
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

//        dateManager.getEvents { [weak self] (_, events) in
//            DispatchQueue.main.async {
//                if let events = events {
//                    self?.events = events
//                }
//            }
//        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell

        let event = sortedEvents[indexPath.row]

        let dateString = dateManager.dateStringToTimeStrings(event.dateTimeString)!.0 
        
        cell.timeLabel.text = "\(dateString): \(event.startTime) - \(event.endTime)"
        cell.eventLabel.text = event.title

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dateManager.delete(sortedEvents[indexPath.row], nil) { [weak self] (events) in
                DispatchQueue.main.async {
                    self?.events = events
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEventSegue", let createEventTVC = segue.destination as? CreateEventTableViewController {
            createEventTVC.dateManager = dateManager
            createEventTVC.delegate = self
        }
    }

}

extension AllEventsTableViewController: EventManipulationDelegate {
    func createdEvent(_ event: Event) {
        self.dateManager.eventsArray.append(event)
        self.navigationController?.popViewController(animated: true)
        self.events = self.dateManager.eventsArray
    }


}