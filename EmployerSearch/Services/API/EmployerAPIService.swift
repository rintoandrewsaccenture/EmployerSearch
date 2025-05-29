import Foundation

protocol EmployerRepositoryProtocol {
    func searchEmployers(query: String) async throws -> [Employer]
}

final class EmployerRepository: EmployerRepositoryProtocol {

    var httpService: HttpServiceProtocol

    init(httpService: HttpServiceProtocol = HttpService()) {
        self.httpService = httpService
    }

    func searchEmployers(query: String) async throws -> [Employer] {
        let request = EmployerRequest(filter: query, maxRows: 100).urlRequest()
        let employers: [Employer] = try await httpService.sendRequest(request)
        return employers
    }
}
