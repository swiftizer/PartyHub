//
//  FavouritesVC.swift
//  PartyHub
//
//  Created by juliemoorled on 21.08.2022.
//

import UIKit
import PinLayout

final class FavoriteEventsVC: UIViewController {

    var favoriteEvents: Int = 3 // count created events

    private let tableView = UITableView()
    private var adapter: ProfileTableViewAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        self.adapter = ProfileTableViewAdapter(tableView: self.tableView, eventsNumber: favoriteEvents)
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
