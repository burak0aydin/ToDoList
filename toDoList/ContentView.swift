//
//  ContentView.swift
//  toDoList
//
//  Created by Burak Aydın on 17.02.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingAddTask = false
    @State private var showingSettings = false
    @State private var selectedFilter: TaskViewModel.TaskFilter = .all
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                // Filters ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterButton(title: languageManager.localizedString("all"), systemImage: "tray.fill", filter: .all, selectedFilter: $selectedFilter)
                        FilterButton(title: languageManager.localizedString("active"), systemImage: "circle", filter: .active, selectedFilter: $selectedFilter)
                        FilterButton(title: languageManager.localizedString("completed"), systemImage: "checkmark.circle.fill", filter: .completed, selectedFilter: $selectedFilter)
                        FilterButton(title: languageManager.localizedString("today"), systemImage: "calendar", filter: .today, selectedFilter: $selectedFilter)
                        FilterButton(title: languageManager.localizedString("upcoming"), systemImage: "calendar.badge.clock", filter: .upcoming, selectedFilter: $selectedFilter)
                        FilterButton(title: languageManager.localizedString("overdue"), systemImage: "exclamationmark.circle", filter: .late, selectedFilter: $selectedFilter)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Categories ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(title: languageManager.localizedString("all"), systemImage: "square.grid.2x2.fill", category: nil)
                        ForEach(Category.allCases, id: \.self) { category in
                            CategoryButton(title: languageManager.localizedString(category.rawValue.lowercased()), 
                                        systemImage: category.icon, 
                                        category: category,
                                        color: category.color)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Tasks List
                List {
                    ForEach(viewModel.filteredTasks) { task in
                        TaskRowView(task: task) { updatedTask in
                            viewModel.updateTask(updatedTask)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    // Force view to refresh when pulled down
                    viewModel.objectWillChange.send()
                }
            }
        }
        .navigationTitle(languageManager.localizedString("tasks"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddTask = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onChange(of: selectedFilter) { newFilter in
            viewModel.selectedFilter = newFilter
        }
    }
}

struct FilterButton: View {
    let title: String
    let systemImage: String
    let filter: TaskViewModel.TaskFilter
    @Binding var selectedFilter: TaskViewModel.TaskFilter
    
    var body: some View {
        Button(action: {
            selectedFilter = filter
        }) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedFilter == filter ? .blue : .gray)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedFilter == filter ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
    }
}

struct CategoryButton: View {
    let title: String
    let systemImage: String
    let category: Category?
    let color: Color?
    @EnvironmentObject var viewModel: TaskViewModel
    
    var isSelected: Bool {
        if viewModel.selectedCategory == nil && category == nil {
            return true
        }
        return viewModel.selectedCategory == category
    }
    
    init(title: String, systemImage: String, category: Category?, color: Color? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.category = category
        self.color = color
    }
    
    var body: some View {
        Button(action: {
            viewModel.selectedCategory = category
        }) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                Text(title)
            }
            .foregroundColor(isSelected ? .white : (color ?? .blue))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? (color ?? .blue) : (color ?? .blue).opacity(0.1))
            )
        }
    }
}

#Preview {
    NavigationView {
        ContentView()
            .environmentObject(TaskViewModel())
    }
}
