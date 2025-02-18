# 🥑 Macro Tracker App 🍗🥦

*A lightweight and intuitive iOS application for tracking daily macro intake with barcode scanning functionality.*

## 📌 Overview
Macro Tracker is a **SwiftUI-based iOS application** that helps users track their daily macronutrient intake (**carbohydrates, protein, and fat**). Users can **manually enter meal macros, set daily goals, view historical entries, and scan barcodes** to fetch nutrition data from **Open Food Facts API**. 

The app ensures **data persistence** even after closing, and features an **intuitive UI with a smooth user experience.**  

## ✨ Features
✅ **Manual Entry of Macros** – Users can input carbs, protein, and fat per meal.  
✅ **Automatic Macro Summation** – Every meal entry adds to the total daily intake.  
✅ **Barcode Scanning** – Scan food barcodes and retrieve macronutrient info from Open Food Facts.  
✅ **Serving Size Adjustment** – Users can edit the number of servings before adding macros.  
✅ **Set Daily Goals** – Users can set macro targets, and progress bars update accordingly.  
✅ **Edit Macros** – If a mistake is made, users can edit their daily macros manually.  
✅ **History Tracking** – Users can save daily macros and view past entries.  
✅ **Confirmation Pop-ups** – Prevents accidental macro updates or history deletions.  
✅ **Persistent Storage** – Macro data remains stored even after closing the app.  

## 📲 Installation & Setup

### **Prerequisites**
- **Xcode 15+**  
- **iOS 16+ device or simulator**  
- **Apple Developer Account** (if testing on a real device)

### **Clone Repository**
```sh
git clone https://github.com/yourusername/macro-tracker.git
cd macro-tracker
```
## Open in Xcode
1.	Open MacroTracker.xcodeproj in Xcode.
2.	Select your device or simulator.
3.	Click Run ▶️ to build and launch the app.

## Testing on a Real Device
1.	Connect your iPhone.
2.	Go to Xcode → Signing & Capabilities.
3.	Select your Apple ID and enable Development Signing.
4.	Run the app on your device.

## 🛠 Technologies Used
-	SwiftUI – Modern declarative UI framework
-	VisionKit – Barcode scanning integration
-	Open Food Facts API – Retrieves nutrition data
-	UserDefaults – Persistent data storage
-	AppStorage – Manages daily macro values
-	MVVM Architecture – Ensures clean and modular code structure

## 📖 How It Works
1.	Entering Macros: Users manually input and add meal macros to the daily total.
2.	Barcode Scanning: Scans a barcode using VisionKit, fetches macros from Open Food Facts API, and allows the user to confirm/edit before adding.
3.	Editing Macros: Users can manually adjust daily macro values.
4.	Setting Goals: Users define daily macro targets, and progress bars indicate how close they are to reaching them.
5.	Saving Daily Macros: Users can save their daily macro data and view their intake history.
6.	History Management: Saved entries are persistent, and users can delete or clear history if needed.

## 🚀 Future Improvements
🔹 Meal Pre-Logging for Future Days
🔹 Custom Food Entries
🔹 Apple Health Integration

## 📸 Screenshots
(coming soon)

## 👨‍💻 Author
Ryan Soe
📍 GitHub: [github/ryansoe](https://github.com/ryansoe)
📍 LinkedIn: [linkedin/ryansoe](https://www.linkedin.com/in/ryan-soe-2596b6309/)
