import SwiftUI

struct CalculatorView: View {
    @Bindable var viewModel: CalculatorViewModel
    @Bindable var appState: AppState

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
                    viewModel.evaluate()
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

            Spacer()

            HStack {
                Button("Calculate") {
                    viewModel.evaluate()
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
}
