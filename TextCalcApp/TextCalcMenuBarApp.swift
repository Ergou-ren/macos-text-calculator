import SwiftUI
import TextCalcCore

@main
struct TextCalcMenuBarApp: App {
    @State private var viewModel = CalculatorViewModel()
    @State private var appState = AppState()
    private let isUITesting = ProcessInfo.processInfo.arguments.contains("-ui-testing")

    var body: some Scene {
        MenuBarExtra("TextCalc", systemImage: "sum") {
            CalculatorView(viewModel: viewModel, appState: appState)
                .frame(width: 360, height: 240)
                .padding(16)
                .onAppear {
                    appState.bootstrapIfNeeded(isUITesting: isUITesting)
                }
        }
        .menuBarExtraStyle(.window)
    }
}
