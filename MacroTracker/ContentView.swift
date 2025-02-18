import SwiftUI



struct ContentView: View {
    @AppStorage("dailyCarbs") private var dailyCarbs: Double = 0.0
    @AppStorage("dailyProtein") private var dailyProtein: Double = 0.0
    @AppStorage("dailyFat") private var dailyFat: Double = 0.0

    @State private var inputCarbs: String = ""
    @State private var inputProtein: String = ""
    @State private var inputFat: String = ""
    @State private var isEditing: Bool = false
    @State private var isSettingGoals: Bool = false
    @State private var showSaveConfirmation = false
    @State private var scannedBarcode: String?
    @State private var isScanning: Bool = false
    @State private var scannedCarbs: String = ""
    @State private var scannedProtein: String = ""
    @State private var scannedFat: String = ""
    @State private var showMacroConfirmation: Bool = false
    @State private var servingSize: Double = 1.0 // Default to 1 serving
    @State private var totalGrams: Double = 0.0 // Default to 0 until set
    @State private var isEditingServings: Bool = false
    @State private var isEditingGrams: Bool = false
    @State private var originalCarbs: Double = 0.0
    @State private var originalProtein: Double = 0.0
    @State private var originalFat: Double = 0.0

    @StateObject private var historyManager = HistoryManager()

    var goalCarbs: Double {
        return Double(UserDefaults.standard.string(forKey: "goalCarbs") ?? "100") ?? 100
    }
    var goalProtein: Double {
        return Double(UserDefaults.standard.string(forKey: "goalProtein") ?? "200") ?? 200
    }
    var goalFat: Double {
        return Double(UserDefaults.standard.string(forKey: "goalFat") ?? "60") ?? 60
    }

