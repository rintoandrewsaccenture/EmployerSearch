import CryptoKit
import Foundation

protocol SecureStorageProtocol {
    func encrypt(_ data: Data) throws -> Data
    func decrypt(_ data: Data) throws -> Data
}

final class SecureStorage: SecureStorageProtocol {
    private let key: SymmetricKey
    private let keychainService: KeychainServiceProtocol

    init?(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService

        if let keyData = keychainService.loadKeyData() {
            self.key = SymmetricKey(data: keyData)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            do {
                try keychainService.save(keyData: newKey.withUnsafeBytes { Data($0) })
            } catch {
                return nil
            }
            self.key = newKey
        }
    }

    func encrypt(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        guard let combined = sealedBox.combined else {
            throw NSError(domain: "EncryptionFailed", code: -1)
        }
        return combined
    }

    func decrypt(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
