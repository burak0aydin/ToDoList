import Foundation
import SwiftUI

struct Task: Identifiable, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var creationDate: Date
    var dueDate: Date?
    var priority: Priority
    var category: Category
    var notes: String?
    var hasReminder: Bool
    var reminderDate: Date?
    
    init(id: UUID = UUID(), 
         title: String, 
         isCompleted: Bool = false, 
         creationDate: Date = Date(),
         dueDate: Date? = nil,
         priority: Priority = .medium,
         category: Category = .personal,
         notes: String? = nil,
         hasReminder: Bool = false,
         reminderDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
        self.notes = notes
        self.hasReminder = hasReminder
        self.reminderDate = reminderDate
    }
}

enum Priority: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "yellow"
        case .high: return "red"
        }
    }
}

enum Category: String, Codable, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case shopping = "Shopping"
    case health = "Health"
    case education = "Education"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .shopping: return "cart.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .other: return "square.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .personal: return .purple
        case .work: return .blue
        case .shopping: return .green
        case .health: return .pink
        case .education: return .orange
        case .other: return .gray
        }
    }
}