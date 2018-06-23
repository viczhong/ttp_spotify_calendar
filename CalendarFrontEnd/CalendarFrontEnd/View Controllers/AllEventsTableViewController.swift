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

    var valueToPass: Event?

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)

        self.tableView.register(nib, forCellReuseIdentifier: "eventCell")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        dateManager = appDelegate.dateManager

        events = dateManager.eventsArray
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        valueToPass = sortedEvents[indexPath.row]
        performSegue(withIdentifier: "editEventSegue", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEventSegue", let createEventTVC = segue.destination as? CreateEventTableViewController {
            createEventTVC.dateManager = dateManager
            createEventTVC.delegate = self
        }

        if segue.identifier == "editEventSegue",
            let createEventTVC = segue.destination as? CreateEventTableViewController {
            createEventTVC.dateManager = dateManager
            createEventTVC.event = valueToPass
            createEventTVC.delegate = self

            if let value = valueToPass {
                createEventTVC.dateString = dateManager.dateStringToTimeStrings(value.dateTimeString)?.0
            }
        }
    }

}

extension AllEventsTableViewController: CreateEventTableViewControllerDelegate {
    func createdEvent(_ event: Event) {
        dateManager.eventsArray.append(event)
        navigationController?.popViewController(animated: true)
        events = dateManager.eventsArray
    }

    func needsRefresh() {
        navigationController?.popViewController(animated: true)

        dateManager.getEvents { [weak self] (_, events) in
            DispatchQueue.main.async {
                if let events = events {
                    self?.events = events
                }
            }
        }
    }
}
