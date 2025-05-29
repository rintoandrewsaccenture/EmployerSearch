import Foundation
@testable import EmployerSearch

final class MockEmployerCache: EmployerCacheProtocol {
    var storage: [String: [Employer]] = [:]
    
    func save(_ employers: [Employer], for query: String) {
        storage[query] = employers
    }

    func load(for query: String) -> [Employer]? {
        return storage[query]
    }
}

