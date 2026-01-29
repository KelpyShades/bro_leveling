# Bro Leveling

A private, social progression game inspired by *Solo Leveling*, built for a closed group of friends. Players gain, lose, and manage **Aura** based on discipline, consistency, and social judgment. Aura represents presence, reputation, and dominance within the group.

This document defines the **entire system** so an AI or developer can build the project end-to-end without ambiguity.

---

## 1. Core Principles

- **Private by design**: Single group only. No public discovery, no invites.
- **Aura has weight**: Gains feel earned, losses hurt.
- **Social authority > grinding**: Group voting matters more than passive farming.
- **High ceiling, slow climb**: Aura can reach thousands without inflation.
- **Irreversible failure**: Aura reaching 0 is a serious state.

---

## 2. Player Lifecycle

### Account Creation
- User signs up
- User is automatically added to the **only group** in the system
- Starting Aura: **100**
- Starting Title: **Invisible (since they start with 100 aura)**
- Streak: **0**

There is no group selection or creation logic.

---

## 3. Aura Economy

### Passive Gains

| Source | Aura |
|------|------|
| Daily system gain | +10 |
| Weekly system bonus (active ≥4 days) | +50 |

---

### Daily Streak System

- User must tap a **Daily Aura Button** once per day
- Rewards:
  - +10 Aura
  - +1 streak day

#### Streak Milestones

| Streak Days | Bonus |
|-----------|-------|
| 7 | +30 |
| 14 | +60 |
| 30 | +150 |
| 60 | +300 |
| 100 | +600 |

Missing a day resets the streak to 0.

---

## 4. Aura Titles & Progression

### Rule
- **Any aura below 100 = NPC**

### Title Ladder

| Aura Range | Title |
|----------|------|
| 0–99 | NPC |
| 100–199 | Invisible |
| 200–299 | Main Character (MC) |
| 300–399 | Black Flash |
| 400–499 | Shadow |
| 500–599 | Aura Commander |
| 600–699 | Unfazed |
| 700–799 | Shadow Monarch |
| 800–899 | The Original |
| 900–999 | Infinite Steez |
| 1000–1199 | The Honored One |
| 1200–1399 | Anomaly |
| 1400–1599 | The Beyonder |
| 1600–1799 | Menace |
| 1800–2099 | Eternal Shadow |
| 2100–2499 | The Inevitable |
| 2500–2999 | The One Above All |
| 3000+ | Aura Sovereign |

---

### Special Override Title

**Him**

- Not aura-based
- Overrides rank title
- Granted manually or by system rules
- Rare and respected

---

## 5. Social Aura System (Core Gameplay)

### Proposals

Any user can create an **Aura Proposal** to:
- Boost aura
- Penalize aura

#### Proposal Fields
- Target user
- Aura amount
- Reason (required)
- Type: boost | penalty

#### Limits
- Max boost: **+100 Aura**
- Max penalty: **−100 Aura**
- Max 2 proposals per user per day

---

### Voting Rules

- Voting duration: **12 hours**
- Each user can:
  - Support
  - Reject
  - Abstain

#### Approval Conditions
- More than **50% of total users** must support
- Minimum vote quorum required (configurable, e.g. 4 users)

#### Outcomes
- Approved → Aura applied
- Rejected → No effect

Proposals cannot be retried for the same event.

---

## 6. Aura Sharing (Gifting)

### Rules

- Users can gift aura to others
- Limits:
  - 10 Aura per day
  - 50 Aura per week
- Cannot gift if aura < 50
- Gifted aura does **not** affect streak bonuses

Sharing is for recovery and support, not farming.

---

## 7. Aura Death & Recovery

### Aura = 0 State

Status: **Broken**

When aura reaches 0:
- User cannot vote
- User cannot create proposals
- User cannot receive shared aura
- User can still log in and view activity

---

### Weekly Recovery

- Available once per week
- Manual claim
- Restores **+25 Aura**
- Only usable if aura is 0

Missed recovery is not carried forward.

---

## 8. System Constraints & Anti-Abuse

- No stacking multiple proposals for one event
- Voting quorum prevents small-group abuse
- Sharing caps prevent funneling
- Death state prevents infinite recovery loops

---

## 9. Flutter Tech Stack

### Core Framework
- Flutter (stable)

### State Management
- `riverpod`
- `flutter_riverpod`

### Navigation
- `go_router`

### Models & Immutability
- `freezed`
- `json_serializable`

### Backend (Recommended)
- Supabase (Auth + Postgres + Realtime)

### Utilities
- `intl` (dates)
- `uuid`

---

## 10. Data Models (Conceptual)

### User
- id
- username
- aura
- streak
- title
- isBroken

### Proposal
- id
- targetUserId
- amount
- type
- reason
- status
- createdAt

### Vote
- id
- proposalId
- voterId
- value

### AuraTransfer
- id
- fromUserId
- toUserId
- amount
- createdAt

---

## 11. UI Structure (High-Level)

- Splash / Auth
- Home (Leaderboard + Title)
- Daily Aura Button
- Proposals Feed
- Proposal Details & Voting
- Aura History
- Profile

---

## 12. MVP Scope (Do Not Expand)

Included:
- Aura system
- Streaks
- Proposals
- Voting
- Sharing
- Titles
- Death & recovery

Excluded:
- Public profiles
- Multiple groups
- Monetization
- Social media features

---

## 13. Project Philosophy

Bro Leveling is not a productivity app.
It is a **social contract**.

Aura reflects:
- Discipline
- Reputation
- Consistency
- Presence

The system does not protect players from consequences.

---

## End of Specification