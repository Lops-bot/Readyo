import Foundation

// MARK: - Word Category
enum WordCategory: String, CaseIterable {
    case needs = "Basic Needs"
    case feelings = "Feelings"
    case food = "Food & Drink"
    case people = "People"
    case activities = "Activities"
    case places = "Places"
}

// MARK: - Word Model
struct Word: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let category: WordCategory
    let imageName: String  // Now uses real image names!
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Word Library
class WordLibrary {
    static let shared = WordLibrary()
    
    let allWords: [Word] = [
        
        // MARK: Basic Needs
        Word(text: "toilet",    category: .needs, imageName: "toilet"),
        Word(text: "water",     category: .needs, imageName: "water"),
        Word(text: "food",      category: .needs, imageName: "food"),
        Word(text: "hungry",    category: .needs, imageName: "hungry"),
        Word(text: "thirsty",   category: .needs, imageName: "thirsty"),
        Word(text: "tired",     category: .needs, imageName: "tired"),
        Word(text: "sleep",     category: .needs, imageName: "sleep"),
        Word(text: "medicine",  category: .needs, imageName: "medicine"),
        Word(text: "pain",      category: .needs, imageName: "pain"),
        Word(text: "hot",       category: .needs, imageName: "hot"),
        Word(text: "cold",      category: .needs, imageName: "cold"),
        Word(text: "help",      category: .needs, imageName: "help"),
        Word(text: "more",      category: .needs, imageName: "more"),
        Word(text: "finished",  category: .needs, imageName: "finished"),
        Word(text: "stop",      category: .needs, imageName: "stop"),
        Word(text: "go",        category: .needs, imageName: "go"),
        Word(text: "yes",       category: .needs, imageName: "yes"),
        Word(text: "no",        category: .needs, imageName: "no"),
        Word(text: "please",    category: .needs, imageName: "please"),
        Word(text: "thank you", category: .needs, imageName: "thank_you"),
        Word(text: "wash",      category: .needs, imageName: "wash"),
        Word(text: "hands",     category: .needs, imageName: "hands"),
        Word(text: "bath",      category: .needs, imageName: "bath"),
        Word(text: "brush",     category: .needs, imageName: "brush"),
        Word(text: "teeth",     category: .needs, imageName: "teeth"),
        Word(text: "dress",     category: .needs, imageName: "dress"),
        Word(text: "shoes",     category: .needs, imageName: "shoes"),
        Word(text: "outside",   category: .needs, imageName: "outside"),
        Word(text: "inside",    category: .needs, imageName: "inside"),
        Word(text: "home",      category: .needs, imageName: "home"),
        Word(text: "school",    category: .needs, imageName: "school"),
        Word(text: "bed",       category: .needs, imageName: "bed"),
        Word(text: "sit",       category: .needs, imageName: "sit"),
        Word(text: "stand",     category: .needs, imageName: "stand"),
        Word(text: "up",        category: .needs, imageName: "up"),
        Word(text: "down",      category: .needs, imageName: "down"),
        Word(text: "open",      category: .needs, imageName: "open"),
        Word(text: "close",     category: .needs, imageName: "close"),
        Word(text: "wait",      category: .needs, imageName: "wait"),
        Word(text: "hurry",     category: .needs, imageName: "hurry"),

        // MARK: Feelings
        Word(text: "happy",         category: .feelings, imageName: "happy"),
        Word(text: "sad",           category: .feelings, imageName: "sad"),
        Word(text: "angry",         category: .feelings, imageName: "angry"),
        Word(text: "scared",        category: .feelings, imageName: "scared"),
        Word(text: "worried",       category: .feelings, imageName: "worried"),
        Word(text: "excited",       category: .feelings, imageName: "excited"),
        Word(text: "bored",         category: .feelings, imageName: "bored"),
        Word(text: "confused",      category: .feelings, imageName: "confused"),
        Word(text: "surprised",     category: .feelings, imageName: "surprised"),
        Word(text: "proud",         category: .feelings, imageName: "proud"),
        Word(text: "lonely",        category: .feelings, imageName: "lonely"),
        Word(text: "silly",         category: .feelings, imageName: "silly"),
        Word(text: "calm",          category: .feelings, imageName: "calm"),
        Word(text: "upset",         category: .feelings, imageName: "upset"),
        Word(text: "frustrated",    category: .feelings, imageName: "frustrated"),
        Word(text: "loved",         category: .feelings, imageName: "loved"),
        Word(text: "safe",          category: .feelings, imageName: "safe"),
        Word(text: "uncomfortable", category: .feelings, imageName: "uncomfortable"),
        Word(text: "dizzy",         category: .feelings, imageName: "dizzy"),
        Word(text: "sick",          category: .feelings, imageName: "sick"),
        Word(text: "better",        category: .feelings, imageName: "better"),
        Word(text: "worse",         category: .feelings, imageName: "worse"),
        Word(text: "okay",          category: .feelings, imageName: "okay"),
        Word(text: "hurt",          category: .feelings, imageName: "hurt"),
        Word(text: "itchy",         category: .feelings, imageName: "itchy"),
        Word(text: "full",          category: .feelings, imageName: "full"),

        // MARK: Food & Drink
        Word(text: "ice cream",  category: .food, imageName: "ice_cream"),
        Word(text: "apple",      category: .food, imageName: "apple"),
        Word(text: "banana",     category: .food, imageName: "banana"),
        Word(text: "bread",      category: .food, imageName: "bread"),
        Word(text: "milk",       category: .food, imageName: "milk"),
        Word(text: "juice",      category: .food, imageName: "juice"),
        Word(text: "cookie",     category: .food, imageName: "cookie"),
        Word(text: "cake",       category: .food, imageName: "cake"),
        Word(text: "pizza",      category: .food, imageName: "pizza"),
        Word(text: "rice",       category: .food, imageName: "rice"),
        Word(text: "chicken",    category: .food, imageName: "chicken"),
        Word(text: "egg",        category: .food, imageName: "egg"),
        Word(text: "cheese",     category: .food, imageName: "cheese"),
        Word(text: "yogurt",     category: .food, imageName: "yogurt"),
        Word(text: "grapes",     category: .food, imageName: "grapes"),
        Word(text: "orange",     category: .food, imageName: "orange"),
        Word(text: "strawberry", category: .food, imageName: "strawberry"),
        Word(text: "carrot",     category: .food, imageName: "carrot"),
        Word(text: "biscuit",    category: .food, imageName: "biscuit"),
        Word(text: "chocolate",  category: .food, imageName: "chocolate"),
        Word(text: "lolly",      category: .food, imageName: "lolly"),
        Word(text: "chips",      category: .food, imageName: "chips"),
        Word(text: "sandwich",   category: .food, imageName: "sandwich"),
        Word(text: "pasta",      category: .food, imageName: "pasta"),
        Word(text: "cereal",     category: .food, imageName: "cereal"),
        Word(text: "soup",       category: .food, imageName: "soup"),
        Word(text: "pudding",    category: .food, imageName: "pudding"),
        Word(text: "muffin",     category: .food, imageName: "muffin"),
        Word(text: "toast",      category: .food, imageName: "toast"),
        Word(text: "butter",     category: .food, imageName: "butter"),
        Word(text: "jam",        category: .food, imageName: "jam"),
        Word(text: "honey",      category: .food, imageName: "honey"),
        Word(text: "tea",        category: .food, imageName: "tea"),
        Word(text: "snack",      category: .food, imageName: "snack"),
        Word(text: "lunch",      category: .food, imageName: "lunch"),
        Word(text: "dinner",     category: .food, imageName: "dinner"),
        Word(text: "breakfast",  category: .food, imageName: "breakfast"),
        Word(text: "treat",      category: .food, imageName: "treat"),
        Word(text: "drink",      category: .food, imageName: "drink"),

        // MARK: People
        Word(text: "mum",       category: .people, imageName: "mum"),
        Word(text: "dad",       category: .people, imageName: "dad"),
        Word(text: "baby",      category: .people, imageName: "baby"),
        Word(text: "brother",   category: .people, imageName: "brother"),
        Word(text: "sister",    category: .people, imageName: "sister"),
        Word(text: "teacher",   category: .people, imageName: "teacher"),
        Word(text: "friend",    category: .people, imageName: "friend"),
        Word(text: "doctor",    category: .people, imageName: "doctor"),
        Word(text: "nurse",     category: .people, imageName: "nurse"),
        Word(text: "grandma",   category: .people, imageName: "grandma"),
        Word(text: "grandpa",   category: .people, imageName: "grandpa"),
        Word(text: "helper",    category: .people, imageName: "helper"),
        Word(text: "boy",       category: .people, imageName: "boy"),
        Word(text: "girl",      category: .people, imageName: "girl"),
        Word(text: "man",       category: .people, imageName: "man"),
        Word(text: "woman",     category: .people, imageName: "woman"),
        Word(text: "family",    category: .people, imageName: "family"),
        Word(text: "everyone",  category: .people, imageName: "everyone"),
        Word(text: "nobody",    category: .people, imageName: "nobody"),
        Word(text: "person",    category: .people, imageName: "person"),
        Word(text: "aunty",     category: .people, imageName: "aunty"),
        Word(text: "uncle",     category: .people, imageName: "uncle"),

        // MARK: Activities
        Word(text: "play",    category: .activities, imageName: "play"),
        Word(text: "read",    category: .activities, imageName: "read"),
        Word(text: "draw",    category: .activities, imageName: "draw"),
        Word(text: "music",   category: .activities, imageName: "music"),
        Word(text: "ball",    category: .activities, imageName: "ball"),
        Word(text: "swim",    category: .activities, imageName: "swim"),
        Word(text: "run",     category: .activities, imageName: "run"),
        Word(text: "jump",    category: .activities, imageName: "jump"),
        Word(text: "dance",   category: .activities, imageName: "dance"),
        Word(text: "sing",    category: .activities, imageName: "sing"),
        Word(text: "watch",   category: .activities, imageName: "watch"),
        Word(text: "listen",  category: .activities, imageName: "listen"),
        Word(text: "hug",     category: .activities, imageName: "hug"),
        Word(text: "cuddle",  category: .activities, imageName: "cuddle"),
        Word(text: "laugh",   category: .activities, imageName: "laugh"),
        Word(text: "rest",    category: .activities, imageName: "rest"),
        Word(text: "walk",    category: .activities, imageName: "walk"),
        Word(text: "ride",    category: .activities, imageName: "ride"),
        Word(text: "build",   category: .activities, imageName: "build"),
        Word(text: "paint",   category: .activities, imageName: "paint"),
        Word(text: "color",   category: .activities, imageName: "color"),
        Word(text: "write",   category: .activities, imageName: "write"),
        Word(text: "count",   category: .activities, imageName: "count"),
        Word(text: "learn",   category: .activities, imageName: "learn"),
        Word(text: "share",   category: .activities, imageName: "share"),
        Word(text: "turn",    category: .activities, imageName: "turn"),
        Word(text: "push",    category: .activities, imageName: "push"),
        Word(text: "pull",    category: .activities, imageName: "pull"),
        Word(text: "throw",   category: .activities, imageName: "throw"),
        Word(text: "catch",   category: .activities, imageName: "catch"),
        Word(text: "climb",   category: .activities, imageName: "climb"),
        Word(text: "dig",     category: .activities, imageName: "dig"),
        Word(text: "pour",    category: .activities, imageName: "pour"),
        Word(text: "cut",     category: .activities, imageName: "cut"),
        Word(text: "stick",   category: .activities, imageName: "stick"),
        Word(text: "fold",    category: .activities, imageName: "fold"),
        Word(text: "sort",    category: .activities, imageName: "sort"),
        Word(text: "match",   category: .activities, imageName: "match"),
        Word(text: "clap",    category: .activities, imageName: "clap"),
        Word(text: "wave",    category: .activities, imageName: "wave"),

        // MARK: Places
        Word(text: "home",        category: .places, imageName: "home"),
        Word(text: "school",      category: .places, imageName: "school"),
        Word(text: "bathroom",    category: .places, imageName: "bathroom"),
        Word(text: "bedroom",     category: .places, imageName: "bedroom"),
        Word(text: "kitchen",     category: .places, imageName: "kitchen"),
        Word(text: "garden",      category: .places, imageName: "garden"),
        Word(text: "park",        category: .places, imageName: "park"),
        Word(text: "car",         category: .places, imageName: "car"),
        Word(text: "bus",         category: .places, imageName: "bus"),
        Word(text: "shop",        category: .places, imageName: "shop"),
        Word(text: "hospital",    category: .places, imageName: "hospital"),
        Word(text: "playground",  category: .places, imageName: "playground"),
        Word(text: "classroom",   category: .places, imageName: "classroom"),
        Word(text: "library",     category: .places, imageName: "library"),
        Word(text: "church",      category: .places, imageName: "church"),
        Word(text: "pool",        category: .places, imageName: "pool"),
        Word(text: "beach",       category: .places, imageName: "beach"),
        Word(text: "farm",        category: .places, imageName: "farm"),
        Word(text: "zoo",         category: .places, imageName: "zoo"),
        Word(text: "restaurant",  category: .places, imageName: "restaurant"),
        Word(text: "toilet",      category: .places, imageName: "toilet"),
        Word(text: "office",      category: .places, imageName: "office"),
        Word(text: "hall",        category: .places, imageName: "hall"),
        Word(text: "stairs",      category: .places, imageName: "stairs"),
        Word(text: "door",        category: .places, imageName: "door"),
        Word(text: "window",      category: .places, imageName: "window"),
        Word(text: "chair",       category: .places, imageName: "chair"),
        Word(text: "table",       category: .places, imageName: "table"),
        Word(text: "bed",         category: .places, imageName: "bed"),
        Word(text: "couch",       category: .places, imageName: "couch"),
        Word(text: "sewing",      category: .places, imageName: "sewing"),
        Word(text: "backyard",    category: .places, imageName: "backyard"),
    ]
    
    // Find words matching keywords
    func findWords(matching keywords: [String]) -> [Word] {
        return keywords.compactMap { keyword in
            // Try exact match first
            if let exact = allWords.first(where: { $0.text.lowercased() == keyword.lowercased() }) {
                return exact
            }
            // Try partial match as fallback
            return allWords.first(where: { $0.text.lowercased().contains(keyword.lowercased()) || keyword.lowercased().contains($0.text.lowercased()) })
        }
    }
    
    // Get words by category
    func words(for category: WordCategory) -> [Word] {
        return allWords.filter { $0.category == category }
    }
}
