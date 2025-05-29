import SwiftUI

enum AppRoute {
    case main
    case details(employerId: Int)
}

class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .main

    func navigate(to route: AppRoute) {
        currentRoute = route
    }

    func goBack() {
        currentRoute = .main
    }
}
