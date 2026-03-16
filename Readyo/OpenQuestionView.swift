import SwiftUI

struct OpenQuestionView: View {
    let category: WordCategory
    let onWordSelected: (Word) -> Void
    
    private let library = WordLibrary.shared
    
    var categoryWords: [Word] {
        // Show max 6 most relevant words for the category
        Array(library.words(for: category).prefix(6))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Category label
            HStack {
                Image(systemName: categoryIcon)
                    .foregroundColor(categoryColor)
                Text("What would you like?")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(categoryColor)
                Spacer()
            }
            .padding(.horizontal)
            
            // Word grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(categoryWords) { word in
                    OpenWordCard(word: word) {
                        onWordSelected(word)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var categoryIcon: String {
        switch category {
        case .needs:      return "hand.raised.fill"
        case .feelings:   return "heart.fill"
        case .food:       return "fork.knife"
        case .people:     return "person.2.fill"
        case .activities: return "gamecontroller.fill"
        case .places:     return "map.fill"
        }
    }
    
    var categoryColor: Color {
        switch category {
        case .needs:      return .blue
        case .feelings:   return .orange
        case .food:       return .green
        case .people:     return .purple
        case .activities: return .pink
        case .places:     return .teal
        }
    }
}

// MARK: - Open Word Card
struct OpenWordCard: View {
    let word: Word
    let action: () -> Void
    @State private var isPressed = false
    
    var cardColor: Color {
        switch word.category {
        case .needs:      return .blue
        case .feelings:   return .orange
        case .food:       return .green
        case .people:     return .purple
        case .activities: return .pink
        case .places:     return .teal
        }
    }
    
    var body: some View {
        Button(action: {
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPressed = false
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isPressed ? cardColor : Color.white)
                        .shadow(radius: isPressed ? 8 : 3)
                        .frame(height: 80)
                    
                    VStack(spacing: 6) {
                        Image(systemName: word.imageName)
                            .font(.system(size: 30))
                            .foregroundColor(isPressed ? .white : cardColor)
                        
                        Text(word.text)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(isPressed ? .white : cardColor)
                    }
                }
            }
        }
        .scaleEffect(isPressed ? 1.05 : 1.0)
        .animation(.spring(response: 0.2), value: isPressed)
    }
}
