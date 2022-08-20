//
//  MenuTableViewAdapter.swift
//  PartyHub
//
//  Created by juliemoorled on 17.08.2022.
//

import UIKit

final class MenuTableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Private properties

    private struct Cells {
        static let addCell = "AddTableViewCell"
        static let menuCell = "MenuTableViewCell"
    }

    private var menuCellCount = 5 // count events
    private let addCellCount = 1
    private let addCellHeight: CGFloat = 80
    private let menuCellHeight: CGFloat = 150
    private let menuTableView: UITableView
    private let currentVC: UIViewController

    // MARK: - Initialization

    init(tableView: UITableView, viewController: UIViewController) {
        self.menuTableView = tableView
        currentVC = viewController
        super.init()
        setUpTableView()
    }

    // MARK: - TableView functions

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // TODO: - Open AddEventVC (делает Сережа)
        } else {
            openEvent()
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

    // TODO: - Вынести во ViewModel
    
    private func openEvent() {
        let eventVC = EventVC()
        currentVC.navigationController?.pushViewController(eventVC, animated: true)
    }

}
