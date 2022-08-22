//
//  CreatedVC.swift
//  PartyHub
//
//  Created by juliemoorled on 21.08.2022.
//

import UIKit
import PinLayout

final class CreatedEventsVC: UIViewController {

    var createdEvents: Int = 5 // count created events

    private let tableView = UITableView()
    private var adapter: ProfileTableViewAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        self.adapter = ProfileTableViewAdapter(tableView: self.tableView, eventsNumber: createdEvents)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin
            .top(40)
            .left()
            .right()
            .bottom()
    }

}
