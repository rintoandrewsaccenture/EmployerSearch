import SwiftUI

struct EmployerSearchView: View {
    @ObservedObject private var viewModel: EmployerSearchViewModel

    init(viewModel: EmployerSearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            userInputView
            switch viewModel.state {
            case .idle:
                idleView
            case .loading:
                loadingView
            case .loaded:
                loadedView
            case .failed(let string):
                failedView(string)
            }
        }
        .background(Color.gray.opacity(0.1))
    }

    private var userInputView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                TextField("Search employers", text: $viewModel.query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocorrectionDisabled()

                Button("Search") {
                    Task {
                        await viewModel.search()
                    }
                }
                .disabled(viewModel.query.isEmpty)
            }
            .padding(.horizontal, 16)
        }
    }

    private var idleView: some View {
        VStack {
            Spacer()
            Text("Enter a query and tap Search")
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Fetching...")
                .padding()
            Spacer()
        }
    }

    private func failedView(_ error: String) -> some View {
        VStack {
            Spacer()
            Text(error)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }

    @ViewBuilder
    private var loadedView: some View {
        if viewModel.employers.isEmpty {
            VStack {
                Spacer()
                Text("No employers found.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.employers) { employer in
                        EmployerDetailView(employerId: employer.employerId,
                                           name: employer.name,
                                           place: employer.place,
                                           discountPercentage: employer.discountPercentage)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

