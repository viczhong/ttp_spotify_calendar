//
//  CalendarViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/16/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    var dateManager: DateManager!
    var dateArray = [DateEntry]() {
        didSet {
            collectionView.reloadData()
        }
    }

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        dateManager = DateManager(datePicker.date) { [weak self] dateArray in
            self?.dateArray = dateArray
        }

        collectionView.delegate = self
        collectionView.dataSource = self

        navigationItem.title = dateManager.getHeaderString()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            dateManager.rotated(.landscape) { [unowned self] in
                self.dateManager.setUpMonth(self.datePicker.date, { dateArray in
                    self.dateArray = dateArray
//                    self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                })

            }
        } else {
            dateManager.rotated(.portrait) { [unowned self] in
                self.dateManager.setUpMonth(self.datePicker.date, { dateArray in
                    self.dateArray = dateArray
//                    self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                })
            }
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
        cell.dateLabel.text = dateAtCell.dateString
        cell.eventLabel.text = ""

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


