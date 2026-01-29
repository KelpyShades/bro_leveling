# 👑 Bro Leveling

> **"Aura is not about perfection. It is about consistency, discipline, and how the world responds when you arrive."**

**Bro Leveling** is a private, social progression system built on **Flutter** and **Supabase**. It gamifies reputation ("Aura") within a closed group, enforcing discipline through daily streaks, social voting, and high-stakes penalties.

It is designed with an authoritative **Black & Gold** aesthetic and runs seamlessly on mobile and web (PWA).

---

## ⚡ Core Features

### 🧬 Aura System
- **18 Distinct Tiers**: Progression from **NPC** (<100 Aura) to **Aura Sovereign** (3000+ Aura).
- **Titles that Matter**: Each rank carries lore and visual prestige.
- **The "HIM" Title**: A rare, contested title for the absolute dominant user of the week.

### ⚖️ Social Governance
- **Proposals**: Users vote to **Boost** or **Penalize** each other's Aura based on real-world actions.
- **Democracy**: 50% + 1 votes required to pass judgment.
- **Shield Mechanic**: A strategic, once-a-week ability to reverse a passed penalty.

### 🛡️ Active States & Penalties
- **Indestructible Virgin Mode**: 
  - *Condition*: No penalties for 3 days.
  - *Effect*: 12-hour immunity from penalties after daily claim.
- **Rank Decay ("Use It or Lose It")**:
  - *Condition*: Inactivity > 26 hours.
  - *Penalty*: **-25 Aura** (Day 1), **-50 Aura** (Daily thereafter).
  - *Floor*: Aura never drops below 0. 

### 🌍 Global Activity Feed
- **Live Feed**: See every vote, penalty, and rank up in real-time.
- **Transparency**: Nothing is hidden. The ledger is public to all users.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Mobile & Web/PWA)
- **State Management**: Riverpod (Providers, Consumers)
- **Navigation**: GoRouter (Shell Routes, Persistent Nav)
- **Backend Service**: Supabase
  - **Auth**: User management
  - **Database**: PostgreSQL (with Triggers & RLS)
  - **Edge Functions**: Cron jobs for decay (optional/recommended)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- A Supabase project

### 1. Database Setup
Run the SQL migrations found in `supabase/migrations` in your Supabase SQL Editor in established order:
1. `..._indestructible_virgin.sql`
2. `..._aura_decay.sql`
3. `..._performance_indexes.sql`

*Note: Ensure you set up a **Cron Job** for `SELECT process_aura_decay();` to run nightly.*

### 2. Run the App
```bash
# Run on mobile emulator/device
flutter run

# Run on Web (PWA Mode)
flutter run -d chrome --web-renderer canvaskit
```

---

## 📱 PWA Support
This project is configured as a **Progressive Web App**.
- **Manifest**: Branded with "Bro Leveling" in Black & Gold.
- **Installable**: Can be installed to home screen on iOS/Android.

---

*Verified & Maintained by the Architecture Team.*
