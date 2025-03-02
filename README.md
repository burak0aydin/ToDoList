# ToDoList

## Overview
ToDoList is a modern task management application built with SwiftUI that helps you create, view, and manage your daily tasks. Using an MVVM architecture along with reactive data binding, the app offers powerful features like filtering, categorization, reminders, and localization support (English/Türkçe). The user-friendly interface makes task management effortless on any iOS device.

https://github.com/user-attachments/assets/6ab50491-5c4d-4e24-9869-3d0c9ae2ec45

## Note
While making this application, I used the github Copilot agent artificial intelligence tool and the Vs Code insider program.

## Features
- **Task Management:**  
  - **Add Tasks:** Create new tasks with a title, due date, priority, category, and optional notes.  
  - **Mark Complete:** Easily toggle task completion status.  
  - **Update & Delete:** Modify or remove tasks with intuitive swipe gestures.
- **Filtering & Categorization:**  
  - **Status Filters:** Filter tasks by All, Active, Completed, Today, Upcoming, and Overdue.
  - **Category Filters:** Narrow down tasks by categories such as Personal, Work, Shopping, Health, Education, and Other.
- **Reminders & Notifications:**  
  - Schedule reminders for tasks using iOS notification APIs.
- **Localization:**  
  - Dynamic language support with English and Turkish, managed via a Language Manager.
- **User-Friendly UI:**  
  - Clean, adaptive interface built entirely in SwiftUI with modern design components such as horizontal scroll filters, dynamic lists, and swipe-to-refresh/delete functionalities.

## Technologies (Architecture)
- **SwiftUI:** For building a declarative and responsive user interface.
- **MVVM Pattern:** Separates UI (View), business logic (ViewModel), and data (Model) for a scalable and maintainable codebase.
- **UserNotifications:** Schedules and handles task reminders.
- **UserDefaults & Codable:** Persist tasks locally using JSON encoding and decoding.
- **Environment Objects:** Share data seamlessly (e.g., TaskViewModel, LanguageManager) across the view hierarchy.

## Project Structure
- **ContentView.swift:**  
  The main view that displays task filters, categories, and the list of tasks. It uses horizontal scroll views for filters and categories, and a List to show tasks using the custom `TaskRowView`.
- **LanguageModel.swift:**  
  Defines the `Language` enum and `LanguageManager` class to manage localized strings for English and Turkish.
- **TaskModel.swift:**  
  Contains the `Task` struct and supporting enums (`Priority` and `Category`) that model task data.
- **toDoListApp.swift:**  
  The app’s entry point, which sets up environment objects for the task view model and language manager, and embeds the ContentView in a NavigationView.
- **TaskViewModel.swift:**  
  Manages the tasks data, including adding, updating, deleting, filtering, and persisting tasks. It also handles notification scheduling for reminders.
- **AddTaskView.swift:**  
  A form-based view that allows users to enter new task details such as title, priority, category, due date, reminder, and notes. It provides Cancel and Save actions.
- **SettingsView.swift:**  
  A settings interface where users can change the app’s language. It uses a Picker to select between English and Turkish.
- **TaskRowView.swift:**  
  A custom row view that displays individual task details, including completion status, due date, priority badge, and category icon. It supports swipe gestures for deletion with confirmation alerts.
- **toDoListTests.swift:**  
  Contains unit tests to verify the functionality of task management logic.
- **toDoListUITestsLaunchTests.swift & toDoListUITests.swift:**  
  Provide UI tests to ensure the app launches correctly and that key UI interactions perform as expected.

------------------------------------------------------------------------------------------------------------------------------------------

## Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>

2. Open in Xcode:
- Open the .xcodeproj file in Xcode.

3. Build & Run:
- Build the project and run it on an iOS simulator or a physical device.
