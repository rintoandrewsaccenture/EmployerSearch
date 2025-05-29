import XCTest
@testable import EmployerSearch

final class EmployerCacheTests: XCTestCase {
    var cache: EmployerCache!
    var mockStorage: MockSecureStorage!

    override func setUp() {
        super.setUp()
        mockStorage = MockSecureStorage()
        cache = EmployerCache(secureStorage: mockStorage)
    }

    override func tearDown() {
        cache = nil
        mockStorage = nil
        super.tearDown()
    }

    func testSaveAndLoadEmployers() {
        let employers = [
            Employer(employerId: 1, name: "Company A", place: "NY", discountPercentage: 10),
            Employer(employerId: 2, name: "Company B", place: "LA", discountPercentage: 15)
        ]

        let query = "marketing"
        cache.save(employers, for: query)
        let loaded = cache.load(for: query)

        XCTAssertEqual(loaded?.count, employers.count)
        XCTAssertEqual(loaded?.first?.name, "Company A")
    }

    func testSaveWritesEncryptedData() {
        let employers = [Employer(employerId: 3, name: "Secure Inc.", place: "TX", discountPercentage: 5)]
        cache.save(employers, for: "security_check")

        XCTAssertNotNil(mockStorage.lastEncryptedData, "Data should be encrypted before saving")
    }
}

