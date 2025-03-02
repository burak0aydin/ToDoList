import SwiftUI

struct TaskRowView: View {
    var task: Task
    var onUpdate: (Task) -> Void
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var offset: CGFloat = 0
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete Background
            Rectangle()
                .fill(Color.red)
                .frame(width: abs(offset) > 50 ? UIScreen.main.bounds.width : abs(offset))
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.trailing, 20)
                            .opacity(abs(offset) > 50 ? 1 : abs(offset)/50.0) // Fixed: Added .0 to make it CGFloat
                    }
                )
            
            // Main Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Button(action: {
                        var updatedTask = task
                        updatedTask.isCompleted.toggle()
                        onUpdate(updatedTask)
                    }) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .font(.title2)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundColor(task.isCompleted ? .gray : .primary)
                            .font(.headline)
                        
                        if let notes = task.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Image(systemName: task.category.icon)
                            .foregroundColor(task.category.color)
                        
                        if let dueDate = task.dueDate {
                            Text(formatDate(dueDate))
                                .font(.caption)
                                .foregroundColor(isOverdue(dueDate) ? .red : .gray)
                        }
                    }
                }
                
                HStack(spacing: 8) {
                    PriorityBadge(priority: task.priority)
                    
                    if task.hasReminder {
                        HStack(spacing: 2) {
                            Image(systemName: "bell.fill")
                            if let reminderDate = task.reminderDate {
                                Text(formatTime(reminderDate))
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Text(task.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(task.category.color.opacity(0.2))
                        .foregroundColor(task.category.color)
                        .cornerRadius(8)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color(.systemBackground))
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Only allow left swipe
                        if value.translation.width < 0 {
                            withAnimation(.interactiveSpring()) {
                                offset = value.translation.width
                            }
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -UIScreen.main.bounds.width / 3 {
                            // Show delete confirmation
                            showingDeleteAlert = true
                            withAnimation(.spring()) {
                                offset = -60
                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = 0
                            }
                        }
                    }
            )
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Task"),
                message: Text("Are you sure you want to delete this task?"),
                primaryButton: .destructive(Text("Delete")) {
                    withAnimation(.easeInOut) {
                        viewModel.deleteTask(withId: task.id)
                    }
                },
                secondaryButton: .cancel {
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
            )
        }
        .frame(maxWidth: .infinity)
        .clipped()
    }
    
    private func isOverdue(_ date: Date) -> Bool {
        return date < Date() && !task.isCompleted
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct PriorityBadge: View {
    let priority: Priority
    
    var body: some View {
        Text(priority.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(priority.color).opacity(0.2))
            .foregroundColor(Color(priority.color))
            .cornerRadius(8)
    }
}