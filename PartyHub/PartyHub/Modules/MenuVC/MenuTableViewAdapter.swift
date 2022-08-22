//
//  MenuTableViewAdapter.swift
//  PartyHub
//
//  Created by juliemoorled on 17.08.2022.
//

import UIKit
import CoreLocation

final class MenuTableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

    enum Navigation {
        case addEvent
        case description(event: Event)
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private struct Cells {
        static let addCell = "AddTableViewCell"
        static let menuCell = "MenuTableViewCell"
    }

    private var events = [Event]()
    private var dictForSort = [String: Int]()
    private var distanses = [Double]()
    private var currentLocation: CLLocation?

    private var menuCellCount = 0 // count events
    private let addCellCount = 1
    private let addCellHeight: CGFloat = 80
    private let menuCellHeight: CGFloat = 150
    private let menuTableView: UITableView

    // MARK: - Initialization

    init(tableView: UITableView) {
        self.menuTableView = tableView
        super.init()
        setUpTableView()
    }

    func relodeCells(events: [Event], location: CLLocation?, distances: [Double]) {
        self.events = events
        self.currentLocation = location
        self.distanses = distances

        menuTableView.reloadData()
    }

    // MARK: - TableView functions

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            navigation?(.addEvent)
        default:
            navigation?(.description(event: events[indexPath.row]))
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return addCellHeight
        } else {
            return menuCellHeight
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addCellCount
        } else {
            return events.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: Cells.addCell,
                                                 for: indexPath) as? AddTableViewCell ?? .init()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.menuCell,
                                                     for: indexPath) as? MenuTableViewCell

            cell?.setUpCell(with: events[indexPath.row], distance: distanses[indexPath.row])
            return cell ?? .init()
        }
    }

    // MARK: - Private methods

    private func setUpTableView() {
        menuTableView.backgroundColor = .systemGray6
        menuTableView.separatorStyle = .none
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: Cells.menuCell)
        menuTableView.register(AddTableViewCell.self, forCellReuseIdentifier: Cells.addCell)
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
}
