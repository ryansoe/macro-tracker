import Foundation

struct MacroEntry: Codable, Identifiable {
    var id = UUID()
    var date: String  // e.g., "Feb 18, 2025"
    var carbs: Double
    var protein: Double
    var fat: Double
    var totalCalories: Double
}
