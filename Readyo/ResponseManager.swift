import Foundation
import Combine
import AVFoundation

// MARK: - Response Option
struct ResponseOption: Identifiable {
    let id = UUID()
    let text: String
    let symbolName: String
    let color: String
    let fullSentence: String
}


// MARK: - Response Manager
class ResponseManager: ObservableObject {
    @Published var selectedResponse: ResponseOption? = nil
    
    private let synthesizer = AVSpeechSynthesizer()
    @Published var selectedResponseText: String = ""
    
    // Generate 3 response options based on detected keywords
    func generateResponses(for keywords: [String]) -> [ResponseOption] {
        guard !keywords.isEmpty else { return defaultResponses() }
        
        let keyword = keywords.first ?? ""
        
        return [
            ResponseOption(
                text: "Yes Please",
                symbolName: "hand.thumbsup.fill",
                color: "green",
                fullSentence: buildSentence(response: "yes", keyword: keyword)
            ),
            ResponseOption(
                text: "No Thanks",
                symbolName: "hand.thumbsdown.fill",
                color: "red",
                fullSentence: buildSentence(response: "no", keyword: keyword)
            ),
            ResponseOption(
                text: "Maybe Later",
                symbolName: "clock.fill",
                color: "orange",
                fullSentence: buildSentence(response: "later", keyword: keyword)
            )
        ]
    }
    
    // Build natural sentence from response + keyword
    private func buildSentence(response: String, keyword: String) -> String {
        switch response {
        case "yes":
            return sentenceForYes(keyword: keyword)
        case "no":
            return sentenceForNo(keyword: keyword)
        case "later":
            return sentenceForLater(keyword: keyword)
        default:
            return "Okay!"
        }
    }
    
    private func sentenceForYes(keyword: String) -> String {
        switch keyword {
        case "food", "eat", "hungry":
            return "Yes please, I am hungry and would like some food!"
        case "icecream":
            return "Yes please, I would love some ice cream!"
        case "water", "drink", "thirsty":
            return "Yes please, I am thirsty and would like some water!"
        case "toilet", "bathroom":
            return "Yes, I need to go to the toilet please!"
        case "sleep", "tired", "bed":
            return "Yes, I am tired and would like to sleep!"
        case "play":
            return "Yes please, I would love to play!"
        case "help":
            return "Yes please, I need some help!"
        case "hug", "cuddle":
            return "Yes please, I would love a hug!"
        case "home":
            return "Yes, I would like to go home please!"
        case "school":
            return "Yes, I am ready to go to school!"
        case "medicine":
            return "Yes, I will take my medicine now!"
        case "bath":
            return "Yes, I am ready for my bath!"
        case "happy":
            return "Yes, I am feeling happy!"
        case "sad":
            return "Yes, I am feeling a bit sad!"
        case "pain", "hurt":
            return "Yes, I am feeling some pain and need help!"
        default:
            return "Yes please, I would like \(keyword)!"
        }
    }
    
    private func sentenceForNo(keyword: String) -> String {
        switch keyword {
        case "food", "eat", "hungry":
            return "No thank you, I am not hungry right now!"
        case "icecream":
            return "No thank you, I do not want ice cream right now!"
        case "water", "drink", "thirsty":
            return "No thank you, I am not thirsty right now!"
        case "toilet", "bathroom":
            return "No thank you, I do not need the toilet right now!"
        case "sleep", "tired", "bed":
            return "No thank you, I am not tired right now!"
        case "play":
            return "No thank you, I do not want to play right now!"
        case "help":
            return "No thank you, I do not need help right now!"
        case "hug", "cuddle":
            return "No thank you, I do not want a hug right now!"
        case "home":
            return "No thank you, I do not want to go home yet!"
        case "medicine":
            return "No, I do not want my medicine right now!"
        case "bath":
            return "No thank you, I do not want a bath right now!"
        default:
            return "No thank you, I do not want \(keyword) right now!"
        }
    }
    
    private func sentenceForLater(keyword: String) -> String {
        switch keyword {
        case "food", "eat", "hungry":
            return "Maybe later, I will eat something soon!"
        case "icecream":
            return "Maybe later, I will have ice cream another time!"
        case "water", "drink", "thirsty":
            return "Maybe later, I will have a drink soon!"
        case "toilet", "bathroom":
            return "Maybe later, I will go to the toilet soon!"
        case "sleep", "tired", "bed":
            return "Maybe later, I will go to sleep soon!"
        case "play":
            return "Maybe later, I will play soon!"
        case "help":
            return "Maybe later, I will ask for help soon!"
        case "hug", "cuddle":
            return "Maybe later, I would like a hug soon!"
        case "bath":
            return "Maybe later, I will have a bath soon!"
        default:
            return "Maybe later, I will think about \(keyword)!"
        }
    }
    
    // Default responses when no keyword detected
    private func defaultResponses() -> [ResponseOption] {
        return [
            ResponseOption(
                text: "Yes Please",
                symbolName: "hand.thumbsup.fill",
                color: "green",
                fullSentence: "Yes please, I would like that!"
            ),
            ResponseOption(
                text: "No Thanks",
                symbolName: "hand.thumbsdown.fill",
                color: "red",
                fullSentence: "No thank you, not right now!"
            ),
            ResponseOption(
                text: "Maybe Later",
                symbolName: "clock.fill",
                color: "orange",
                fullSentence: "Maybe later, I will think about it!"
            )
        ]
    }
    func generateAndSpeak(keyword: String, response: String) {
        Task {
            let sentence = await ClaudeService.shared.generateResponse(
                for: keyword,
                response: response
            )
            await MainActor.run {
                self.selectedResponseText = sentence.isEmpty ?
                    "I would like \(keyword) please." : sentence
                self.speak(self.selectedResponseText)
            }
        }
    }
    
    // Speak the selected response out loud
    func speak(_ text: String) {
        do {
                try AVAudioSession.sharedInstance().setCategory(
                    .playback,
                    mode: .spokenAudio,
                    options: .duckOthers
                )
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio error: \(error)")
            }
            
          
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        
        let preferredVoices = [
            "com.apple.ttsbundle.Allison-premium",
            "com.apple.ttsbundle.Allison-compact",
            "com.apple.voice.enhanced.en-US.Allison",
            "com.apple.voice.premium.en-US.Samantha",
            "com.apple.voice.enhanced.en-US.Samantha"
        ]
        
        var selectedVoice: AVSpeechSynthesisVoice? = nil
        for voiceID in preferredVoices {
            if let voice = AVSpeechSynthesisVoice(identifier: voiceID) {
                selectedVoice = voice
                break
            }
        }
        
        if selectedVoice == nil {
            selectedVoice = AVSpeechSynthesisVoice(language: "en-AU")
        }
        
        utterance.voice = selectedVoice
        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.15
        utterance.volume = 1.0
        utterance.preUtteranceDelay = 0.0
        
        synthesizer.speak(utterance)
    }

    // Pre-warm audio session
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .spokenAudio,
                options: .duckOthers
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session init error: \(error)")
        }
    }
}
