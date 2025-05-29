import XCTest
@testable import EmployerSearch

final class SecureStorageTests: XCTestCase {

    var keychainService: MockKeychainService!
    var secureStorage: SecureStorage!

    override func setUp() {
        keychainService = MockKeychainService()
        secureStorage = SecureStorage(keychainService: keychainService)
    }

    override func tearDown() {
        keychainService = nil
        secureStorage = nil
    }

    func testEncryptAndDecrypt() throws {
        let originalText = "Hello Secure World!"
        let originalData = originalText.data(using: .utf8)!

        let encryptedData = try secureStorage.encrypt(originalData)
        XCTAssertNotEqual(encryptedData, originalData, "Encrypted data should differ from original")

        let decryptedData = try secureStorage.decrypt(encryptedData)
        XCTAssertEqual(decryptedData, originalData, "Decrypted data should match original data")

        let decryptedString = String(data: decryptedData, encoding: .utf8)
        XCTAssertEqual(decryptedString, originalText, "Decrypted string should match original")
    }
}


