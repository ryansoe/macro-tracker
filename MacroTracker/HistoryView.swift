import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyManager: HistoryManager
    
    @State private var showClearHistoryConfirmation = false

    var body: some View {
        NavigationView {
            VStack {
                if historyManager.historyEntries.isEmpty {
                    Text("No history available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(historyManager.historyEntries) { entry in
                            VStack(alignment: .leading) {
                                Text(entry.date)
                                    .font(.headline)
                                    .padding(.bottom, 2)
                                Text("Carbs: \(String(format: "%.1f", entry.carbs))g")
                                Text("Protein: \(String(format: "%.1f", entry.protein))g")
                                Text("Fat: \(String(format: "%.1f", entry.fat))g")
                                Text("Total Calories: \(String(format: "%.1f", entry.totalCalories)) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: historyManager.deleteEntry)
                    }
                }

                // Clear History Button
                Button("Clear History") {
                    showClearHistoryConfirmation = true
                }
                .buttonStyle(.bordered)
                .padding()
                .alert("Confirm Clear History", isPresented: $showClearHistoryConfirmation) {
                    Button("Confirm", role: .destructive) {
                        historyManager.clearHistory()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete all saved history? This action cannot be undone.")
                }            }
            .navigationTitle("History")
        }
    }
}
