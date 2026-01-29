# Bro Leveling — Database Schema

This document defines the **authoritative PostgreSQL schema** for Bro Leveling.
It is designed for **Supabase** and enforces game rules at the database level to prevent cheating, abuse, or client-side manipulation.

This schema assumes:
- Single global group
- Aura integrity is enforced server-side
- Flutter client is untrusted

---

## 1. Design Goals

- Aura changes must be **auditable**
- All critical logic must live in the database or edge functions
- No client can directly mutate aura
- Constraints prevent economy abuse

---

## 2. Core Tables

### 2.1 users

Stores player state and progression.

```sql
create table users (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  aura integer not null default 100 check (aura >= 0),
  streak integer not null default 0,
  title text not null default 'NPC',
  is_broken boolean not null default false,
  last_daily_claim date,
  last_penalty_at timestamptz,
  indestructible_until timestamptz,
  last_decay_at timestamptz,
  created_at timestamptz not null default now()
);
```

---

### 2.2 aura_events

Immutable log of **every aura change**.
This table is critical for transparency and debugging.

```sql
create table aura_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  amount integer not null,
  source text not null, -- system | streak | proposal | gift | recovery
  metadata jsonb,
  created_at timestamptz not null default now()
);
```

No updates. No deletes.

---

### 2.3 proposals

Represents social aura judgments.

```sql
create table proposals (
  id uuid primary key default gen_random_uuid(),
  proposer_id uuid not null references users(id) on delete cascade,
  target_user_id uuid not null references users(id) on delete cascade,
  amount integer not null check (abs(amount) <= 100),
  type text not null check (type in ('boost', 'penalty')),
  reason text not null,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now(),
  closes_at timestamptz not null,
  shielded boolean not null default false
);
```

---

### 2.4 votes

Tracks votes on proposals.

```sql
create table votes (
  id uuid primary key default gen_random_uuid(),
  proposal_id uuid not null references proposals(id) on delete cascade,
  voter_id uuid not null references users(id) on delete cascade,
  value text not null check (value in ('support', 'reject', 'abstain')),
  created_at timestamptz not null default now(),
  unique (proposal_id, voter_id)
);
```

---

### 2.5 aura_transfers

Tracks aura gifting.

```sql
create table aura_transfers (
  id uuid primary key default gen_random_uuid(),
  from_user_id uuid not null references users(id),
  to_user_id uuid not null references users(id),
  amount integer not null check (amount > 0 and amount <= 10),
  created_at timestamptz not null default now()
);
```

---

## 3. Enforcement Rules (CRITICAL)

### 3.1 Prevent Direct Aura Mutation

Clients must never update `users.aura` directly.

Only the following should modify aura:
- Database functions
- Supabase Edge Functions

---

### 3.2 Proposal Resolution Logic

Handled via a **Postgres function**:

```sql
create or replace function resolve_proposal(p_proposal_id uuid)
returns void as $$
declare
  support_count int;
  total_users int;
begin
  select count(*) into support_count
  from votes
  where proposal_id = p_proposal_id and value = 'support';

  select count(*) into total_users from users;

  if support_count > total_users / 2 then
    update proposals set status = 'approved' where id = p_proposal_id;
  else
    update proposals set status = 'rejected' where id = p_proposal_id;
  end if;
end;
$$ language plpgsql;
```

Aura application happens **only after approval**.

---

### 3.3 Apply Aura Change

```sql
create or replace function apply_aura(
  p_user_id uuid,
  p_amount int,
  p_source text,
  p_metadata jsonb
) returns void as $$
begin
  update users
  set aura = greatest(aura + p_amount, 0)
  where id = p_user_id;

  insert into aura_events (user_id, amount, source, metadata)
  values (p_user_id, p_amount, p_source, p_metadata);
end;
$$ language plpgsql;
```

---

### 3.4 Aura Death Detection

```sql
create or replace function check_aura_death()
returns trigger as $$
begin
  if new.aura = 0 then
    new.is_broken := true;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger aura_death_trigger
before update on users
for each row
execute function check_aura_death();
```

---

## 4. Streak System Enforcement

Daily streak claims should:
- Only be allowed once per day
- Reset streak if a day is missed

This logic should live in an **Edge Function** to avoid timezone abuse.

---

## 5. Weekly Recovery Enforcement

- Only allowed if `is_broken = true`
- Only once per calendar week
- Logs recovery as `aura_events`

- Logs recovery as `aura_events`

---

## 6. Optimization & Security
### Performance Indexes
```sql
create index idx_users_aura on users(aura DESC);
create index idx_users_last_daily_claim on users(last_daily_claim);
create index idx_proposals_target on proposals(target_user_id);
create index idx_proposals_closes on proposals(closes_at);
create index idx_aura_events_created_at on aura_events(created_at DESC);
create index idx_aura_events_user_created on aura_events(user_id, created_at DESC);
```

### Indestructible Mode Logic
Triggers enforce immunity:
- `tr_indestructible_on_claim`: Grants 12h immunity on daily claim.
- `tr_block_indestructible_penalty`: Blocks penalty proposals vs immune users.

### Aura Decay
Scheduled function `process_aura_decay()`:
- Checks inactivity > 26h.
- Deducts 25/50 Aura.
- **Requires Cron Job**: `SELECT process_aura_decay();` nightly.

## 6. Indexing (Performance)

```sql
create index on aura_events(user_id);
create index on proposals(status);
create index on votes(proposal_id);
create index on aura_transfers(from_user_id);
```

---

## 7. Row Level Security (RLS)

- Users can read all public data
- Users can only write:
  - Their own votes
  - Their own proposals

Aura mutation tables (`users`, `aura_events`) are **write-protected**.

---

## 8. Final Notes

- This schema is intentionally strict
- If the database allows it, the game allows it
- If the database forbids it, the client must comply

This ensures Bro Leveling remains fair, social, and resistant to abuse.

---

## End of Schema

