import Foundation
@testable import EmployerSearch

final class MockKeychainService: KeychainServiceProtocol {
    private var storage: Data?

    func save(keyData: Data) throws {
        storage = keyData
    }

    func loadKeyData() -> Data? {
        return storage
    }
}

