//
//  TabBarCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

/// Тип страницы TabBar'a
enum TabBarPage {
    case menu
    case map
    case profile

    init?(index: Int) {
        switch index {
        case 0:
            self = .menu
        case 1:
            self = .map
        case 2:
            self = .profile
        default:
            return nil
        }
    }

    func pageTitleValue() -> String {
        switch self {
        case .menu:
            return "Menu"
        case .map:
            return "Map"
        case .profile:
            return "Profile"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .menu:
            return 0
        case .map:
            return 1
        case .profile:
            return 2
        }
    }

    func pageIcon() -> UIImage {
        switch self {
        case .menu:
            return UIImage(systemName: "list.bullet") ?? UIImage.add
        case .map:
            return UIImage(systemName: "map") ?? UIImage.add
        case .profile:
            return UIImage(systemName: "person.circle") ?? UIImage.add
        }
    }
}

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }

    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

final class TabCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }

    func start() {
        let pages: [TabBarPage] = [.menu, .map, .profile]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        prepareTabBarController(withTabControllers: controllers)
    }

    // TODO: - убарать перед финальной частью
    deinit {
        debugPrint("TabCoordinator deinit")
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        // Устанавливаем делегат для TabBarVC
        tabBarController.delegate = self
        // Назначаем контроллеры страницы
        tabBarController.setViewControllers(tabControllers, animated: false)
        // Индексируем
        tabBarController.selectedIndex = TabBarPage.menu.pageOrderNumber()
        // Стилизация
        tabBarController.tabBar.isTranslucent = false
        // На этом этапе мы присоединяем tabBarController к навигационному контроллеру, связанному с этим координатором.
        navigationController.viewControllers = [tabBarController]
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)

        navController.tabBarItem = UITabBarItem(
            title: page.pageTitleValue(),
            image: page.pageIcon(),
            tag: page.pageOrderNumber()
        )

        switch page {
        case .menu:
            // При необходимости: у каждого контролерра панели вкладок может быть свой координатор.
            let menuVC = ViewController()
            menuVC.title = page.pageTitleValue()
            // TODO: - расскомитить когда появится VC

//            menuVC.didSendEventClosure = { [weak self] event in
//                switch event {
//                case .menu:
//                    self?.selectPage(.menu)
//                case .map:
//                    self?.selectPage(.map)
//                case .profile:
//                    self?.selectPage(.profile)
//                }
//            }

            navController.pushViewController(menuVC, animated: true)
        case .map:
            let mapVC = ViewController()
            mapVC.title = page.pageTitleValue()
//            mapVC.didSendEventClosure = { [weak self] event in
//                switch event {
//                case .menu:
//                    self?.selectPage(.menu)
//                case .map:
//                    self?.selectPage(.map)
//                case .profile:
//                    self?.selectPage(.profile)
//                }
//            }

            navController.pushViewController(mapVC, animated: true)
        case .profile:
            let profileVC = ViewController()
            profileVC.title = page.pageTitleValue()
//            profileVC.didSendEventClosure = { [weak self] event in
//                switch event {
//                case .menu:
//                    self?.selectPage(.menu)
//                case .map:
//                    self?.selectPage(.map)
//                case .profile:
//                    self?.selectPage(.profile)
//                }
//            }

            navController.pushViewController(profileVC, animated: true)
        }

        return navController
    }

    func currentPage() -> TabBarPage? {
        TabBarPage(index: tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }

        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
    }
}
