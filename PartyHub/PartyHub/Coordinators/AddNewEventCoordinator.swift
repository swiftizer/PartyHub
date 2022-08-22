//
//  AddNewEventCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 22.08.2022.
//

import UIKit

final class AddNewEventCoordinator: Coordinator {
    var result: ((FlowResult<Void>) -> Void)?
    let router = DefaultRouter(with: nil)
    private let rootModule = AddNewEventVC()

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        router.toPresent().modalPresentationStyle = .overFullScreen
        start()
    }

    func start() {
        rootModule.title = "Создать мероприятие"
        rootModule.navigation = { [weak self] navType in
            switch navType {
            case .registration:
                self?.result?(.success(Void()))
            case .back:
                self?.result?(.canceled)
            case .choosePlace:
                self?.presentChoosePlace()
            }
        }
        router.setRootModule(rootModule)
    }

    func presentChoosePlace() {
        let module = MapToChooseVC()
        module.title = "Карта"
        module.navigation = { [weak self] result in
            switch result {
            case.enter(gePoint: let geoPoint):
                self?.rootModule.choosedPoint = geoPoint
                self?.rootModule.updateAdress()
                self?.router.popModule(animated: true)
            case .back:
                break
            }
        }
        router.push(module, animated: true)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }

}
