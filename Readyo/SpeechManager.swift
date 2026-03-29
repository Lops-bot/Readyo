import Foundation
import Combine
import Speech
import AVFoundation

private var didComplete: Bool = false
// MARK: - Question Type
enum QuestionType {
    case closed
    case open
    case statement
}

// MARK: - Speech Manager
class SpeechManager: ObservableObject {
    @Published var spokenText: String = ""
    @Published var keyWords: [String] = []
    @Published var isRecording: Bool = false
    @Published var keyWordsReady: Bool = false
    @Published var isProcessing: Bool = false
    
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var silenceTimer: Timer?
    private var autoStopCompletion: (() -> Void)?
    private var didComplete: Bool = false
    
    // Words to ignore when extracting keywords
    private let stopWords = ["the", "a", "an", "is", "are", "was", "were",
                            "i", "you", "he", "she", "it", "we", "they",
                            "want", "need", "can", "please", "to", "do",
                            "my", "your", "his", "her", "our", "their",
                            "and", "or", "but", "in", "on", "at", "for",
                            "what", "where", "who", "which", "how",
                            "did", "does", "would", "could", "should",
                            "like", "some", "any", "this", "that"]
    
    // MARK: - Public Recording Controls
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            requestPermissions()
        }
    }
    
    func startRecordingWithAutoStop(completion: @escaping () -> Void) {
        autoStopCompletion = completion
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self?.startRecordingWithSilenceDetection()
                }
            }
        }
    }
    
    // MARK: - Private Recording Controls
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self?.startRecording()
                }
            }
        }
    }
    
    private func startRecording() {
        spokenText = ""
        keyWords = []
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.taskHint = .dictation
        recognitionRequest.addsPunctuation = false

        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self?.spokenText = result.bestTranscription.formattedString
                    self?.extractKeyWords(from: result.bestTranscription.formattedString)
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        isRecording = true
    }
    
    private func startRecordingWithSilenceDetection() {
        spokenText = ""
        keyWords = []
        didComplete = false
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let result = result {
                    let heard = result.bestTranscription.formattedString
                    if !heard.isEmpty {
                        self.spokenText = heard
                        print("🎤 Heard: \(self.spokenText)")
                    }
                    
                    // isFinal means Apple is done recognizing
                    if result.isFinal {
                        print("✅ Final result: \(self.spokenText)")
                        self.stopRecording()
                        self.extractKeyWords(from: self.spokenText)
                        if !self.didComplete {
                            self.didComplete = true
                            self.autoStopCompletion?()
                        }
                    }
                }
                
                // Handle errors gracefully
                if let error = error {
                    let errorCode = (error as NSError).code
                    // Code 1110 = No speech, Code 216 = Canceled — both are harmless
                    let harmlessCodes = [1110, 216, 203]
                    if !harmlessCodes.contains(errorCode) {
                        print("❌ Real error: \(error.localizedDescription)")
                    }
                    // Always try to use what we heard
                    if !self.didComplete && !self.spokenText.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            if !self.didComplete {
                                self.extractKeyWords(from: self.spokenText)
                                self.stopRecording()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if !self.didComplete {
                                        self.didComplete = true
                                        self.autoStopCompletion?()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        isRecording = true
        
        // Safety timer — stops after 10 seconds regardless
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.extractKeyWords(from: self.spokenText)
            self.stopRecording()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if !self.didComplete {
                    self.didComplete = true
                    self.autoStopCompletion?()
                }
            }
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
    }

    func stopRecordingAndCancelTimer() {
        silenceTimer?.invalidate()
        silenceTimer = nil
        stopRecording()
    }
    
    // MARK: - Keyword Extraction
    private func extractKeyWords(from text: String) {
        Task {
            print("🔄 Calling Claude with: \(text)")
            let keywords = await ClaudeService.shared.extractKeywords(from: text)
            print("🔄 Claude returned: \(keywords)")
            await MainActor.run {
                if !keywords.isEmpty {
                    self.keyWords = keywords
                    print("🤖 Claude extracted: \(keywords)")
                } else {
                    self.basicExtractKeyWords(from: text)
                }
                // Notify that keywords are ready
                self.isProcessing = false
                self.keyWordsReady = true
            }
        }
    }

    // Fallback basic extraction
    private func basicExtractKeyWords(from text: String) {
        let stopWords = ["the", "a", "an", "is", "are", "was", "were",
                        "i", "you", "he", "she", "it", "we", "they",
                        "want", "need", "can", "please", "to", "do",
                        "my", "your", "his", "her", "our", "their",
                        "and", "or", "but", "in", "on", "at", "for",
                        "what", "where", "who", "which", "how",
                        "did", "does", "would", "could", "should",
                        "like", "some", "any", "this", "that"]
        
        let words = text.lowercased()
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .filter { !stopWords.contains($0) }
        
        var seen = Set<String>()
        let filtered = words.filter { seen.insert($0).inserted }
        keyWords = Array(filtered.prefix(3))
    }
    
    // MARK: - Question Detection
    func detectQuestionType(from text: String) -> QuestionType {
        // Basic detection as fallback
        let lowered = text.lowercased()
        
        let openWords = ["what", "where", "who", "which",
                        "show me", "choose", "pick", "select",
                        "what do you want", "what would you like",
                        "where do you want", "who do you want"]
        
        let closedWords = ["do you", "are you", "is it", "would you",
                          "can you", "have you", "did you", "will you",
                          "do you want", "are you hungry", "are you tired",
                          "would you like", "do you need"]
        
        for word in openWords {
            if lowered.contains(word) { return .open }
        }
        
        for word in closedWords {
            if lowered.contains(word) { return .closed }
        }
        
        return .statement
    }

    // Async Claude version
    func detectQuestionTypeWithClaude(from text: String) async -> QuestionType {
        return await ClaudeService.shared.detectQuestionType(from: text)
    }
    
    // MARK: - Category Detection
    func detectCategory(from text: String) -> WordCategory? {
        let lowered = text.lowercased()
        
        if lowered.contains("feel") || lowered.contains("feeling") ||
           lowered.contains("emotion") || lowered.contains("mood") ||
           lowered.contains("happy") || lowered.contains("sad") ||
           lowered.contains("angry") || lowered.contains("scared") {
            return .feelings
        }
        
        if lowered.contains("drink") || lowered.contains("eat") ||
           lowered.contains("food") || lowered.contains("hungry") ||
           lowered.contains("thirsty") || lowered.contains("snack") ||
           lowered.contains("lunch") || lowered.contains("dinner") ||
           lowered.contains("breakfast") {
            return .food
        }
        
        if lowered.contains("go") || lowered.contains("where") ||
           lowered.contains("place") || lowered.contains("room") ||
           lowered.contains("outside") || lowered.contains("inside") {
            return .places
        }
        
        if lowered.contains("play") || lowered.contains("do") ||
           lowered.contains("activity") || lowered.contains("want to") ||
           lowered.contains("like to") {
            return .activities
        }
        
        if lowered.contains("who") || lowered.contains("person") ||
           lowered.contains("people") || lowered.contains("with") ||
           lowered.contains("friend") || lowered.contains("family") {
            return .people
        }
        
        return .needs
    }
}
