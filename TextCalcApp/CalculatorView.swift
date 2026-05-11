import SwiftUI

struct CalculatorView: View {
    @Bindable var viewModel: CalculatorViewModel
    @Bindable var appState: AppState
    var history: HistoryStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TextCalc")
                .font(.title3.weight(.semibold))
                .accessibilityIdentifier("appTitle")

            Text(appState.hotkeyStatus)
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("hotkeyStatus")

            TextField("输入表达式或自然语言计算", text: $viewModel.input)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("inputField")
                .onSubmit {
                    if let calculation = viewModel.evaluate() {
                        history.add(input: viewModel.input, normalizedExpression: calculation.normalizedExpression, result: calculation.displayText)
                    }
                }

            if let preview = viewModel.preview {
                Text("Preview: \(preview)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("previewText")
            }

            if let result = viewModel.result {
                Text(result)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .accessibilityIdentifier("resultText")
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("errorText")
            }

            historySection

            Spacer()

            HStack {
                Button("Calculate") {
                    if let calculation = viewModel.evaluate() {
                        history.add(input: viewModel.input, normalizedExpression: calculation.normalizedExpression, result: calculation.displayText)
                    }
                }
                .accessibilityIdentifier("calculateButton")

                Button("Copy") {
                    viewModel.copyLatestResult()
                }
                .accessibilityIdentifier("copyButton")
                .disabled(viewModel.result == nil)
            }
        }
    }

    private func copyToPasteboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    @ViewBuilder
    private var historySection: some View {
        let items = history.items

        if items.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 4) {
                Text("History")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            HStack(alignment: .center, spacing: 4) {
                                Text(item.input)
                                    .font(.caption)
                                    .lineLimit(1)

                                Text("= \(item.result)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.blue)

                                Spacer()

                                Button {
                                    copyToPasteboard(item.input)
                                } label: {
                                    Image(systemName: "doc.circle")
                                        .font(.caption)
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.secondary)
                                .help("Copy expression")

                                Button {
                                    copyToPasteboard(item.result)
                                } label: {
                                    Image(systemName: "equal.circle")
                                        .font(.caption)
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.blue)
                                .help("Copy result")

                                Button {
                                    history.remove(id: item.id)
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .font(.caption)
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.red)
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                }
                .frame(maxHeight: 180)
            }
        }
    }
}