import Foundation
@testable import EmployerSearch

final class MockEmployerRepository: EmployerRepositoryProtocol {
    var shouldThrow = false
    var mockResults: [Employer] = []

    func searchEmployers(query: String) async throws -> [Employer] {
        if shouldThrow {
            throw URLError(.notConnectedToInternet)
        }
        return mockResults
    }
}

