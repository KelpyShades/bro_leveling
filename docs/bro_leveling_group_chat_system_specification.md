# 💬 Bro Leveling — Group Chat System

## Overview
The **Group Chat** is a simple, real-time text communication feature for all users in Bro Leveling.

This chat is intentionally minimal:
- One global group
- Text-only messages
- No media, no reactions, no threads

The goal is to support **banter, coordination, callouts, aura discussions, and social pressure** — not to replace full messaging apps.

---

## Core Principles

1. **Simplicity First**  
   The chat should feel lightweight and instant.

2. **Social Presence**  
   Messages reinforce aura dynamics, voting, and recognition.

3. **Low Moderation Overhead**  
   No attachments, no embeds, no rich formatting.

---

## Chat Scope

- There is **only one chat room** in the entire app
- All users are automatically part of it
- No joining or leaving

This mirrors the core philosophy:
> Everyone exists in the same space. Presence matters.

---

## Message Structure

Each message contains only essential data.

### Required Fields

```json
{
  "id": "string",
  "senderId": "string",
  "senderName": "string",
  "content": "string",
  "createdAt": "timestamp"
}
```

### Field Notes

- `senderName` is stored redundantly to avoid expensive joins
- `content` is **plain text only**
- `createdAt` is server-generated

---

## Message Rules

- Max length: **500 characters**
- No markdown
- No links previewed
- No mentions (@)
- No emojis enforced (but allowed as unicode)

Messages are displayed exactly as sent.

---

## Permissions

### Who Can Send Messages
- Any authenticated user

### Who Can Read Messages
- Any authenticated user

There are **no roles** and **no chat hierarchy**.

---

## Deletion & Editing

- Messages **cannot be edited**
- Messages **cannot be deleted by users**

This preserves:
- Accountability
- Social memory
- Context for aura-related events

(Manual admin deletion can exist outside the app if needed.)

---

## Ordering & Pagination

- Messages are ordered by `createdAt` (ascending)
- Load the **most recent 50 messages** initially
- Infinite scroll loads older messages

---

## Real-Time Updates

- New messages appear instantly via real-time listeners
- Typing indicators are **not included**

The experience should feel fast, not busy.

---

## Daily Message Purge (Cron Job)

To keep the chat lightweight and present-focused, **all messages are ephemeral**.

### Behavior

- A server-side **cron job runs once every 24 hours**
- The job **deletes all messages** in the group chat table for that day
- The chat resets to an empty state

This ensures:
- No long-term chat history
- No legacy dominance through old messages
- Focus on *current* presence, not past talk

### Implementation Notes

- Cron should be handled server-side (e.g. Supabase scheduled function)
- Deletion is **hard delete**, not soft delete
- No client-side involvement or permissions

### UX Implication

- Users should expect the chat to reset daily
- Optional system message after reset:
  - "The room clears. A new day begins."

The chat exists in the *now*.


---

## UI Guidelines

### Message Bubble

- Sender name displayed above message
- Message text below
- Timestamp optional (tap to reveal or small text)

### Visual Accents (Optional)

- Subtle color tint based on aura tier
- Special icon next to **HIM** holder

No avatars required.

---

## Anti-Abuse Safeguards

### Rate Limiting

- Max **5 messages per 10 seconds** per user

### Empty Messages

- Empty or whitespace-only messages are rejected

---

## Integration with Aura System

The chat does **not** directly affect aura.

However, it enables:
- Calling out achievements
- Suggesting boosts or penalties
- Social proof and consensus building

Chat is influence — not currency.

---

## Data Storage (Suggested)

### Table: `group_messages`

```sql
id UUID PRIMARY KEY
sender_id UUID NOT NULL
sender_name TEXT NOT NULL
content TEXT NOT NULL
created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
```

Indexes:
- `created_at`

---

## Flutter Implementation Notes

### Recommended Packages

- `flutter_riverpod`
- `go_router`
- `freezed`
- `json_serializable`

### State Management

- Stream provider for messages
- Separate notifier for sending messages

### Navigation

- Chat accessible from bottom nav or side menu

---

## Non-Goals (Explicitly Excluded)

- Private chats
- Media sharing
- Message reactions
- Read receipts
- Typing indicators

These are intentionally omitted to keep the system clean and focused.

---

> The group chat exists to amplify presence.
> What you say matters — because everyone sees it.

