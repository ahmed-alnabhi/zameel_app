# Zameel - Educational Learning Management System 📚

A comprehensive educational mobile application built with Flutter that serves as a modern learning management system for students, teachers, and educational institutions.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS%20S3-FF9900?style=for-the-badge&logo=amazons3&logoColor=white)

## 🌟 Features

### 📱 Core Functionality
- **Multi-Role Support**: Students, Teachers, and Class Representatives
- **Real-Time Communication**: AI-powered chat bot with educational assistance
- **Social Learning Feed**: Share and interact with educational content
- **Assignment Management**: Create, submit, and track assignments
- **Digital Resources**: Access textbooks and educational materials
- **File Management**: Upload, download, and preview multiple file formats

### 🎨 User Experience
- **RTL Support**: Full Arabic language support with right-to-left layout
- **Dark/Light Themes**: Beautiful theme switching with custom color schemes
- **Responsive Design**: Optimized for different screen sizes using Flutter ScreenUtil
- **Modern UI**: Clean, professional interface with custom animations
- **Offline Capabilities**: Local data caching and offline functionality

### 🚀 Advanced Features
- **AI Chat Integration**: Context-aware educational assistant
- **Real-Time Messaging**: Pusher channels for instant communication
- **File Processing**: Support for images, PDFs, Office documents, and archives
- **Infinite Scrolling**: Paginated content loading with smooth performance
- **Image Gallery**: Slideshow and zoom functionality for media content
- **Assignment Tracking**: Due date management with visual indicators

## 🏗️ Technical Architecture

### Frontend (Flutter)
```
lib/
├── core/
│   ├── functions/          # Utility functions
│   ├── models/            # Data models
│   ├── networking/        # API services
│   ├── theme/            # App theming
│   └── widget/           # Reusable widgets
├── features/
│   ├── authentication/   # Login, registration, password recovery
│   └── home/
│       ├── assignments/  # Assignment management
│       ├── chat_bot/    # AI chat functionality
│       ├── posts/       # Social feed
│       ├── profile/     # User profile & settings
│       └── resources/   # Educational materials
└── main.dart
```

### Key Dependencies
- **dio**: HTTP client for API integration
- **flutter_screenutil**: Responsive design
- **pusher_channels_flutter**: Real-time messaging
- **cached_network_image**: Optimized image loading
- **flutter_markdown**: Rich text rendering
- **shared_preferences**: Local data storage
- **image_picker & image_cropper**: Media handling
- **flutter_file_downloader**: File management

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK (>=3.7.2)
- Dart SDK
- Android Studio / VS Code
- iOS development setup (for iOS builds)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zameel
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure assets**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS (requires macOS):**
```bash
flutter build ios --release
```

## 📊 Core Models

### Post Model
```dart
class PostModel {
  final int id;
  final String authorName;
  final int authorRollID;
  final String content;
  final DateTime createdAt;
  final List<PostFile> files;
}
```

### File Support
- **Images**: PNG, JPG, GIF
- **Documents**: PDF, DOCX, PPTX, XLSX, TXT
- **Archives**: ZIP, RAR, 7Z
- **Media**: Various video formats

## 🎯 User Roles & Permissions

### Students
- ✅ View and interact with posts
- ✅ Submit assignments
- ✅ Access educational resources
- ✅ Chat with AI assistant
- ✅ Join class requests

### Teachers
- ✅ Create and manage assignments
- ✅ Upload educational content
- ✅ Manage student groups
- ✅ Access advanced features

### Representatives
- ✅ Moderate class content
- ✅ Manage join requests
- ✅ Coordinate between students and teachers

## 🌐 API Integration

### Authentication
- Token-based authentication
- Device registration and tracking
- Password recovery with OTP
- Role-based access control

### Real-Time Features
- Pusher channels for instant messaging
- Live assignment updates
- Real-time notifications

### File Management
- AWS S3 integration for file storage
- Progressive file downloads
- Image optimization and caching

## 🎨 Design System

### Color Palette
- **Primary**: `#6366F1` (Indigo)
- **Secondary**: `#1B1A1F` (Dark Gray)
- **Background Light**: `#FFFFFF`
- **Background Dark**: `#000000`

### Typography
- **Font Family**: Alexandria (Arabic-optimized)
- **Weights**: Regular, Medium, Bold

### Custom Components
- Reusable buttons and form fields
- Custom navigation bars
- Loading indicators and shimmer effects
- File preview components

## 📱 Screenshots

*Add your app screenshots here to showcase the UI*

## 🚀 Performance Optimizations

- **Lazy Loading**: Efficient memory management with paginated content
- **Image Caching**: Reduced network requests with cached_network_image
- **State Management**: Optimized widget rebuilds
- **File Compression**: Optimized file uploads and downloads

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📈 Future Enhancements

- [ ] Push notifications
- [ ] Offline mode improvements
- [ ] Advanced analytics
- [ ] Video calling integration
- [ ] Gamification features
- [ ] Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

**Developer**: Junior Flutter Developer  
**Project**: Zameel Educational Platform  
**Tech Stack**: Flutter, Dart, AWS S3, Pusher, REST APIs

---

*Built with ❤️ using Flutter*
