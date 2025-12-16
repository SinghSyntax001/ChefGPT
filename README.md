# 🍳 ChefGPT
## AI-Powered Recipe Assistant App

ChefGPT is an intelligent mobile application built using **Flutter**, **Firebase**, and **Groq’s LLaMA-3 model**. The app allows users to generate recipes, chat with an AI chef, and save their favorite recipes securely.

---

## 🚀 Features

### 🔐 Authentication
- Email & Password Login
- Google Sign-In
- Secure sessions using Firebase Authentication

### 🧠 AI Recipe Generation
- Generate complete recipes using AI
- Clean, readable plain-text format
- Ingredients and step-by-step instructions
- Powered by Groq Cloud (LLaMA-3 8B)

### 💬 AI Chef Chat
- Chat with an AI Chef for cooking guidance
- Ask about substitutions, cooking time, and tips
- Context-aware responses

### 📖 Recipe Management
- Save AI-generated recipes
- View saved recipes in user profile
- Delete recipes anytime
- Cloud Firestore integration

### 👤 User Profile
- View user information
- Access saved recipes
- Secure logout

### 🎨 UI & UX
- Modern Material 3 design
- Smooth animations
- Clean and responsive layout

---

## 🛠 Tech Stack

| Layer | Technology |
|------|------------|
| Frontend | Flutter (Material 3) |
| Backend | Firebase |
| Authentication | Firebase Auth + Google Sign-In |
| Database | Cloud Firestore |
| AI Model | LLaMA-3 (8B) |
| AI API | Groq Cloud |
| Environment Variables | flutter_dotenv |

---

## 📱 Screens

- Login Page  
- Signup Page  
- Home Page (Trending Recipes + AI Search)  
- AI Recipe Detail Page  
- AI Chef Chat Page  
- Profile Page  
- Saved Recipes Page  

---

## 🧠 How ChefGPT Works

1. User logs in using Firebase Authentication  
2. User searches or asks AI for a recipe  
3. App sends prompt to Groq Cloud  
4. LLaMA-3 generates a recipe  
5. User can chat with AI or save the recipe  
6. Saved recipes are stored in Firestore  

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/<your-username>/chefgpt.git
cd chefgpt
````

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Setup Environment Variables

Create a `.env` file in the project root:

```env
GROQ_API_KEY=your_groq_api_key_here
```

### 4️⃣ Firebase Setup

Add the following files (not included in repo):

* `android/app/google-services.json`
* `lib/firebase_options.dart`

Enable in Firebase Console:

* Email/Password Authentication
* Google Sign-In
* Cloud Firestore

### 5️⃣ Run the App

```bash
flutter run
```

---

## 📦 Build APK

```bash
flutter build apk
```

APK output:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔐 Security Notes

* `.env` file is excluded from GitHub
* API keys are not hardcoded
* Firebase credentials are protected

---

## 🧪 Tested On

* Android Emulator (API 33+)
* Physical Android Device
* Debug and Release modes

---

## 📈 Future Enhancements

* Voice input (Speech-to-Text)
* AI-generated recipe images
* Offline recipe access
* Multi-language support
* Personalized recommendations

---

Developed by **Shashank Singh & Pallav Prakash**



