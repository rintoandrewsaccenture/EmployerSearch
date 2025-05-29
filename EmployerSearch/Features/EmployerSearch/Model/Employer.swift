import Foundation

struct Employer: Identifiable, Codable, Equatable {
    var id: Int { employerId }  // For Identifiable
    let employerId: Int
    let name: String
    let place: String
    let discountPercentage: Int

    enum CodingKeys: String, CodingKey {
        case employerId = "EmployerID"
        case name = "Name"
        case place = "Place"
        case discountPercentage = "DiscountPercentage"
    }
}


