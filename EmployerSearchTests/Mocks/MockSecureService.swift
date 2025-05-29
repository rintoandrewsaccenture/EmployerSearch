import Foundation
@testable import EmployerSearch

final class MockSecureStorage: SecureStorageProtocol {
    var lastEncryptedData: Data?

    func encrypt(_ data: Data) throws -> Data {
        lastEncryptedData = data
        return data // return unencrypted for test simplicity
    }

    func decrypt(_ data: Data) throws -> Data {
        return data // assume decrypted successfully
    }
}
