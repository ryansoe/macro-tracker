import Foundation

class HistoryManager: ObservableObject {
    @Published var historyEntries: [MacroEntry] = []

    private let historyKey = "macroHistory"

    init() {
        loadHistory()
    }

    // Save a new entry
    func saveEntry(carbs: Double, protein: Double, fat: Double, totalCalories: Double) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: Date())

        let newEntry = MacroEntry(date: dateString, carbs: carbs, protein: protein, fat: fat, totalCalories: totalCalories)
        historyEntries.append(newEntry)
        saveHistory()
    }

    // Save history to UserDefaults
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(historyEntries) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }

    // Load history from UserDefaults
    private func loadHistory() {
        if let savedData = UserDefaults.standard.data(forKey: historyKey),
           let decodedData = try? JSONDecoder().decode([MacroEntry].self, from: savedData) {
            historyEntries = decodedData
        }
    }

    // Delete an entry
    func deleteEntry(at offsets: IndexSet) {
        historyEntries.remove(atOffsets: offsets)
        saveHistory()
    }

    // Clear all history
    func clearHistory() {
        historyEntries.removeAll()
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
}
