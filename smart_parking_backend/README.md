# 🖥️ Smart Parking Backend

This folder contains the **Flask backend** for the Smart Parking System.

The backend handles user authentication, parking slot management, booking operations, QR code validation, and communication between the Flutter application and IoT hardware.

## ✨ Features

- REST API
- User Authentication
- QR Code Generation
- QR Code Validation
- Booking Management
- Parking Slot Management
- PostgreSQL Database Integration
- ESP32 Communication

## 🛠️ Technology Stack

- Python
- Flask
- PostgreSQL
- REST API

## 📂 Important Files

```
app.py              → Main Flask application
database.py         → Database connection
models.py           → Database models
config.py           → Configuration settings
qr_generator.py     → QR Code generation
qr_scanner.py       → QR Code validation
requirements.txt    → Python dependencies
```

## ▶️ Run the Backend

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the server:

```bash
python app.py
```

## API Responsibilities

- User Registration & Login
- Parking Slot Booking
- Parking Availability
- QR Authentication
- Booking History
- Database Operations

## 📌 Note

The backend acts as the communication layer between the Flutter mobile application, PostgreSQL database, and ESP32-based hardware modules.