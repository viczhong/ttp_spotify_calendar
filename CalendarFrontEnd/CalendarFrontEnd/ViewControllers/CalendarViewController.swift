//
//  CalendarViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/16/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!

    var dateManager: DateManager!
    var dateArray = [DateEntry]() {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateManager = DateManager(datePicker.date) { [weak self] dateArray in
            self?.dateArray = dateArray
        }

        collectionView.delegate = self
        collectionView.dataSource = self

        navigationItem.title = dateManager.getHeaderString()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dateManager.setUpMonth(datePicker.date, { [weak self] dateArray in
            self?.dateArray = dateArray
        })
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        var rotation: ScreenRotation

        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            rotation = .landscape
        } else {
           rotation = .portrait
        }

        dateManager.rotated(rotation) { [weak self] in
            guard let date = self?.datePicker.date else { return }
            self?.dateManager.setUpMonth(date, { dateArray in
                self?.dateArray = dateArray
            })
        }

        flowLayout.invalidateLayout()
    }

    @IBAction func datePickerDateChanged(_ sender: Any) {
        dateManager.setUpMonth(datePicker.date) {[weak self] dateArray in
            self?.dateArray = dateArray

            DispatchQueue.main.async {
                self?.navigationItem.title = self?.dateManager.getHeaderString()
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Collection View Extensions
extension CalendarViewController: UICollectionViewDelegate {}

extension CalendarViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
        let dateAtCell = dateArray[indexPath.row]

        cell.dateLabel.textColor = .black
        cell.eventLabel.text = ""
        cell.dateLabel.text = dateAtCell.dateString

        if dateManager.screenRotation == .landscape, let events = dateAtCell.eventString {
            cell.eventLabel.text = events
        }

        if dateAtCell.placeholder {
            cell.dateLabel.textColor = .gray
            cell.eventLabel.text = ""
        }

        cell.layer.borderWidth = 1

        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthPerItem = view.frame.width / 7

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}