    var totalCalories: Double {
        (dailyCarbs * 4) + (dailyProtein * 4) + (dailyFat * 9)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                VStack(spacing: 20) {
                    // Macro Progress Bars & Calories Display
                    VStack {
                        Text("Daily Macro Intake").font(.headline)
                        MacroProgressBar(title: "Carbs", value: dailyCarbs, goal: goalCarbs, color: .blue)
                        MacroProgressBar(title: "Protein", value: dailyProtein, goal: goalProtein, color: .green)
                        MacroProgressBar(title: "Fat", value: dailyFat, goal: goalFat, color: .red)
                        Text("Total Calories: \(String(format: "%.1f", totalCalories)) kcal")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 5)
                    }
                    .padding()
                    
                    // Meal Input Fields
                    VStack {
                        TextField("Carbs (g)", text: $inputCarbs)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        TextField("Protein (g)", text: $inputProtein)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        TextField("Fat (g)", text: $inputFat)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        // Add Meal Button
                        Button("Add Meal") {
                            addMeal()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        // Barcode Scanner Button
                        Button("Scan Barcode") {
                            isScanning.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    
                    // Edit & Set Goals Buttons (Side by Side)
                    HStack {
                        Button("Edit") {
                            isEditing.toggle()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Set Goals") {
                            isSettingGoals.toggle()
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    // Save Daily Macros Button
                    Button("Save Daily Macros") {
                        showSaveConfirmation = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                    .alert("Confirm Save", isPresented: $showSaveConfirmation) {
                        Button("Confirm", role: .destructive) {
                            saveDailyMacros()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to save today's macros? This action will reset your daily totals.")
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Macro Tracker")
                .navigationBarItems(trailing: NavigationLink(destination: HistoryView(historyManager: historyManager)) {
                    Text("View History")
                        .foregroundColor(.blue)
                })
                .sheet(isPresented: $isScanning, onDismiss: {
                    if let barcode = scannedBarcode {
                        fetchNutritionData(for: barcode)
                    }
                }) {
                    BarcodeScannerView(scannedBarcode: $scannedBarcode)
                }
                .sheet(isPresented: $showMacroConfirmation) {
                    VStack {
                        Text("Scanned Macros").font(.headline).padding()

                        // Serving Size Input (ONLY)
                        VStack {
                            Text("Servings:")
                            TextField("Enter servings", value: $servingSize, formatter: NumberFormatter.decimalFormatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .onChange(of: servingSize) { newValue in
                                    updateMacrosByServing(newServingSize: newValue)
                                }
                        }
                        .padding()

                        // Display Updated Macros
                        VStack {
                            Text("Carbs: \(scannedCarbs)g")
                            Text("Protein: \(scannedProtein)g")
                            Text("Fat: \(scannedFat)g")
                        }
                        .padding()

                        // Confirm & Cancel Buttons
                        HStack {
                            Button("Confirm") {
                                if let carbs = Double(scannedCarbs),
                                   let protein = Double(scannedProtein),
                                   let fat = Double(scannedFat) {
                                    dailyCarbs += carbs
                                    dailyProtein += protein
                                    dailyFat += fat
                                }
                                showMacroConfirmation = false
                            }
                            .buttonStyle(.borderedProminent)

                            Button("Cancel") {
                                showMacroConfirmation = false
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                    }
                }
            }
            .dismissKeyboardOnTap() // ✅ Apply the modifier here
        }
        .sheet(isPresented: $isEditing) {
            EditMacrosView(
                dailyCarbs: $dailyCarbs,
                dailyProtein: $dailyProtein,
                dailyFat: $dailyFat,
                isEditing: $isEditing
            )
        }
        .sheet(isPresented: $isSettingGoals) {
            SetGoalsView()
        }

    }
    

    private func addMeal() {
        if let carbs = Double(inputCarbs), let protein = Double(inputProtein), let fat = Double(inputFat) {
            dailyCarbs += carbs
            dailyProtein += protein
            dailyFat += fat
        }
        inputCarbs = ""
        inputProtein = ""
        inputFat = ""
    }

    private func saveDailyMacros() {
        historyManager.saveEntry(carbs: dailyCarbs, protein: dailyProtein, fat: dailyFat, totalCalories: totalCalories)
        UserDefaults.standard.set(0.0, forKey: "dailyCarbs")
        UserDefaults.standard.set(0.0, forKey: "dailyProtein")
        UserDefaults.standard.set(0.0, forKey: "dailyFat")
    }

    func fetchNutritionData(for barcode: String) {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Full API Response:", json ?? "No JSON data")

                if let product = json?["product"] as? [String: Any],
                   let nutriments = product["nutriments"] as? [String: Any] {

                    DispatchQueue.main.async {
                        let servingSizeValue = (product["serving_size"] as? String)?.replacingOccurrences(of: "g", with: "") ?? "0"
                        let servingSizeGrams = Double(servingSizeValue) ?? 100.0 // Default to 100g if missing

                        let carbsPerServing = (nutriments["carbohydrates_serving"] as? Double) ?? 0.0
                        let proteinPerServing = (nutriments["proteins_serving"] as? Double) ?? 0.0
                        let fatPerServing = (nutriments["fat_serving"] as? Double) ?? 0.0

                        // Store original macros
                        originalCarbs = carbsPerServing
                        originalProtein = proteinPerServing
                        originalFat = fatPerServing

                        // Default to 1 serving
                        scannedCarbs = String(format: "%.1f", originalCarbs)
                        scannedProtein = String(format: "%.1f", originalProtein)
                        scannedFat = String(format: "%.1f", originalFat)
                        servingSize = 1.0

                        showMacroConfirmation = true
                    }
                }
            } catch {
                print("Error parsing JSON:", error.localizedDescription)
            }
        }.resume()
    }
    
    // Adjusts macros when user updates the number of servings
    func updateMacrosByServing(newServingSize: Double) {
        let multiplier = newServingSize // Multiply by servings

        let carbs = originalCarbs * multiplier
        let protein = originalProtein * multiplier
        let fat = originalFat * multiplier

        scannedCarbs = String(format: "%.1f", carbs)
        scannedProtein = String(format: "%.1f", protein)
        scannedFat = String(format: "%.1f", fat)
    }

    // Adjusts macros when user updates the total grams
    func updateMacrosByGrams(newGrams: Double) {
        let ratio = newGrams / servingSize
        let carbs = (Double(scannedCarbs) ?? 0.0) * ratio
        let protein = (Double(scannedProtein) ?? 0.0) * ratio
        let fat = (Double(scannedFat) ?? 0.0) * ratio

        scannedCarbs = String(format: "%.1f", carbs)
        scannedProtein = String(format: "%.1f", protein)
        scannedFat = String(format: "%.1f", fat)
    }
}

// Reusable Macro Progress Bar Component
struct MacroProgressBar: View {
    var title: String
    var value: Double
    var goal: Double
    var color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(String(format: "%.1f", value))g / \(String(format: "%.1f", goal))g")
                .font(.subheadline)
            ProgressView(value: value, total: goal)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
}

// Edit Macros View
struct EditMacrosView: View {
    @Binding var dailyCarbs: Double
    @Binding var dailyProtein: Double
    @Binding var dailyFat: Double
    @Binding var isEditing: Bool

    @State private var editedCarbs: String
    @State private var editedProtein: String
    @State private var editedFat: String

    init(dailyCarbs: Binding<Double>, dailyProtein: Binding<Double>, dailyFat: Binding<Double>, isEditing: Binding<Bool>) {
        _dailyCarbs = dailyCarbs
        _dailyProtein = dailyProtein
        _dailyFat = dailyFat
        _isEditing = isEditing
        _editedCarbs = State(initialValue: String(format: "%.1f", dailyCarbs.wrappedValue))
        _editedProtein = State(initialValue: String(format: "%.1f", dailyProtein.wrappedValue))
        _editedFat = State(initialValue: String(format: "%.1f", dailyFat.wrappedValue))
    }

    var body: some View {
        VStack {
            Text("Edit Daily Macros").font(.headline)
            
            TextField("Carbs", text: $editedCarbs)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            TextField("Protein", text: $editedProtein)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            TextField("Fat", text: $editedFat)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            HStack {
                Button("Save") {
                    if let carbs = Double(editedCarbs), let protein = Double(editedProtein), let fat = Double(editedFat) {
                        dailyCarbs = carbs
                        dailyProtein = protein
                        dailyFat = fat
                    }
                    isEditing = false
                }
                .buttonStyle(.borderedProminent)

                Button("Cancel") {
                    isEditing = false
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    
}

extension NumberFormatter {
    static var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 // Allows up to 2 decimal places (e.g., 1.5 servings)
        return formatter
    }
}

struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(KeyboardDismissModifier())
    }
}

#Preview {
    ContentView()
}
