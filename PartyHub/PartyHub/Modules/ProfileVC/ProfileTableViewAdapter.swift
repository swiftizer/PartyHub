//
//  ProfileTableViewAdapter.swift
//  CellTest
//
//  Created by juliemoorled on 21.08.2022.
//

import UIKit
import PinLayout

final class ProfileTableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Private Properties

    private struct Cells {
        static let menuCell = "MenuTableViewCell"
    }

    private var tableView = UITableView()
    private var eventsNumber: Int = 0 // count  events
    private let menuCellHeight: CGFloat = 150

    // MARK: - Initialization

    init(tableView: UITableView, eventsNumber: Int) {
        self.tableView = tableView
        self.eventsNumber = eventsNumber
        super.init()
        setUpTableView()
    }

    // MARK: - TableView functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsNumber
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return menuCellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Cells.menuCell,
                                                         for: indexPath) as? MenuTableViewCell ?? .init()
    }

    // MARK: - Private methods

    private func setUpTableView() {
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: Cells.menuCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
