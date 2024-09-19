# Steps Tracker

A battery-friendly pedometer app that uses the built-in sensor to count your steps, track burned calories, walking distance, and time. All information is clearly displayed in graphs. Written in Flutter/Dart.

## Features

-   **Automatic Step Counting**: Counts steps even when your phone is in your hand, bag, pocket, or armband, and with the screen locked.
-   **Power Efficient**: Uses the built-in sensor for battery-friendly operation.
-   **Comprehensive Tracking**: Monitors steps, calories burned, walking distance, and time.
-   **Graphical Reports**: View last 24 hours, weekly, and monthly statistics in easy-to-read graphs.
-   **Privacy Focused**: No sign-in required, and no personal data collection or sharing.
-   **Flexible Controls**: Start, pause, and reset the step counter at any time.
-   **Data Backup**: Back up and restore data from Google Drive.
-   **Customizable Sensitivity**: Adjust sensitivity for more accurate step counting.

## Upcoming Features

-   **Colorful Themes**: Choose from a variety of themes to personalize your experience.
-   **Goal Setting**: Set daily, weekly, or monthly step goals.
-   **Social Sharing**: Share your achievements with friends and family.
-   **Integration with Wearables**: Sync data with popular smartwatches and fitness bands.
-   **Challenges**: Participate in step challenges with other users.
-   **Detailed Activity Breakdown**: View step counts for different activities (walking, running, etc.).
-   **Customizable Widgets**: Add widgets to your home screen for quick access to stats.
-   **Persistent Storage**: Implement local database for reliable data storage and retrieval.
-   **Enhanced UI/UX**: Modernize the app's design with Material Design 3 principles.
-   **Advanced Analytics**: Implement machine learning for personalized insights and predictions.

## Health and Fitness

Steps Tracker is designed to improve your health and fitness by encouraging regular walking. It's an essential tool for:

-   Weight management
-   Cardiovascular health
-   Stress reduction
-   Overall fitness improvement

## Compatibility

-   Syncs with Samsung Health and Google Fit for a comprehensive health tracking experience.
-   Optimized for various Android devices, including older versions with some limitations.

## Technical Architecture

-   **MVVM Architecture**: Utilizes ViewModel and LiveData for efficient UI updates and data management.
-   **Jetpack Compose**: Implements modern UI toolkit for building native Android UI.
-   **Room Database**: Local persistence for offline access and improved performance.
-   **Navigation Component**: Simplifies in-app navigation and supports deep linking.

## Design Considerations

-   **Material Design 3**: Adopts the latest Material Design guidelines for a modern and consistent look.
-   **Dark Mode Support**: Implements a system-wide dark mode for improved visibility and battery life.
-   **Responsive Layout**: Optimizes UI for different screen sizes and orientations.
-   **Offline-first Architecture**: Implement robust offline functionality for uninterrupted usage.
-   **Performance Optimization**: Implement lazy loading and efficient data caching strategies.

## Platform-specific Considerations

### Android

-   Utilize Android-specific sensors for accurate step counting.
-   Implement background services for continuous step tracking.

## Data Management

-   Implement efficient data synchronization between local storage and cloud.
-   Implement data compression techniques for efficient storage and transfer.

# TODO

2. Develop basic UI using Jetpack Compose
   - Create main dashboard with step count, calories burned, distance, and time
   - Implement start, pause, and reset controls