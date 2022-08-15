//
//  CoordinatorProtocol.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

// MARK: - Coordinator

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    // Каждому координатору назначен один навигационный контроллер
    var navigationController: UINavigationController { get set }
    // Массив для отслеживания всех дочерних координаторов.
    // Большую часть времени этот массив будет содержать только один дочерний координатор
    var childCoordinators: [Coordinator] { get set }
    // Определяет тип flow
    var type: CoordinatorType { get }
    // Место для размещения логики для запуска flow
    func start()
    // Место для размещения логики для завершения flow,
    // очистки всех дочерних координаторов и уведомления родителя о том, что этот координатор готов к освобождению
    func finish()

    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

// MARK: - CoordinatorOutput

/// Протокол делегирования, помогающий координатору родителей узнать, когда его дочерний элемент готов к завершению.
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)

}

// MARK: - CoordinatorType

/// Используя эту структуру, мы можем определить, какой тип flow мы будем использовать в приложении.
enum CoordinatorType {
    case app, login, tab, menu, map, profile
}
