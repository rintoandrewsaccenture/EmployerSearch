import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = AppCoordinator()

    var body: some View {
        NavigationView {
            switch coordinator.currentRoute {
            case .main:
                let secureStorage = SecureStorage(keychainService: KeychainService())
                let cache = EmployerCache(secureStorage: secureStorage)
                let employerAPI = EmployerRepository()
                let viewModel = EmployerSearchViewModel(api: employerAPI, cache: cache)
                EmployerSearchView(viewModel: viewModel)
            case .details(let employerId):
                EmptyView()
            }
        }
    }
}
