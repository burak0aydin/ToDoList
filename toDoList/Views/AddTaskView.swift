import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: LanguageManager
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var taskTitle = ""
    @State private var selectedPriority = Priority.medium
    @State private var selectedCategory = Category.personal
    @State private var notes = ""
    @State private var dueDate = Date()
    @State private var hasReminder = false
    @State private var reminderDate = Date()
    @State private var showingDueDatePicker = false
    @State private var showingReminderPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString("taskDetails"))) {
                    TextField(languageManager.localizedString("taskTitle"), text: $taskTitle)
                    
                    Picker(languageManager.localizedString("priority"), selection: $selectedPriority) {
                        ForEach([Priority.low, .medium, .high], id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(Color(priority.color))
                                    .frame(width: 12, height: 12)
                                Text(languageManager.localizedString(priority.rawValue.lowercased()))
                            }
                            .tag(priority)
                        }
                    }
                    
                    Picker(languageManager.localizedString("category"), selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Label(languageManager.localizedString(category.rawValue.lowercased()), 
                                  systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }
                
                Section(header: Text(languageManager.localizedString("dateAndReminder"))) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Toggle(languageManager.localizedString("dueDate"), isOn: $showingDueDatePicker)
                    }
                    
                    if showingDueDatePicker {
                        DatePicker(languageManager.localizedString("selectDate"), 
                                 selection: $dueDate, 
                                 displayedComponents: [.date])
                    }
                    
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.orange)
                        Toggle(languageManager.localizedString("reminder"), isOn: $hasReminder)
                    }
                    
                    if hasReminder {
                        DatePicker(languageManager.localizedString("reminder"), 
                                 selection: $reminderDate, 
                                 displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text(languageManager.localizedString("notes"))) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(languageManager.localizedString("newTask"))
            .navigationBarItems(
                leading: Button(languageManager.localizedString("cancel")) {
                    dismiss()
                },
                trailing: Button(languageManager.localizedString("save")) {
                    saveTask()
                }
                .disabled(taskTitle.isEmpty)
            )
            .onDisappear {
                viewModel.objectWillChange.send()
            }
        }
    }
    
    private func saveTask() {
        viewModel.addTask(
            taskTitle,
            dueDate: showingDueDatePicker ? dueDate : nil,
            priority: selectedPriority,
            category: selectedCategory,
            notes: notes.isEmpty ? nil : notes,
            hasReminder: hasReminder,
            reminderDate: hasReminder ? reminderDate : nil
        )
        viewModel.objectWillChange.send()
        dismiss()
    }
}