# FieldMate-Reworked

**FieldMate-Reworked** is a SwiftUI iOS app designed to keep field engineers in sync with up-to-date maintenance task assignments. It integrates with Google Sheets, caches data locally with SwiftData, and provides voice & shortcut access via Siri.

---

## 🔙 Background

FieldMate-Reworked is built on top of our previous team project [FieldMateV2](https://github.com/ArdiansyahAsrifah/FieldMateV2). The original app lacked a persistent backend, so it only displayed a static task snapshot. In this reworked version, we’ve added real-time data synchronization and redesigned the UI to improve usability and keep engineers informed automatically.

## 🚀 Project Overview

Field engineers often need real-time schedule updates while on the job. Our original app displayed a static snapshot of tasks, leading to missed changes and confusion. FieldMate-Reworked solves this by:

- **Synchronizing** with a Google Sheets source of truth whenever supervisors update tasks.
- **Caching** assignments locally in SwiftData for offline access and performance.
- **Highlighting** the current ("active") task based on the device clock.
- **Providing** quick access via Siri/Spotlight shortcuts.

---

## 🛠 Features

- **Live Data Sync** from Google Sheets API
- **Local Persistence** with SwiftData (`@Model` + `@Query`)
- **Dynamic Timeline** view that scrolls to the active task automatically
- **Notification Popover** with custom shape, blur background, and animations
- **Siri & Shortcut Integration** using AppIntents (e.g. "Show my tasks in FieldMate Reworked")
- **Sample Data Injection** on first launch for quick testing

---

## 📚 Tech Stack

- **Swift**: primary language  
- **SwiftUI**: declarative UI framework  
- **SwiftData**: persistent model layer  
- **URLSession + async/await**: networking  
- **Combine** (optional): reactive streams  
- **AppIntents**: Siri & Shortcuts integration  
- **UserDefaults**: simple flags  
- **Google Sheets API**: external schedule backend  

---

## 🏗 Architecture & Data Flow

```plaintext
Google Sheets       URLSession        TaskImporter         SwiftData DB           SwiftUI Views
(Coordinator) ──► (async/await) ──► (diff & insert) ──► (TaskEvent model) ──► (WeekSlider, DayTasks)
      ▲                                                         │
      └───────── Siri/Shortcut ─────► AppIntents ───────────────┘
```

1. **Fetch**: Functions in `Services` folder polls Google Sheets via REST+JSON.  
2. **Decode**: JSON maps to `TaskEvent` models.  
3. **Diff & Save**: Compare fetched tasks against the local store to identify additions, modifications, and deletions, then apply those changes to the SwiftData model, preserving change history.  
4. **Render**: SwiftUI views auto-refresh via `@Query`.  
5. **Voice**: Siri intent reads or opens tasks.

---

## ⚙️ Installation & Setup

1. Clone the repo:  
   ```bash
   git clone https://github.com/aranlv/FieldMate-Reworked.git
   ```
2. Open in Xcode (≥ 16.4) and ensure **App Intents** capability is enabled.  
3. In **Signing & Capabilities**, add **App Intents**.  
4. Configure your **Google Sheets API key** in `GoogleSheetsConfig`.  
5. Build & run on an iOS device or simulator.  

---

## ▶️ Usage

- **Main Screen**: Swipe weeks or tap the header to pick month/year.  
- **Timeline**: Scrolls to the task whose time range includes `Date()`.  
- **Notifications**: Tap the bell icon to see the popover.  
- **Siri Shortcut**: “Hey Siri, show my tasks in FieldMate-Reworked.”

---

## 📝 Future Roadmap

- Offline-first sync with conflict resolution  
- Push notifications or WebSocket real-time updates  
- Custom Siri UI snippet view for detailed task info  
- Automated UI & unit tests for SwiftData logic

---

## 🏅 License

MIT License © 2025 FieldMate Team
