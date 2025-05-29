import XCTest
@testable import EmployerSearch

final class DefaultKeychainServiceTests: XCTestCase {

    var keychainService: KeychainService!

    override func setUp() {
        super.setUp()
        keychainService = KeychainService()
    }

    override func tearDown() {
        keychainService = nil
        super.tearDown()
    }

    func testSaveAndLoadKeyData() throws {
        let originalData = "TestEncryptionKey123".data(using: .utf8)!

        try keychainService.save(keyData: originalData)
        let loadedData = keychainService.loadKeyData()

        XCTAssertNotNil(loadedData, "Loaded data should not be nil")
        XCTAssertEqual(loadedData, originalData, "Loaded data should match saved data")
    }
}
