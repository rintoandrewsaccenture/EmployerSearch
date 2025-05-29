import XCTest
@testable import EmployerSearch

@MainActor
final class EmployerSearchViewModelTests: XCTestCase {

    var mockAPI: MockEmployerRepository!
    var mockCache: MockEmployerCache!
    var viewModel: EmployerSearchViewModel!

    override func setUp() {
        super.setUp()
        let secureStorage = SecureStorage(keychainService: MockKeychainService())
        mockCache = MockEmployerCache(secureStorage: secureStorage)
        mockAPI = MockEmployerRepository()
        viewModel = EmployerSearchViewModel(api: mockAPI, cache: mockCache)
    }

    override func tearDown() {
        mockAPI = nil
        mockCache = nil
        viewModel = nil
    }

    func test_search_usesCacheIfAvailable() async {
        let employer = Employer(
            employerId: 78219,
            name: "6-Voud Label+ Enschede",
            place: "ENSCHEDE",
            discountPercentage: 8)

        mockCache?.save([employer], for: "Enschede")
        viewModel.query = "Enschede"

        await viewModel.search()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.employers, [employer])
    }

    func test_search_fetchesFromAPIAndSavesToCache() async {
        let employer = Employer(
            employerId: 78219,
            name: "6-Voud Label+ Enschede",
            place: "ENSCHEDE",
            discountPercentage: 8)

        mockAPI.mockResults = [employer]
        let viewModel = EmployerSearchViewModel(api: mockAPI, cache: mockCache)

        viewModel.query = "Enschede"

        await viewModel.search()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.employers, [employer])
        XCTAssertEqual(mockCache?.storage["Enschede"], [employer])
    }

    func test_search_handlesAPIFailure() async {
        mockAPI.shouldThrow = true
        viewModel.query = "fail"

        await viewModel.search()

        if case .failed(let message) = viewModel.state {
            XCTAssertTrue(message.contains("Error fetching employers"))
        } else {
            XCTFail("Expected state to be .failed, got \(viewModel.state)")
        }

        XCTAssertTrue(viewModel.employers.isEmpty)
    }
}





