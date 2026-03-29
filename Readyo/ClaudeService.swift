import Foundation

class ClaudeService {
    static let shared = ClaudeService()
    
    private let apiURL = "https://api.anthropic.com/v1/messages"
    
    // MARK: - Simplify parent speech into keywords
    func extractKeywords(from text: String) async -> [String] {
        let prompt = """
        You are helping a child with a speech delay communicate using picture symbols.

        A parent said: "\(text)"

        Extract 1-3 keywords that match EXACTLY these available picture categories:
        - Feelings: happy, sad, angry, scared, worried, excited, bored, confused, surprised, proud, lonely, silly, calm, dizzy, sick, hurt
        - Food: ice cream, apple, banana, bread, milk, juice, cookie, cake, pizza, rice, chicken, egg, cheese, yogurt, grapes, orange, strawberry, carrot, chocolate, chips, sandwich, pasta, cereal, soup, toast, tea, snack, lunch, dinner, breakfast, drink
        - Needs: toilet, water, food, hungry, thirsty, tired, sleep, medicine, pain, hot, cold, help, more, finished, stop, go, yes, no, please, thank you, wash, bath, brush, teeth, dress, shoes, outside, inside, home, school, bed, sit, stand, wait
        - Activities: play, read, draw, music, ball, swim, run, jump, dance, sing, watch, listen, hug, cuddle, laugh, rest, walk, ride, build, paint, write, count, learn, share, clap, wave
        - People: mum, dad, baby, brother, sister, teacher, friend, doctor, nurse, grandma, grandpa, boy, girl, family, aunty, uncle
        - Places: home, school, bathroom, bedroom, kitchen, garden, park, car, bus, shop, hospital, playground, beach, farm, zoo, restaurant, backyard

        Rules:
        - ONLY return words from the lists above
        - Maximum 3 words
        - For feeling questions return 3-4 feeling words
        - Return ONLY the words separated by commas, nothing else

        Examples:
        "Do you want some ice cream?" → ice cream
        "Are you feeling hungry?" → hungry
        "How are you feeling?" → happy, sad, angry, scared
        "Would you like to go somewhere?" → park, school, home, beach
        "What do you want to eat?" → ice cream, pizza, sandwich, apple
        """
        
        let response = await callClaude(prompt: prompt)
        
        // Parse comma separated words
        let keywords = response
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }
        
        print("🤖 Claude keywords: \(keywords)")
        return keywords
    }
    
    // MARK: - Generate natural child response
    func generateResponse(for keyword: String, response: String) async -> String {
        let prompt = """
        You are speaking as a child with a speech delay who uses an AAC device.
        
        The topic is: \(keyword)
        The child's choice is: \(response)
        
        Generate ONE short, natural sentence the child would say.
        
        Rules:
        - Maximum 10 words
        - Simple child friendly language
        - First person (I want, I feel, I need)
        - Warm and natural tone
        - No punctuation except period at end
        
        Examples:
        topic: ice cream, choice: yes → I would really love some ice cream please.
        topic: toilet, choice: yes → Yes I need to go to the toilet now.
        topic: happy, choice: yes → I am feeling really happy today.
        topic: park, choice: no → No thank you I do not want to go to the park.
        
        Return ONLY the sentence, nothing else.
        """
        
        let response = await callClaude(prompt: prompt)
        print("🤖 Claude response: \(response)")
        return response
    }
    
    // MARK: - Detect question type
    func detectQuestionType(from text: String) async -> QuestionType {
        let prompt = """
        Analyse this question a parent asked their child:
        "\(text)"
        
        Is this a closed question (yes/no answer) or open question (choice needed)?
        
        Return ONLY one word: "closed" or "open"
        
        Examples:
        "Do you want ice cream?" → closed
        "Are you hungry?" → closed
        "What do you want to eat?" → open
        "Where do you want to go?" → open
        "How are you feeling?" → open
        """
        
        let result = await callClaude(prompt: prompt)
        let trimmed = result.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        print("🤖 Claude question type: \(trimmed)")
        return trimmed.contains("open") ? .open : .closed
    }
    
    // MARK: - Core API call
    private func callClaude(prompt: String) async -> String {
        guard let url = URL(string: apiURL) else { return "" }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.claudeAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let body: [String: Any] = [
            "model": Config.claudeModel,
            "max_tokens": 100,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let content = json["content"] as? [[String: Any]],
               let text = content.first?["text"] as? String {
                return text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            print("❌ Claude API error: \(error)")
        }
        
        return ""
    }
}

