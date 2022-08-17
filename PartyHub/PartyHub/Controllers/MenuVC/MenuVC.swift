//
//  ViewController.swift
//  PartyHub
//
//  Created by Сергей Николаев on 09.08.2022.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Private properties

    private struct Cells {
        static let addCell = "AddTableViewCell"
        static let menuCell = "MenuTableViewCell"
    }

    private let menuTableView = UITableView()

    private let addCellHeight: CGFloat = 80
    private let menuCellHeight: CGFloat = 150

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuTableView.pin
            .all()

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
            return 1
        } else {
            return 5
            // count events
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
        view.addSubview(menuTableView)
        menuTableView.backgroundColor = .systemGray6
        menuTableView.separatorStyle = .none
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: Cells.menuCell)
        menuTableView.register(AddTableViewCell.self, forCellReuseIdentifier: Cells.addCell)
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }

}
