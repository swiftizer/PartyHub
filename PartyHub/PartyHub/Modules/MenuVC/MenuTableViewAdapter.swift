//
//  MenuTableViewAdapter.swift
//  PartyHub
//
//  Created by juliemoorled on 17.08.2022.
//

import UIKit

final class MenuTableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

    enum Navigation {
        case addEvent
        case description
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private struct Cells {
        static let addCell = "AddTableViewCell"
        static let menuCell = "MenuTableViewCell"
    }

    private var menuCellCount = 5 // count events
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

    // MARK: - TableView functions

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            navigation?(.addEvent)
        default:
            navigation?(.description)
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
            return menuCellCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: Cells.addCell,
                                                 for: indexPath) as? AddTableViewCell ?? .init()
        } else {
            return tableView.dequeueReusableCell(withIdentifier: Cells.menuCell,
                                                 for: indexPath) as? MenuTableViewCell ?? .init()
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
