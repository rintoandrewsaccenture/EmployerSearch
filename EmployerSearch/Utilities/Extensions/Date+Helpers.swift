import Foundation

extension Date {
    func isOlderThan(days: Int, comparedTo referenceDate: Date = Date()) -> Bool {
        guard let thresholdDate = Calendar.current.date(byAdding: .day, value: -days, to: referenceDate) else {
            return false
        }
        return self < thresholdDate
    }

    var isOlderThanOneWeek: Bool {
        isOlderThan(days: 7)
    }
}


