import SwiftUI

struct EmployerSearchView: View {
    @ObservedObject private var viewModel: EmployerSearchViewModel

    init(viewModel: EmployerSearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
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
            .padding(.all, 16)
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

    private var loadedView: some View {
        Group {
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
                            VStack {
                                Text(employer.name).font(.headline)
                                Text(employer.place).font(.headline)
                            }
                        }
                    }
                }
            }
        }
    }
}

