import Foundation
import Observation

struct HistoryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let input: String
    let normalizedExpression: String
    let result: String
    let timestamp: Date

    init(id: UUID = UUID(), input: String, normalizedExpression: String, result: String, timestamp: Date = Date()) {
        self.id = id
        self.input = input
        self.normalizedExpression = normalizedExpression
        self.result = result
        self.timestamp = timestamp
    }
}

@Observable
final class HistoryStore {
    private(set) var items: [HistoryItem] = []
    private let maxCount = 30
    private let defaultsKey = "com.example.TextCalcMenuBar.history"

    init() {
        load()
    }

    func add(input: String, normalizedExpression: String, result: String) {
        let item = HistoryItem(input: input, normalizedExpression: normalizedExpression, result: result)
        items.insert(item, at: 0)
        if items.count > maxCount {
            items = Array(items.prefix(maxCount))
        }
        save()
    }

    func remove(id: UUID) {
        items.removeAll { $0.id == id }
        save()
    }

    func clear() {
        items.removeAll()
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else {
            return
        }
        UserDefaults.standard.set(data, forKey: defaultsKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let loaded = try? JSONDecoder().decode([HistoryItem].self, from: data) else {
            return
        }
        items = loaded
    }
}