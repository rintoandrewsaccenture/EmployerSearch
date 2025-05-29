import Foundation

let hostname = "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest"

struct EmployerRequest {

    var filter: String
    var maxRows: Int = 100

    func urlRequest() -> URLRequest {
        let path = "employers?filter=\(filter)&maxRows=\(maxRows)"
        let url = URL(string: "\(hostname)/\(path)")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
