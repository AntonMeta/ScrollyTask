## 🚀 Features Implemented

This fork implements the core functionality along with several enhancements:

- **⏱️ Timer Logic:** Robust `TimerService` with background state handling and Hive persistence.
- **🌙 Adaptive Dark Mode:** The app fully supports system-wide Dark Mode.
- **📱 Responsive UI:** Implemented a custom `UIScaler` to ensure pixel-perfect rendering across different device sizes

## 🧪 Testing & Debugging

### Unit Tests

The project includes unit tests verifying the business logic, time formatting, and data persistence.
To run the tests:

```bash
flutter test
```

### 🏎️ Quick Data Seeding (Developer Mode)

To quickly populate the Statistics charts with 2 weeks of sample data:

1. Run the app.
2. On the Home Screen, **long-press the "Scrolly" title**.
3. A snackbar will confirm data generation.
4. Navigate to the **Statistics** tab to verify the charts and streak calculation.
