//
//  ViewController.swift
//  PartyHub
//
//  Created by Сергей Николаев on 09.08.2022.
//

import UIKit

class MenuVC: UIViewController {

    // MARK: - Private properties

    private var adapter: MenuTableViewAdapter!
    private let menuTableView = UITableView()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(menuTableView)
        self.adapter = MenuTableViewAdapter(tableView: self.menuTableView, viewController: self)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuTableView.pin
            .all()

    }

}
