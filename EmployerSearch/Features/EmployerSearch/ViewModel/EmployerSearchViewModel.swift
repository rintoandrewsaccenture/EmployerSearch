import SwiftUI

final class EmployerSearchViewModel: ObservableObject {

    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published var state: LoadingState = .idle
    @Published var query: String = ""
    @Published var employers: [Employer] = []

    private let api: EmployerRepositoryProtocol
    private let cache: EmployerCacheProtocol?

    init(api: EmployerRepositoryProtocol = EmployerRepository(), cache: EmployerCacheProtocol?) {
        self.api = api
        self.cache = cache
    }

    @MainActor
    func search() async {
        state = .loading

        if let cached = cache?.load(for: query) {
            self.employers = cached
            state = .loaded
            return
        }

        do {
            employers = try await api.searchEmployers(query: query)
            if !employers.isEmpty {
                cache?.save(employers, for: query)
            }
            state = .loaded
        } catch {
            state = .failed("Error fetching employers: \(error.localizedDescription)")
        }
    }
}


