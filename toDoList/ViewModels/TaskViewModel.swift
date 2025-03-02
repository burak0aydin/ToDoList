import Foundation
import UserNotifications

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var selectedFilter: TaskFilter = .all
    @Published var selectedCategory: Category?
    
    enum TaskFilter {
        case all, active, completed, today, upcoming, late
    }
    
    init() {
        loadTasks()
        requestNotificationPermission()
    }
    
    var filteredTasks: [Task] {
        var filtered = tasks
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        switch selectedFilter {
        case .active:
            return filtered.filter { !$0.isCompleted }
        case .completed:
            return filtered.filter { $0.isCompleted }
        case .today:
            return filtered.filter { 
                guard let dueDate = $0.dueDate else { return false }
                return Calendar.current.isDateInToday(dueDate)
            }
        case .upcoming:
            return filtered.filter {
                guard let dueDate = $0.dueDate else { return false }
                return dueDate > Date()
            }
        case .late:
            return filtered.filter {
                guard let dueDate = $0.dueDate else { return false }
                return dueDate < Date() && !$0.isCompleted
            }
        case .all:
            return filtered
        }
    }
    
    func shouldShowTask(_ task: Task) -> Bool {
        // Check category filter
        if let selectedCategory = selectedCategory {
            if task.category != selectedCategory {
                return false
            }
        }
        
        // Check task filter
        switch selectedFilter {
        case .active:
            return !task.isCompleted
        case .completed:
            return task.isCompleted
        case .today:
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate)
        case .upcoming:
            guard let dueDate = task.dueDate else { return false }
            return dueDate > Date()
        case .late:
            guard let dueDate = task.dueDate else { return false }
            return dueDate < Date() && !task.isCompleted
        case .all:
            return true
        }
    }
    
    func addTask(_ title: String, dueDate: Date? = nil, priority: Priority = .medium, category: Category = .personal, notes: String? = nil, hasReminder: Bool = false, reminderDate: Date? = nil) {
        let task = Task(title: title, dueDate: dueDate, priority: priority, category: category, notes: notes, hasReminder: hasReminder, reminderDate: reminderDate)
        tasks.append(task)
        saveTasks()
        
        if hasReminder, let reminderDate = reminderDate {
            scheduleNotification(for: task, at: reminderDate)
        }
        
        objectWillChange.send()
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
            
            // Update notification if needed
            if task.hasReminder, let reminderDate = task.reminderDate {
                scheduleNotification(for: task, at: reminderDate)
            } else {
                cancelNotification(for: task)
            }
        }
    }
    
    func deleteTask(at indexSet: IndexSet) {
        for index in indexSet {
            cancelNotification(for: tasks[index])
        }
        tasks.remove(atOffsets: indexSet)
        saveTasks()
    }
    
    func deleteTask(withId id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            let task = tasks[index]
            cancelNotification(for: task)
            tasks.remove(at: index)
            saveTasks()
        }
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        saveTasks()
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "Tasks")
        }
    }
    
    private func loadTasks() {
        if let tasksData = UserDefaults.standard.data(forKey: "Tasks") {
            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
                tasks = decodedTasks
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleNotification(for task: Task, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func cancelNotification(for task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
}