# Emergency Vehicle Priority with Route Optimization and Traffic Management Application

## Overview

In recent years, we have witnessed significant advancements in technology that have revolutionized everyday services such as grocery delivery and food delivery. Companies like Swiggy, Zomato, and Grofers have set high standards for timely and efficient delivery, ensuring customers receive their orders promptly. However, when it comes to emergency services like ambulances, the response times and coordination still lag behind. This project introduces the "Emergency Vehicle Priority with Route Optimization and Traffic Management Application," an innovative solution designed to bring the same level of efficiency and urgency to emergency vehicle operations.

The fast-paced nature of urban life demands swift emergency responses. Recognizing this urgency, the application aims to streamline and enhance the coordination between ambulance drivers and traffic police to minimize delays and improve overall efficiency. It helps ambulance drivers and traffic police work together better. Ambulance drivers can share their locations and get the best routes in real-time. The traffic signals automatically change when an ambulance approaches, and traffic police are notified when an ambulance is coming, helping it move smoothly. This app makes emergency responses faster and smoother in cities.

## Features

- **Real-time Location Tracking**: Ambulance drivers can update their current location and destination hospital in the app.
- **Dynamic Route Optimization**: The app calculates and updates the most efficient route to the destination dynamically.
- **Traffic Signal Management**: Integrates with IoT to automatically turn traffic signals green as the ambulance approaches.
- **Notification System**: Sends alerts to traffic police near upcoming traffic signals to assist in clearing the route.
- **Firebase Integration**: Utilizes Firebase for real-time database management and user authentication.

## Screenshots
<table>
  <tr>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/75fb16c7-28d2-4743-87da-7c96b0b4b779" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/6d49d427-16f1-4d0a-b907-ea28add88a10" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/42974f6d-7f92-4647-a3c4-921ba2f30c79" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/3de3d7b0-6ca9-4c44-bdb5-db2892dbcd2e" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/b9029f8b-a93c-40c4-ae5f-73af5fd7971a" width=200></td>
  </tr>

  <tr>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/5fa5cfd7-935d-4b3c-acaa-62cd93352871" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/81e8d416-18db-4a57-ada0-d5091e52b84b" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/2e956d36-51a2-41a4-b8e1-df416f741e58" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/4048b50e-e30a-4dcc-8961-75d382cc15b5" width=200></td>
    <td><img src= "https://github.com/deepaksp24/ev_app/assets/79745724/d1d74863-af4d-4bbf-a0eb-ba5c56e58244" width=200></td>
  </tr>
</table>


## System Requirements

- **Operating System**: Windows 10 or later
- **Software**:
  - Flutter (for mobile app development)
  - Google Maps API (for maps and location services)
  - Firebase (for backend services and database management)
  - Visual Studio Code (for development environment)

## Installation Instructions

### Prerequisites

1. **Flutter SDK**: Ensure Flutter is installed and properly set up. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install/windows) for Windows.
2. **Android Studio**: Install Android Studio to provide the necessary Android SDK and emulator. [Android Studio installation guide](https://developer.android.com/studio/install).
3. **Firebase Account**: Create a Firebase project and configure it for Android and iOS.
4. **Google Maps API Key**: Obtain an API key from the Google Cloud Platform.

### Steps

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/deepaksp24/ev_app.git
    cd ev_app
    ```

2. **Configure Firebase**:
    - Download `google-services.json` for Android from your Firebase project settings and place it in `android/app`.

3. **Set Up Google Maps API**:
    - Add your API key to `android/app/src/main/AndroidManifest.xml`:
        ```xml
        <application>
            ...
            <meta-data
                android:name="com.google.android.geo.API_KEY"
                android:value="YOUR_API_KEY"/>
            ...
        </application>
        ```

4. **Install Dependencies**:
    Open a terminal (Command Prompt or PowerShell) and navigate to the project directory, then run:
    ```sh
    flutter pub get
    ```

5. **Run the Application**:
    - Connect an Android device via USB or ensure you have an Android emulator set up in Android Studio.
    - In the terminal, run:
        ```sh
        flutter run
        ```

### Additional Tools (Optional)

- **Visual Studio Code**: Use VS Code with the Flutter extension for an enhanced development experience. Install it from [Visual Studio Code](https://code.visualstudio.com/).

## Usage Instructions

1. **New User Registration**:
    - Open the app and navigate to the registration screen.
    - Fill in the required details and create an account.
    - Navigate to login page

2. **Ambulance Driver**:
    - Open the app and log in.
    - Enter the destination hospital.
    - The app will display the optimized route and update it dynamically as you move.

3. **Traffic Police**:
    - Open the app and log in.
    - Receive notifications when an ambulance is approaching a traffic signal near you.
    - Assist in clearing the route for the ambulance.

