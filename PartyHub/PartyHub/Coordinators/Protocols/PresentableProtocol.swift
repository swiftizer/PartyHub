//
//  PresentableProtocol.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

protocol PresentableProtocol: AnyObject {
    func start(_ viewController: UIViewController) -> UINavigationController
}
