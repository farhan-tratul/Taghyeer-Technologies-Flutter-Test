# Taghyeer - Flutter Assessment App

A production-quality Flutter application built with **Clean Architecture** and **BLoC state management**. This app demonstrates best practices in Flutter development with proper separation of concerns, dependency injection, and API integration.

## ✨ Features

- ✅ **User Authentication** - Login with DummyJSON API
- ✅ **Products Tab** - Browse products with pagination
- ✅ **Posts Tab** - View posts with load-more pagination
- ✅ **User Profile** - Display logged-in user information
- ✅ **Dark Mode** - Theme toggle with persistence
- ✅ **Session Management** - Auto-login on app restart
- ✅ **Error Handling** - Comprehensive error states with retry buttons
- ✅ **Responsive UI** - Beautiful Material Design 3 interface

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **State Management** | flutter_bloc ^8.1.4 |
| **HTTP Client** | http ^1.1.0 |
| **Local Storage** | shared_preferences ^2.2.2 |
| **Dependency Injection** | get_it ^7.6.0 |
| **JSON Serialization** | json_annotation + json_serializable |
| **Value Equality** | equatable ^2.0.5 |
| **API** | DummyJSON (https://dummyjson.com) |

### **Layer Responsibilities**

- **Presentation**: UI components and state management (BLoCs)
- **Domain**: Pure business logic and use cases
- **Data**: API calls and local storage management
- **Core**: Shared utilities, exceptions, and theme

## 📱 App Screenshots

| **login** | **products** | **post** | **setting** |
|:---:|:---:|:---:|:---:|
<img src="https://projects.farhanshariar.com/apk-hub/login.jpeg" alt="splash  Screen" width="200"/>| <img src="https://projects.farhanshariar.com/apk-hub/products.jpeg" alt="Login Screen" width="200"/> | <img src="https://projects.farhanshariar.com/apk-hub/post.jpeg" alt="Summary Page" width="200"/> | <img src="https://projects.farhanshariar.com/apk-hub/setting.jpeg" alt="Home Screen" width="200"/>

