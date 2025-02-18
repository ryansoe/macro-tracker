import SwiftUI

struct SetGoalsView: View {
    // State variables for goal values, loaded from UserDefaults
    @State private var goalCarbs: String = UserDefaults.standard.string(forKey: "goalCarbs") ?? "150"
    @State private var goalProtein: String = UserDefaults.standard.string(forKey: "goalProtein") ?? "120"
    @State private var goalFat: String = UserDefaults.standard.string(forKey: "goalFat") ?? "70"

    // Used to dismiss the view when saving
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Set Your Daily Macro Goals")
                .font(.headline)
                .padding()

            // Text fields for goal input
            TextField("Carbs Goal (g)", text: $goalCarbs)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            TextField("Protein Goal (g)", text: $goalProtein)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            TextField("Fat Goal (g)", text: $goalFat)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            // Save & Cancel buttons
            HStack {
                Button("Save Goals") {
                    saveGoals()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)

                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .padding()
    }

    // Function to save goal values to UserDefaults
    private func saveGoals() {
        UserDefaults.standard.set(goalCarbs, forKey: "goalCarbs")
        UserDefaults.standard.set(goalProtein, forKey: "goalProtein")
        UserDefaults.standard.set(goalFat, forKey: "goalFat")
    }
}
