import Foundation

enum HttpError: Error, Equatable {
    case unsuccessfulHttpStatus(Int)
    case unexpectedResponseType
    case networkError
}

struct DecodeError: Error {
    public var failedType: String
    public var error: Error
}

protocol HttpServiceProtocol {
    func sendDataRequest(_ urlRequest: URLRequest) async throws -> Data
    func sendRequest<T: Decodable>(_ urlRequest: URLRequest) async throws -> T
}

extension HttpServiceProtocol {
    func sendRequest<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        let data = try await self.sendDataRequest(urlRequest)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw DecodeError(failedType: String(describing: T.self), error: error)
        }
    }
}

final class HttpService: HttpServiceProtocol {

    lazy var urlSession = URLSession(configuration: .default)

    func sendDataRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, httpResponse) = try await self.networkRequest(urlRequest)
        try validate(httpResponse)
        return data
    }

    private func networkRequest(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, urlResponse): (Data, URLResponse)
        do {
            (data, urlResponse) = try await self.urlSession.data(for: urlRequest)
        } catch {
            throw HttpError.networkError
        }

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw HttpError.unexpectedResponseType
        }
        return (data, httpResponse)
    }

    func validate(_ httpResponse: HTTPURLResponse) throws {
        switch httpResponse.statusCode {
        case 200...299:
            return
        default:
            throw HttpError.unsuccessfulHttpStatus(httpResponse.statusCode)
        }
    }
}

