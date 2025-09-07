# 🐇 UniPaw - Your Digital Pet, Your Uni Life Companion

UniPaw is a mobile application designed to provide accessible mental health support for university students and promote emotional well-being through interactive features and AI assistance, helping students cope with the demands of university life.

## 🔍 Problem Statement

Mental health issues like depression, anxiety, and stress are increasingly prevalent globally, including those caused by academic pressure and the demands of campus life. Stigma and limited access to resources prevent many individuals from seeking necessary help. With over 280 million people affected by depression alone, there is a critical need for accessible and supportive mental wellness solutions. UniPaw aims to address this gap by offering immediate access to mental health resources, fostering daily engagement through a virtual pet companion, and bridging the path to professional care and academic support.

## 💡 Solution Overview

UniPaw is a Flutter-based mobile application that serves as a digital companion with animations for mental wellness. It utilizes Firebase for backend services (data storage, authentication) and integrates Google's Gemini AI and OpenRouter for interactive chat support. Other features like a calendar planner, focus timer, peer support and consultation, and budget tracker provide more balanced academic control. What truly sets us apart is that everything you need to thrive as a student is right here, all in one app.

## ✨ Features

*   **Virtual Pet:** A central interactive pet whose appearance and animations change based on user interactions, reflecting engagement.
*   **Pet Interaction:** Buttons for quick interactions like playing with or talking to the pet using chatbox.
*   **Pet Tasks:** Engage in simple activities like playing with the pet or writing in the diary to earn coins, relieve stress, and increase the pet's happiness.
*   **Stress Assessments(Test):** Complete tests to receive scores, results, and helpful tips. Results are tracked over time.
*   **My Diary:** A private digital journal for personal reflection.
*   **Help Section:** Provides quick access to helplines, counseling services, and nearby hospitals (via Google Maps integration) with direct call, email, and WhatsApp options.
*   **Daily Check-In:** Log daily feelings, view entries on a calendar, and earn coins for pet customization.
*   **Budget Tracker:** Record all expenses or income and get a monthly summary chart to control the budget.
*   **Consultation:** Easily find professionals, book appointments, and text with them directly.
*   **AI-Powered Chat:** Talk to your pet via a chat bar powered by Gemini AI and OpenRouter. Includes safety alerts for concerning keywords, stores chat history, reads your calendar, and suggests new dates for upcoming meetings or events.
*   **Unlock New Pet:** Collect coins to unlock new pets for entertainment.
*   **Focus Timer:** Set study countdowns to stay focused on academics.
*   **Calendar Planner:** Record important assignments, tests, exams, and events with reminders, and check your schedule at a glance.
*   **App Language:** Options for English, Malay, and Mandarin (Note: Malay and Mandarin translations are planned for future updates).

## ▶️ Showcase / How It Works

1.  **Registration/Login:** User data is securely stored in Firebase.
2.  **Home Screen:** Users are greeted by their virtual pet, surrounded by interactive features. The pet's appearance reflects its happiness.
3.  **Interaction:** Users can engage with features like Check-In, Pet Tasks, Diary, and AI Chat.
4.  **Support:** The Help section provides immediate connections to external resources.
5.  **Personalization:** Earn coins through activities to (eventually) customize the pet.
6.  **Management:** Access profile, settings, and account management options via the top-right menu.
7.  **YouTube:** [link](https://youtu.be/js0eHzEhPVE)

## 🛠️ Architecture

*   **Frontend:** Flutter
*   **Backend:** Firebase (Authentication, Firestore/Realtime Database)
*   **AI:** Google Gemini API, OpenRouter
*   **Mapping:** Google Maps API
*   **Communication:** Gmail API (for password reset emails)

## 🎯 Our Goal

UniPaw aims to be more than just an app; it's designed to be a digital companion that heals, supports, and grows with its users. We strive to create a space where individuals feel heard, understood, and motivated to prioritize their mental well-being daily.

## Getting Started (Environment Setup)

This project is built with Flutter. To run the application locally:

1.  **Ensure Flutter is installed:** Follow the official [Flutter installation guide](https://docs.flutter.dev/get-started/install).
2.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd flutter-project # Or your project directory name
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Set up Firebase:**
    *   Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/).
    *   Register your Android and/or iOS app with the Firebase project.
    *   Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) configuration files and place them in the appropriate directories (`android/app/` and `ios/Runner/`).
    *   Enable necessary Firebase services (Authentication, Firestore/Realtime Database).
5.  **Set up Google Gemini API:**
    *   Obtain an API key from [Google AI Studio](https://aistudio.google.com/app/apikey) or Google Cloud Console.
    *   Create a new file by copying `lib/config/env.sample.dart` to `lib/config/env.dart`.
    *   Open `lib/config/env.dart` and replace the placeholder `'YOUR_API_KEY'` with your actual Gemini API key.
    *   **Important:** The `lib/config/env.dart` file is listed in `.gitignore` to prevent your API key from being accidentally committed to version control.
6.  **Set up Google Maps API:**
    *   Obtain an API key from the [Google Cloud Console](https://console.cloud.google.com/apis/library/maps-android-backend.googleapis.com).
    *   Configure the API key in your Android (`android/app/src/main/AndroidManifest.xml`) and/or iOS (`ios/Runner/AppDelegate.swift` or `ios/Runner/AppDelegate.m`) configurations.
7.  **Run the app:**
    ```bash
    flutter run
    ```

## 🔭 Future Development

*   **Pet Customization:** Implement the feature to use earned coins for customizing the virtual pet's appearance.
*   **Full Multilingual Support:** Complete the Malay and Mandarin translations for wider accessibility.
*   **Enhanced AI Interaction:** Explore more sophisticated AI responses and features.
*   **Community Features:** Potentially add opt-in features for peer support or shared experiences.
