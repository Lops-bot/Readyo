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
    let symbolName: String // SF Symbol name
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Word Library
class WordLibrary {
    static let shared = WordLibrary()
    
    let allWords: [Word] = [
        
        // MARK: Basic Needs
        Word(text: "toilet",    category: .needs, symbolName: "toilet"),
        Word(text: "water",     category: .needs, symbolName: "drop.fill"),
        Word(text: "food",      category: .needs, symbolName: "fork.knife"),
        Word(text: "hungry",    category: .needs, symbolName: "fork.knife.circle"),
        Word(text: "thirsty",   category: .needs, symbolName: "drop"),
        Word(text: "tired",     category: .needs, symbolName: "moon.fill"),
        Word(text: "sleep",     category: .needs, symbolName: "bed.double.fill"),
        Word(text: "medicine",  category: .needs, symbolName: "pills.fill"),
        Word(text: "pain",      category: .needs, symbolName: "bandage.fill"),
        Word(text: "hot",       category: .needs, symbolName: "thermometer.sun.fill"),
        Word(text: "cold",      category: .needs, symbolName: "snowflake"),
        Word(text: "help",      category: .needs, symbolName: "hand.raised.fill"),
        Word(text: "more",      category: .needs, symbolName: "plus.circle.fill"),
        Word(text: "finished",  category: .needs, symbolName: "checkmark.circle.fill"),
        Word(text: "stop",      category: .needs, symbolName: "stop.circle.fill"),
        Word(text: "go",        category: .needs, symbolName: "arrow.forward.circle.fill"),
        Word(text: "yes",       category: .needs, symbolName: "hand.thumbsup.fill"),
        Word(text: "no",        category: .needs, symbolName: "hand.thumbsdown.fill"),
        Word(text: "please",    category: .needs, symbolName: "heart.fill"),
        Word(text: "thankyou",  category: .needs, symbolName: "hands.clap.fill"),
        Word(text: "wash",      category: .needs, symbolName: "hands.sparkles.fill"),
        Word(text: "hands",     category: .needs, symbolName: "hand.raised"),
        Word(text: "bath",      category: .needs, symbolName: "bathtub.fill"),
        Word(text: "brush",     category: .needs, symbolName: "mouth.fill"),
        Word(text: "teeth",     category: .needs, symbolName: "mouth"),
        Word(text: "dress",     category: .needs, symbolName: "tshirt.fill"),
        Word(text: "shoes",     category: .needs, symbolName: "shoeprints.fill"),
        Word(text: "outside",   category: .needs, symbolName: "sun.max.fill"),
        Word(text: "inside",    category: .needs, symbolName: "house.fill"),
        Word(text: "home",      category: .needs, symbolName: "house.fill"),
        Word(text: "school",    category: .needs, symbolName: "building.columns.fill"),
        Word(text: "bed",       category: .needs, symbolName: "bed.double.fill"),
        Word(text: "sit",       category: .needs, symbolName: "chair.fill"),
        Word(text: "stand",     category: .needs, symbolName: "figure.stand"),
        Word(text: "up",        category: .needs, symbolName: "arrow.up.circle.fill"),
        Word(text: "down",      category: .needs, symbolName: "arrow.down.circle.fill"),
        Word(text: "open",      category: .needs, symbolName: "door.left.hand.open"),
        Word(text: "close",     category: .needs, symbolName: "door.left.hand.closed"),
        Word(text: "wait",      category: .needs, symbolName: "clock.fill"),
        Word(text: "hurry",     category: .needs, symbolName: "hare.fill"),

        // MARK: Feelings
        Word(text: "happy",         category: .feelings, symbolName: "face.smiling.inverse"),
        Word(text: "sad",           category: .feelings, symbolName: "cloud.rain.fill"),
        Word(text: "angry",         category: .feelings, symbolName: "flame.fill"),
        Word(text: "scared",        category: .feelings, symbolName: "exclamationmark.triangle.fill"),
        Word(text: "worried",       category: .feelings, symbolName: "questionmark.circle.fill"),
        Word(text: "excited",       category: .feelings, symbolName: "star.fill"),
        Word(text: "bored",         category: .feelings, symbolName: "zzz"),
        Word(text: "confused",      category: .feelings, symbolName: "questionmark.bubble.fill"),
        Word(text: "surprised",     category: .feelings, symbolName: "exclamationmark.bubble.fill"),
        Word(text: "proud",         category: .feelings, symbolName: "trophy.fill"),
        Word(text: "lonely",        category: .feelings, symbolName: "person.fill.xmark"),
        Word(text: "silly",         category: .feelings, symbolName: "face.dashed"),
        Word(text: "calm",          category: .feelings, symbolName: "leaf.fill"),
        Word(text: "upset",         category: .feelings, symbolName: "cloud.bolt.fill"),
        Word(text: "frustrated",    category: .feelings, symbolName: "bolt.circle.fill"),
        Word(text: "loved",         category: .feelings, symbolName: "heart.fill"),
        Word(text: "safe",          category: .feelings, symbolName: "shield.fill"),
        Word(text: "uncomfortable", category: .feelings, symbolName: "x.circle.fill"),
        Word(text: "dizzy",         category: .feelings, symbolName: "circle.dotted"),
        Word(text: "sick",          category: .feelings, symbolName: "cross.fill"),
        Word(text: "better",        category: .feelings, symbolName: "arrow.up.heart.fill"),
        Word(text: "worse",         category: .feelings, symbolName: "arrow.down.heart.fill"),
        Word(text: "okay",          category: .feelings, symbolName: "checkmark.seal.fill"),
        Word(text: "hurt",          category: .feelings, symbolName: "bandage.fill"),
        Word(text: "itchy",         category: .feelings, symbolName: "hand.point.up.left.fill"),
        Word(text: "full",          category: .feelings, symbolName: "circle.fill"),

        // MARK: Food & Drink
        Word(text: "ice cream",   category: .food, symbolName: "birthday.cake.fill"),
        Word(text: "apple",      category: .food, symbolName: "apple.logo"),
        Word(text: "banana",     category: .food, symbolName: "fork.knife"),
        Word(text: "bread",      category: .food, symbolName: "loaf.fill"),
        Word(text: "milk",       category: .food, symbolName: "cup.and.saucer.fill"),
        Word(text: "juice",      category: .food, symbolName: "waterbottle.fill"),
        Word(text: "cookie",     category: .food, symbolName: "circle.fill"),
        Word(text: "cake",       category: .food, symbolName: "birthday.cake.fill"),
        Word(text: "pizza",      category: .food, symbolName: "fork.knife.circle.fill"),
        Word(text: "rice",       category: .food, symbolName: "fork.knife"),
        Word(text: "chicken",    category: .food, symbolName: "fork.knife"),
        Word(text: "egg",        category: .food, symbolName: "oval.fill"),
        Word(text: "cheese",     category: .food, symbolName: "triangle.fill"),
        Word(text: "yogurt",     category: .food, symbolName: "cup.and.saucer"),
        Word(text: "grapes",     category: .food, symbolName: "circle.grid.3x3.fill"),
        Word(text: "orange",     category: .food, symbolName: "circle.fill"),
        Word(text: "strawberry", category: .food, symbolName: "heart.fill"),
        Word(text: "carrot",     category: .food, symbolName: "triangle.fill"),
        Word(text: "biscuit",    category: .food, symbolName: "circle"),
        Word(text: "chocolate",  category: .food, symbolName: "square.fill"),
        Word(text: "lolly",      category: .food, symbolName: "star.fill"),
        Word(text: "chips",      category: .food, symbolName: "rectangle.fill"),
        Word(text: "sandwich",   category: .food, symbolName: "square.stack.fill"),
        Word(text: "pasta",      category: .food, symbolName: "fork.knife"),
        Word(text: "cereal",     category: .food, symbolName: "bowl.fill"),
        Word(text: "soup",       category: .food, symbolName: "bowl.fill"),
        Word(text: "pudding",    category: .food, symbolName: "cup.and.saucer.fill"),
        Word(text: "muffin",     category: .food, symbolName: "circle.fill"),
        Word(text: "toast",      category: .food, symbolName: "rectangle.fill"),
        Word(text: "butter",     category: .food, symbolName: "square"),
        Word(text: "jam",        category: .food, symbolName: "heart"),
        Word(text: "honey",      category: .food, symbolName: "drop.fill"),
        Word(text: "tea",        category: .food, symbolName: "cup.and.saucer.fill"),
        Word(text: "snack",      category: .food, symbolName: "hand.thumbsup.fill"),
        Word(text: "lunch",      category: .food, symbolName: "fork.knife"),
        Word(text: "dinner",     category: .food, symbolName: "fork.knife.circle"),
        Word(text: "breakfast",  category: .food, symbolName: "sunrise.fill"),
        Word(text: "treat",      category: .food, symbolName: "gift.fill"),
        Word(text: "drink",      category: .food, symbolName: "cup.and.saucer"),

        // MARK: People
        Word(text: "mum",       category: .people, symbolName: "figure.and.child.holdinghands"),
        Word(text: "dad",       category: .people, symbolName: "figure.wave"),
        Word(text: "baby",      category: .people, symbolName: "figure.roll"),
        Word(text: "brother",   category: .people, symbolName: "person.fill"),
        Word(text: "sister",    category: .people, symbolName: "person.fill"),
        Word(text: "teacher",   category: .people, symbolName: "person.bust"),
        Word(text: "friend",    category: .people, symbolName: "person.2.fill"),
        Word(text: "doctor",    category: .people, symbolName: "stethoscope"),
        Word(text: "nurse",     category: .people, symbolName: "cross.fill"),
        Word(text: "grandma",   category: .people, symbolName: "figure.walk"),
        Word(text: "grandpa",   category: .people, symbolName: "figure.walk.circle"),
        Word(text: "helper",    category: .people, symbolName: "hand.raised.fill"),
        Word(text: "boy",       category: .people, symbolName: "figure.stand"),
        Word(text: "girl",      category: .people, symbolName: "figure.dress.line.vertical.figure"),
        Word(text: "man",       category: .people, symbolName: "person.fill"),
        Word(text: "woman",     category: .people, symbolName: "person.fill"),
        Word(text: "family",    category: .people, symbolName: "house.fill"),
        Word(text: "everyone",  category: .people, symbolName: "person.3.fill"),
        Word(text: "nobody",    category: .people, symbolName: "person.fill.xmark"),
        Word(text: "person",    category: .people, symbolName: "person.circle.fill"),
        Word(text: "aunty",     category: .people, symbolName: "person.fill"),
        Word(text: "uncle",     category: .people, symbolName: "person.fill"),

        // MARK: Activities
        Word(text: "play",    category: .activities, symbolName: "gamecontroller.fill"),
        Word(text: "read",    category: .activities, symbolName: "book.fill"),
        Word(text: "draw",    category: .activities, symbolName: "pencil.circle.fill"),
        Word(text: "music",   category: .activities, symbolName: "music.note"),
        Word(text: "ball",    category: .activities, symbolName: "soccerball"),
        Word(text: "swim",    category: .activities, symbolName: "figure.pool.swim"),
        Word(text: "run",     category: .activities, symbolName: "figure.run"),
        Word(text: "jump",    category: .activities, symbolName: "figure.jumprope"),
        Word(text: "dance",   category: .activities, symbolName: "figure.dance"),
        Word(text: "sing",    category: .activities, symbolName: "music.mic"),
        Word(text: "watch",   category: .activities, symbolName: "tv.fill"),
        Word(text: "listen",  category: .activities, symbolName: "ear.fill"),
        Word(text: "hug",     category: .activities, symbolName: "figure.2.arms.open"),
        Word(text: "cuddle",  category: .activities, symbolName: "heart.circle.fill"),
        Word(text: "laugh",   category: .activities, symbolName: "face.smiling"),
        Word(text: "rest",    category: .activities, symbolName: "bed.double"),
        Word(text: "walk",    category: .activities, symbolName: "figure.walk"),
        Word(text: "ride",    category: .activities, symbolName: "bicycle"),
        Word(text: "build",   category: .activities, symbolName: "hammer.fill"),
        Word(text: "paint",   category: .activities, symbolName: "paintbrush.fill"),
        Word(text: "color",   category: .activities, symbolName: "paintpalette.fill"),
        Word(text: "write",   category: .activities, symbolName: "pencil"),
        Word(text: "count",   category: .activities, symbolName: "number.circle.fill"),
        Word(text: "learn",   category: .activities, symbolName: "graduationcap.fill"),
        Word(text: "share",   category: .activities, symbolName: "arrow.2.squarepath"),
        Word(text: "turn",    category: .activities, symbolName: "arrow.turn.right.up"),
        Word(text: "push",    category: .activities, symbolName: "arrow.forward.circle"),
        Word(text: "pull",    category: .activities, symbolName: "arrow.backward.circle"),
        Word(text: "throw",   category: .activities, symbolName: "figure.throw"),
        Word(text: "catch",   category: .activities, symbolName: "hands.clap"),
        Word(text: "climb",   category: .activities, symbolName: "figure.climbing"),
        Word(text: "dig",     category: .activities, symbolName: "shovel.fill"),
        Word(text: "pour",    category: .activities, symbolName: "drop.circle.fill"),
        Word(text: "cut",     category: .activities, symbolName: "scissors"),
        Word(text: "stick",   category: .activities, symbolName: "square.on.square.fill"),
        Word(text: "fold",    category: .activities, symbolName: "rectangle.fill"),
        Word(text: "sort",    category: .activities, symbolName: "line.3.horizontal.decrease.circle"),
        Word(text: "match",   category: .activities, symbolName: "equal.circle.fill"),
        Word(text: "clap",    category: .activities, symbolName: "hands.clap.fill"),
        Word(text: "wave",    category: .activities, symbolName: "hand.wave.fill"),

        // MARK: Places
        Word(text: "home",        category: .places, symbolName: "house.fill"),
        Word(text: "school",      category: .places, symbolName: "building.columns.fill"),
        Word(text: "bathroom",    category: .places, symbolName: "toilet.fill"),
        Word(text: "bedroom",     category: .places, symbolName: "bed.double.fill"),
        Word(text: "kitchen",     category: .places, symbolName: "fork.knife"),
        Word(text: "garden",      category: .places, symbolName: "leaf.fill"),
        Word(text: "park",        category: .places, symbolName: "tree.fill"),
        Word(text: "car",         category: .places, symbolName: "car.fill"),
        Word(text: "bus",         category: .places, symbolName: "bus.fill"),
        Word(text: "shop",        category: .places, symbolName: "bag.fill"),
        Word(text: "hospital",    category: .places, symbolName: "cross.fill"),
        Word(text: "playground",  category: .places, symbolName: "figure.play"),
        Word(text: "classroom",   category: .places, symbolName: "desktopcomputer"),
        Word(text: "library",     category: .places, symbolName: "books.vertical.fill"),
        Word(text: "church",      category: .places, symbolName: "building.fill"),
        Word(text: "pool",        category: .places, symbolName: "figure.pool.swim"),
        Word(text: "beach",       category: .places, symbolName: "beach.umbrella.fill"),
        Word(text: "farm",        category: .places, symbolName: "leaf.circle.fill"),
        Word(text: "zoo",         category: .places, symbolName: "pawprint.fill"),
        Word(text: "restaurant",  category: .places, symbolName: "fork.knife.circle.fill"),
        Word(text: "toilet",      category: .places, symbolName: "toilet.fill"),
        Word(text: "office",      category: .places, symbolName: "building.2.fill"),
        Word(text: "hall",        category: .places, symbolName: "rectangle.fill"),
        Word(text: "stairs",      category: .places, symbolName: "arrow.up.right"),
        Word(text: "door",        category: .places, symbolName: "door.left.hand.open"),
        Word(text: "window",      category: .places, symbolName: "window.casement"),
        Word(text: "chair",       category: .places, symbolName: "chair.fill"),
        Word(text: "table",       category: .places, symbolName: "table.furniture.fill"),
        Word(text: "bed",         category: .places, symbolName: "bed.double.fill"),
        Word(text: "couch",       category: .places, symbolName: "sofa.fill"),
        Word(text: "sewing",      category: .places, symbolName: "scissors"),
        Word(text: "backyard",    category: .places, symbolName: "tree.fill"),
      
    ]
    
    // Find words matching keywords
    func findWords(matching keywords: [String]) -> [Word] {
        return keywords.compactMap { keyword in
            allWords.first { $0.text.lowercased() == keyword.lowercased() }
        }
    }
    
    // Get words by category
    func words(for category: WordCategory) -> [Word] {
        return allWords.filter { $0.category == category }
    }
}
