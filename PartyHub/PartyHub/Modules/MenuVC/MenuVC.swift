//
//  ViewController.swift
//  PartyHub
//
//  Created by Сергей Николаев on 09.08.2022.
//

import UIKit

class MenuVC: UIViewController {

//    var adapter: MenuTableViewAdapter

    enum Navigation {
        case addEvent
        case description
    }

    var navigation: ((Navigation) -> Void)?

    let adapter: MenuTableViewAdapter
    // MARK: - Private Properties

//    private struct Cells {
//        static let addCell = "AddTableViewCell"
//        static let menuCell = "MenuTableViewCell"
//    }
//
//    private var menuCellCount = 5 // count events
//    private let addCellCount = 1
//    private let addCellHeight: CGFloat = 80
//    private let menuCellHeight: CGFloat = 150

    // MARK: - Private properties

    private let menuTableView = UITableView()

    // MARK: - Initialization

    init() {
        self.adapter = MenuTableViewAdapter(tableView: menuTableView)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(menuTableView)
//        setUpTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuTableView.pin
            .all()
    }

    // MARK: - Private methods

//    private func setUpTableView() {
//        menuTableView.backgroundColor = .systemGray6
//        menuTableView.separatorStyle = .none
//        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: Cells.menuCell)
//        menuTableView.register(AddTableViewCell.self, forCellReuseIdentifier: Cells.addCell)
//        menuTableView.delegate = self
//        menuTableView.dataSource = self
//    }
}

//extension MenuVC: UITableViewDataSource, UITableViewDelegate {
//    // MARK: - TableView functions
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            print(1)
//            navigation?(.addEvent)
//        default:
//            print(2)
//            navigation?(.description)
//        }
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//       return 2
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return addCellHeight
//        } else {
//            return menuCellHeight
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return addCellCount
//        } else {
//            return menuCellCount
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            return tableView.dequeueReusableCell(withIdentifier: Cells.addCell,
//                                                 for: indexPath) as? AddTableViewCell ?? .init()
//        } else {
//            return tableView.dequeueReusableCell(withIdentifier: Cells.menuCell,
//                                                 for: indexPath) as? MenuTableViewCell ?? .init()
//        }
//    }
//}
