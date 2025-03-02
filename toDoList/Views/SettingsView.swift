import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString("language"))) {
                    Picker(languageManager.localizedString("language"), selection: $languageManager.currentLanguage) {
                        ForEach(Language.allCases, id: \.self) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                }
            }
            .navigationTitle(languageManager.localizedString("settings"))
            .navigationBarItems(trailing: Button(languageManager.localizedString("save")) {
                dismiss()
            })
        }
    }
}