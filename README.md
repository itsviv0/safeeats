# SafeEats - Smart Allergen Detection App![alt text](safeeats.png)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![Flask](https://img.shields.io/badge/flask-%e543405e.svg?style=for-the-badge&logo=flask&logoColor=white)
![APIs](https://img.shields.io/badge/apis-%3485354.svg?style=for-the-badge&logo=&logoColor=white)
![Vercel](https://img.shields.io/badge/vercel-%23644e.svg?style=for-the-badge&logo=vercel&logoColor=white)

**SafeEats** is an intelligent Flutter mobile application that helps users identify allergens in packaged foods through advanced barcode scanning and ingredient analysis. Perfect for people with food allergies, dietary restrictions, or anyone who wants to make informed food choices.

## 🌟 Key Features

### 📱 **Dual Scanning Technology**

- **Barcode Scanner**: Scan product barcodes to get instant ingredient and allergen information from the OpenFoodFacts database
- **Ingredient Scanner**: Use OCR technology to scan ingredient lists directly from packaging when barcode data isn't available

### 🤖 **Allergen Detection**

- **Real-time Processing**: Instant allergen analysis using cloud-based preprocessing and detection services
- **Comprehensive Detection**: Identifies common allergens like milk, nuts, gluten, soy, and more

### 💾 **Smart Data Management**

- **SQLite Database**: Local storage for all scan history and results
- **Persistent History**: View all previously scanned products with detailed information
- **Offline Access**: Access your scan history even without internet connection

### 📊 **Intuitive User Interface**

- **Material Design**: Clean, modern UI following Material Design principles
- **Scan History**: Comprehensive history view with filtering options (barcode vs manual scans)
- **Detailed Product View**: Complete ingredient lists, allergen warnings, and nutritional information
- **Interactive Results**: Tap on scan results for detailed allergen breakdown

### **Backend Services**

- **OpenFoodFacts API**: Product information and allergen data
- **Custom OCR Service**: Text extraction from ingredient labels
- **Allergen Detection**: API based allergen analysis
- **Local Database**: SQLite for persistent storage

### **Database Schema**

```sql
CREATE TABLE scan_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  productName TEXT NOT NULL,
  brand TEXT,
  imageUrl TEXT,
  barcode TEXT,
  ingredients TEXT NOT NULL,
  allergens TEXT NOT NULL,
  allergiesDetected TEXT NOT NULL,
  scanType TEXT NOT NULL,
  scannedAt INTEGER NOT NULL
);
```

## 🚀 Getting Started

### **Prerequisites**

- Flutter SDK (>=3.6.1)
- Dart SDK (>=3.6.1)
- Android Studio / VS Code
- Android device or emulator
- Camera permissions for scanning

### **Installation**

1. **Clone the repository**

   ```bash
   git clone https://github.com/itsviv0/safeeats.git
   cd safeeats3
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 🔧 How It Works

### **1. Barcode Scanning Flow**

```
User scans barcode → OpenFoodFacts API → Product data retrieved →
ML allergen analysis → Results displayed → Data saved to database
```

### **2. Manual Ingredient Scanning Flow**

```
User captures ingredient image → OCR text extraction →
Text preprocessing → Ingredient parsing → ML allergen detection →
Results displayed → Data saved to database
```

### **3. Data Processing Pipeline**

- **Allergen Detection**: `https://allergydetectionsafeeats.vercel.app/`
- **Product Database**: `https://world.openfoodfacts.org/api/v0`

## 📱 App Screens

### **Welcome Screen**

- App introduction and feature overview
- Quick access to scanning functionality
- Navigation to scan history

### **Barcode Scanner**

- Real-time barcode detection
- Camera viewfinder with scanning overlay
- Automatic product lookup and processing

### **Ingredient Scanner**

- OCR-based text recognition
- Multiple image capture support
- Manual ingredient list building
- Real-time ingredient addition and removal

### **Results Display**

- **Product Information**: Name, brand, image
- **Ingredient List**: Complete ingredient breakdown
- **Allergen Warnings**: Highlighted allergen alerts
- **DB Analysis**: Detect potential allergens

### **Scan History**

- **Complete History**: All scanned products
- **Filter Options**: Barcode vs manual scans
- **Detailed View**: Tap for complete product information
- **Management**: Delete individual items or clear all

## 🎯 Use Cases

### **For Individuals with Allergies**

- Quickly identify products containing specific allergens
- Build a personal database of safe products
- Share scan results with family members

### **For Health-Conscious Consumers**

- Analyze ingredient quality and additives
- Track dietary preferences and restrictions
- Make informed purchasing decisions

### **For Parents**

- Ensure child-safe products
- Educational tool for teaching about ingredients
- Quick allergen checking while shopping

## 🔮 Future Enhancements

### **Planned Features**

- [ ] **User Profiles**: Personal allergen preferences and restrictions
- [ ] **Nutrition Analysis**: Detailed nutritional information and scoring
- [ ] **Shopping Lists**: Smart shopping lists with allergen-safe alternatives
- [ ] **Social Features**: Share safe products with friends and family
- [ ] **Offline ML**: On-device allergen detection for offline usage
- [ ] **Multi-language**: Support for multiple languages and regions
- [ ] **Barcode Generation**: Generate QR codes for custom products

### **Technical Improvements**

- [ ] **Enhanced OCR**: Better text recognition accuracy
- [ ] **Cloud Sync**: Cross-device synchronization
- [ ] **Performance**: Optimized scanning and processing speed
- [ ] **Accessibility**: Enhanced accessibility features
