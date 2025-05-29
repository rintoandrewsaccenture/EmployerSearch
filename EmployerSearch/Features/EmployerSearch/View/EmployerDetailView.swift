import SwiftUI

struct EmployerDetailView: View {
    let employerId: Int
    let name: String
    let place: String
    let discountPercentage: Int

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(name)
                Spacer()
                Text(String(employerId))
                    .bold()
            }
            HStack {
                Text(place.capitalized)
                    .font(.footnote)
                Spacer()
                Text("\(discountPercentage)%")
                    .bold()
                    .font(.footnote)
            }
        }
        .padding(.vertical, 8)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(.green.opacity(0.2))
        )
    }
}
