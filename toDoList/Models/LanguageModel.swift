import Foundation

enum Language: String, CaseIterable, Codable {
    case english = "English"
    case turkish = "Türkçe"
    
    var localizedStrings: [String: String] {
        switch self {
        case .english:
            return [
                "all": "All",
                "active": "Active",
                "completed": "Completed",
                "today": "Today",
                "upcoming": "Upcoming",
                "overdue": "Overdue",
                "tasks": "Tasks 📝",
                "newTask": "New Task",
                "taskTitle": "Task Title",
                "priority": "Priority",
                "category": "Category",
                "dueDate": "Due Date",
                "reminder": "Reminder",
                "notes": "Notes",
                "cancel": "Cancel",
                "save": "Save",
                "delete": "Delete",
                "settings": "Settings",
                "language": "Language",
                "taskDetails": "Task Details",
                "dateAndReminder": "Date & Reminder",
                "selectDate": "Select Date",
                "reminderTime": "Reminder Time",
                // Categories
                "personal": "Personal",
                "work": "Work",
                "shopping": "Shopping",
                "health": "Health",
                "education": "Education",
                "other": "Other",
                // Priorities
                "low": "Low",
                "medium": "Medium",
                "high": "High",
                // Date format
                "dueOn": "Due on"
            ]
        case .turkish:
            return [
                "all": "Tümü",
                "active": "Aktif",
                "completed": "Tamamlanan",
                "today": "Bugün",
                "upcoming": "Yaklaşan",
                "overdue": "Geciken",
                "tasks": "Görevler 📝",
                "newTask": "Yeni Görev",
                "taskTitle": "Görev Başlığı",
                "priority": "Öncelik",
                "category": "Kategori",
                "dueDate": "Son Tarih",
                "reminder": "Hatırlatıcı",
                "notes": "Notlar",
                "cancel": "İptal",
                "save": "Kaydet",
                "delete": "Sil",
                "settings": "Ayarlar",
                "language": "Dil",
                "taskDetails": "Görev Detayları",
                "dateAndReminder": "Tarih ve Hatırlatıcı",
                "selectDate": "Tarih Seç",
                "reminderTime": "Hatırlatıcı Zamanı",
                // Categories
                "personal": "Kişisel",
                "work": "İş",
                "shopping": "Alışveriş",
                "health": "Sağlık",
                "education": "Eğitim",
                "other": "Diğer",
                // Priorities
                "low": "Düşük",
                "medium": "Orta",
                "high": "Yüksek",
                // Date format
                "dueOn": "Son Tarih"
            ]
        }
    }
}

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
        }
    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = Language(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .english
        }
    }
    
    func localizedString(_ key: String) -> String {
        return currentLanguage.localizedStrings[key] ?? key
    }
}