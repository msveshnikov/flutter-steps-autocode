# Steps Tracker

A battery-friendly pedometer app that uses the built-in sensor to count your steps, track burned calories, walking distance, and time. All information is clearly displayed in graphs.

## Features

- **Automatic Step Counting**: Counts steps even when your phone is in your hand, bag, pocket, or armband, and with the screen locked.
- **Power Efficient**: Uses the built-in sensor for battery-friendly operation.
- **Comprehensive Tracking**: Monitors steps, calories burned, walking distance, and time.
- **Graphical Reports**: View last 24 hours, weekly, and monthly statistics in easy-to-read graphs.
- **Privacy Focused**: No sign-in required, and no personal data collection or sharing.
- **Flexible Controls**: Start, pause, and reset the step counter at any time.
- **Data Backup**: Back up and restore data from Google Drive.
- **Customizable Sensitivity**: Adjust sensitivity for more accurate step counting.
- **Multi-language Support**: Available in multiple languages for global users.

## Upcoming Features

- **Colorful Themes**: Choose from a variety of themes to personalize your experience.
- **Goal Setting**: Set daily, weekly, or monthly step goals.
- **Social Sharing**: Share your achievements with friends and family.
- **Integration with Wearables**: Sync data with popular smartwatches and fitness bands.
- **Challenges**: Participate in step challenges with other users.
- **Detailed Activity Breakdown**: View step counts for different activities (walking, running, etc.).
- **Customizable Widgets**: Add widgets to your home screen for quick access to stats.
- **Persistent Storage**: Implement local database for reliable data storage and retrieval.
- **Enhanced UI/UX**: Modernize the app's design with Material Design 3 principles.
- **Advanced Analytics**: Implement machine learning for personalized insights and predictions.

## Health and Fitness

Steps Tracker is designed to improve your health and fitness by encouraging regular walking. It's an essential tool for:

- Weight management
- Cardiovascular health
- Stress reduction
- Overall fitness improvement

## Compatibility

- Syncs with Samsung Health and Google Fit for a comprehensive health tracking experience.
- Optimized for various Android devices, including older versions with some limitations.

## Technical Architecture

- **MVVM Architecture**: Utilizes ViewModel and LiveData for efficient UI updates and data management.
- **Jetpack Compose**: Implements modern UI toolkit for building native Android UI.
- **Room Database**: Local persistence for offline access and improved performance.
- **Kotlin Coroutines**: Manages background tasks and asynchronous operations.
- **Dagger Hilt**: Dependency injection for cleaner and more testable code.
- **Navigation Component**: Simplifies in-app navigation and supports deep linking.

## Design Considerations

- **Material Design 3**: Adopts the latest Material Design guidelines for a modern and consistent look.
- **Dark Mode Support**: Implements a system-wide dark mode for improved visibility and battery life.
- **Accessibility**: Ensures the app is usable by people with various disabilities.
- **Localization**: Supports multiple languages and cultural adaptations.
- **Responsive Layout**: Optimizes UI for different screen sizes and orientations.
- **Cross-platform Compatibility**: Ensure consistent experience across Android, iOS, and web platforms.
- **Offline-first Architecture**: Implement robust offline functionality for uninterrupted usage.
- **Performance Optimization**: Implement lazy loading and efficient data caching strategies.
- **Security**: Implement end-to-end encryption for sensitive user data.
- **Modular Architecture**: Adopt a modular approach for easier maintenance and feature additions.

## Platform-specific Considerations

### Android
- Utilize Android-specific sensors for accurate step counting.
- Implement background services for continuous step tracking.
- Optimize battery usage with WorkManager for periodic syncing.

### iOS
- Leverage HealthKit for seamless integration with iOS health data.
- Implement widget extensions for iOS home screen.
- Utilize Core Motion framework for efficient motion processing.

### Web
- Implement Progressive Web App (PWA) features for offline capabilities.
- Optimize for various browsers and screen sizes.
- Utilize Web Workers for background processing without affecting UI performance.

## Data Management

- Implement efficient data synchronization between local storage and cloud.
- Use encryption for sensitive user data both in transit and at rest.
- Implement data compression techniques for efficient storage and transfer.

## Testing Strategy

- Implement comprehensive unit tests for core functionality.
- Utilize UI automation tests for cross-platform consistency.
- Perform rigorous performance testing, especially for step counting accuracy.

## Continuous Integration/Continuous Deployment (CI/CD)

- Set up automated build and test pipelines for all platforms.
- Implement feature flags for gradual rollout of new features.
- Utilize crash reporting and analytics tools for monitoring app health.

## Important Notes

- Input correct personal information in settings for accurate distance and calorie calculations.
- Some devices may stop counting steps when the screen is locked due to power-saving features.
- Step tracking availability may vary on older device versions when the screen is locked.

## TODO

- Fix Unsupported operation: Infinity or NaN toInt
- Implement error boundary and crash reporting system
- Optimize app size through code splitting and asset optimization
- Enhance accessibility features, including VoiceOver and TalkBack support
- Implement A/B testing framework for feature experimentation