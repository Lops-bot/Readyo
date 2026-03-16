import SwiftUI
import Speech
import AVFoundation
import Combine

// MARK: - App Screen States
enum AppScreen {
    case home           // Just microphone
    case images         // Show keyword images + Respond button
    case responses      // Show child response options
}

struct ContentView: View {
    @StateObject private var speechManager = SpeechManager()
    @StateObject private var responseManager = ResponseManager()
    @State private var currentScreen: AppScreen = .home
    @State private var isTransitioning: Bool = false
    
    
    private let library = WordLibrary.shared
    
    var matchedWords: [Word] {
        library.findWords(matching: speechManager.keyWords)
    }
    
    var questionType: QuestionType {
        speechManager.detectQuestionType(from: speechManager.spokenText)
    }
    
    var detectedCategory: WordCategory {
        speechManager.detectCategory(from: speechManager.spokenText) ?? .needs
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.95, blue: 1.0)
                .ignoresSafeArea()
            
            switch currentScreen {
            case .home:
                HomeScreen(
                    speechManager: speechManager,
                    onSpeechComplete: {
                        guard !isTransitioning else { return }
                        guard !speechManager.keyWords.isEmpty else { return }
                        isTransitioning = true
                        currentScreen = .images
                    }
                    
                )
                
            case .images:
                ImagesScreen(
                    matchedWords: matchedWords,
                    onRespond: {
                        withAnimation(.spring()) {
                            currentScreen = .responses
                        }
                    },
                    onReset: {
                        resetApp()
                    }
                )
                
            case .responses:
                ResponsesScreen(
                    speechManager: speechManager,
                    responseManager: responseManager,
                    questionType: questionType,
                    detectedCategory: detectedCategory,
                    onReset: {
                        resetApp()
                    }
                )
            }
        }
    }
    
    func resetApp() {
        isTransitioning = false
        speechManager.stopRecording()
        speechManager.spokenText = ""
        speechManager.keyWords = []
        responseManager.selectedResponse = nil
        
            currentScreen = .home
        
    }
}

// MARK: - Home Screen
struct HomeScreen: View {
    @ObservedObject var speechManager: SpeechManager
    let onSpeechComplete: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            // App title
            Text("Readyo")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.8))
            
            Spacer()
            
            // Microphone button
            Button(action: {
                if speechManager.isRecording {
                    speechManager.stopRecordingAndCancelTimer()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        onSpeechComplete()
                    }
                } else {
                    speechManager.startRecordingWithAutoStop {
                        onSpeechComplete()
                    }
                }
            }) {
                VStack(spacing: 20) {
                    ZStack {
                        // Static background circle
                        Circle()
                            .fill(speechManager.isRecording ?
                                Color.red.opacity(0.12) :
                                Color(red: 0.3, green: 0.6, blue: 0.9).opacity(0.12))
                            .frame(width: 220, height: 220)
                        
                        Circle()
                            .fill(speechManager.isRecording ?
                                Color.red.opacity(0.2) :
                                Color(red: 0.3, green: 0.6, blue: 0.9).opacity(0.2))
                            .frame(width: 170, height: 170)
                        
                        Image(systemName: speechManager.isRecording ?
                              "stop.circle.fill" : "mic.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(speechManager.isRecording ?
                                .red :
                                Color(red: 0.3, green: 0.6, blue: 0.9))
                    }
                    
                    // Status text like LLM typing indicator
                    if speechManager.isRecording {
                        HStack(spacing: 8) {
                            // Three dots indicator
                            ForEach(0..<3) { i in
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .opacity(0.7)
                            }
                            Text("Listening... tap to stop")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("Tap to Speak")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.8))
                    }
                }
            }
            // No animation modifier at all
            .scaleEffect(speechManager.isRecording ? 1.05 : 1.0)
            
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Images Screen
struct ImagesScreen: View {
    let matchedWords: [Word]
    let onRespond: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        let _ = print("🖼️ ImagesScreen loaded with \(matchedWords.count) words: \(matchedWords.map { $0.text })")
        VStack(spacing: 40) {
            
            Spacer()
            
            // Big keyword images
            HStack(spacing: 30) {
                ForEach(matchedWords) { word in
                    LargeWordCard(word: word)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Respond button
            Button(action: onRespond) {
                HStack(spacing: 15) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 28))
                    Text("Respond")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color(red: 0.3, green: 0.6, blue: 0.9))
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            
            // Reset button
            Button(action: onReset) {
                Text("Start Again")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

// MARK: - Responses Screen
struct ResponsesScreen: View {
    @ObservedObject var speechManager: SpeechManager
    @ObservedObject var responseManager: ResponseManager
    let questionType: QuestionType
    let detectedCategory: WordCategory
    let onReset: () -> Void
    
    private let library = WordLibrary.shared
    
    var closedResponses: [ResponseOption] {
        responseManager.generateResponses(for: speechManager.keyWords)
    }
    
    var openWords: [Word] {
        Array(library.words(for: detectedCategory).prefix(6))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            // Closed question — Yes/No/Maybe
            if questionType == .closed || questionType == .statement {
                HStack(spacing: 20) {
                    ForEach(closedResponses) { option in
                        LargeResponseCard(
                            option: option,
                            isSelected: responseManager.selectedResponse?.id == option.id
                        ) {
                            responseManager.selectedResponse = option
                            responseManager.speak(option.fullSentence)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Open question — category word grid
            if questionType == .open {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(openWords) { word in
                        OpenWordCard(word: word) {
                            let sentence = "I want \(word.text) please!"
                            responseManager.speak(sentence)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Selected response text
            if let selected = responseManager.selectedResponse {
                Text(selected.fullSentence)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(red: 0.3, green: 0.6, blue: 0.9))
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Start again button
            Button(action: onReset) {
                Text("Start Again")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

// MARK: - Large Word Card
struct LargeWordCard: View {
    let word: Word
    
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
        VStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(radius: 8)
                    .frame(width: 130, height: 130)
                
                if let uiImage = UIImage(named: word.imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 65))
                        .foregroundColor(cardColor)
                }
            }
            
            Text(word.text.capitalized)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.8))
        }
    }
}

// MARK: - Large Response Card
struct LargeResponseCard: View {
    let option: ResponseOption
    let isSelected: Bool
    let action: () -> Void
    
    var cardColor: Color {
        switch option.color {
        case "green":  return Color(red: 0.2, green: 0.7, blue: 0.4)
        case "red":    return Color(red: 0.9, green: 0.3, blue: 0.3)
        case "orange": return Color(red: 0.9, green: 0.6, blue: 0.2)
        default:       return .blue
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(isSelected ? cardColor : Color.white)
                        .frame(width: 110, height: 110)
                        .shadow(radius: isSelected ? 10 : 5)
                    
                    Image(systemName: option.symbolName)
                        .font(.system(size: 50))
                        .foregroundColor(isSelected ? .white : cardColor)
                }
                
                Text(option.text)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(cardColor)
                    .multilineTextAlignment(.center)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    ContentView()
}
