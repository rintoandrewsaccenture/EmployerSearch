import SwiftUI

@main
struct EmployerSearchApp: App {
    var body: some Scene {
        WindowGroup {
            let secureStorage = SecureStorage(keychainService: KeychainService())
            let cache = EmployerCache(secureStorage: secureStorage)
            let employerAPI = EmployerRepository()
            let viewModel = EmployerSearchViewModel(api: employerAPI, cache: cache)
            EmployerSearchView(viewModel: viewModel)
        }
    }
}
