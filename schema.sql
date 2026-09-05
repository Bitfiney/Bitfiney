-- ============================================================
-- BITFINEY DATABASE SCHEMA
-- SIMULATION ONLY
-- ============================================================

-- IMPORTANT:
-- This database is for a simulated trading application.
-- It does NOT create real cryptocurrency transactions.
-- It does NOT connect to blockchain networks.
-- It does NOT process real deposits or withdrawals.
--
-- Never place a Supabase service-role key in browser JavaScript.


-- ============================================================
-- PROFILES
-- ============================================================

create table if not exists public.profiles (

    id uuid primary key references auth.users(id) on delete cascade,

    username text unique,

    full_name text,

    email text,

    role text not null default 'user'
        check (role in ('user','admin')),

    status text not null default 'active'
        check (status in ('active','restricted')),

    created_at timestamptz not null default now(),

    updated_at timestamptz not null default now()

);


-- ============================================================
-- SIMULATED USER SETTINGS
-- ============================================================

create table if not exists public.user_controls (

    user_id uuid primary key
        references public.profiles(id)
        on delete cascade,

    trading_enabled boolean not null default true,

    futures_enabled boolean not null default true,

    buy_enabled boolean not null default true,

    sell_enabled boolean not null default true,

    withdrawals_enabled boolean not null default true,

    updated_at timestamptz not null default now()

);


-- ============================================================
-- SIMULATED WALLETS
-- ============================================================

create table if not exists public.wallets (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references public.profiles(id)
        on delete cascade,

    asset text not null default 'USD',

    available_balance numeric(30,10) not null default 0,

    locked_balance numeric(30,10) not null default 0,

    created_at timestamptz not null default now(),

    updated_at timestamptz not null default now(),

    unique(user_id, asset),

    check (available_balance >= 0),

    check (locked_balance >= 0)

);


-- ============================================================
-- SIMULATED DEPOSIT SETTINGS
-- ============================================================

create table if not exists public.deposit_settings (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null unique
        references public.profiles(id)
        on delete cascade,

    deposit_address text,

    network text,

    asset text not null default 'USDT',

    enabled boolean not null default true,

    updated_at timestamptz not null default now()

);


-- ============================================================
-- SIMULATED DEPOSIT REQUESTS
-- ============================================================

create table if not exists public.deposit_requests (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references public.profiles(id)
        on delete cascade,

    amount numeric(30,10) not null,

    asset text not null default 'USD',

    reference text,

    status text not null default 'pending'
        check (
            status in (
                'pending',
                'approved',
                'rejected'
            )
        ),

    created_at timestamptz not null default now(),

    reviewed_at timestamptz,

    reviewed_by uuid
        references public.profiles(id)
        on delete set null,

    check (amount > 0)

);


-- ============================================================
-- SIMULATED WITHDRAWAL REQUESTS
-- ============================================================

create table if not exists public.withdrawal_requests (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references public.profiles(id)
        on delete cascade,

    amount numeric(30,10) not null,

    asset text not null default 'USD',

    withdrawal_address text not null,

    network text,

    status text not null default 'pending'
        check (
            status in (
                'pending',
                'approved',
                'rejected'
            )
        ),

    created_at timestamptz not null default now(),

    reviewed_at timestamptz,

    reviewed_by uuid
        references public.profiles(id)
        on delete set null,

    check (amount > 0)

);


-- ============================================================
-- SIMULATED TRADES
-- ============================================================

create table if not exists public.simulated_trades (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references public.profiles(id)
        on delete cascade,

    symbol text not null default 'BTC/USD',

    side text not null
        check (side in ('buy','sell')),

    order_type text not null
        check (
            order_type in (
                'market',
                'limit',
                'stop',
                'stop_limit'
            )
        ),

    quantity numeric(30,10) not null,

    price numeric(30,10),

    total numeric(30,10),

    status text not null default 'filled'
        check (
            status in (
                'open',
                'filled',
                'cancelled'
            )
        ),

    created_at timestamptz not null default now(),

    check (quantity > 0)

);


-- ============================================================
-- SIMULATED PROFIT ENTRIES
-- ============================================================

create table if not exists public.simulated_profit_entries (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references public.profiles(id)
        on delete cascade,

    amount numeric(30,10) not null,

    asset text not null default 'USD',

    description text,

    created_at timestamptz not null default now(),

    created_by uuid
        references public.profiles(id)
        on delete set null,

    check (amount > 0)

);


-- ============================================================
-- USER ACTIVITY
-- ============================================================

create table if not exists public.user_activity (

    id bigint generated always as identity primary key,

    user_id uuid
        references public.profiles(id)
        on delete cascade,

    activity_type text not null,

    description text,

    metadata jsonb default '{}'::jsonb,

    created_at timestamptz not null default now()

);


-- ============================================================
-- ADMIN AUDIT LOG
-- ============================================================

create table if not exists public.admin_audit_logs (

    id bigint generated always as identity primary key,

    admin_user_id uuid
        references public.profiles(id)
        on delete set null,

    target_user_id uuid
        references public.profiles(id)
        on delete set null,

    action text not null,

    details text,

    metadata jsonb default '{}'::jsonb,

    created_at timestamptz not null default now()

);


-- ============================================================
-- INDEXES
-- ============================================================

create index if not exists idx_profiles_role
on public.profiles(role);


create index if not exists idx_profiles_status
on public.profiles(status);


create index if not exists idx_wallets_user
on public.wallets(user_id);


create index if not exists idx_deposits_user
on public.deposit_requests(user_id);


create index if not exists idx_deposits_status
on public.deposit_requests(status);


create index if not exists idx_withdrawals_user
on public.withdrawal_requests(user_id);


create index if not exists idx_withdrawals_status
on public.withdrawal_requests(status);


create index if not exists idx_trades_user
on public.simulated_trades(user_id);


create index if not exists idx_activity_user
on public.user_activity(user_id);


create index if not exists idx_activity_created
on public.user_activity(created_at);


create index if not exists idx_audit_admin
on public.admin_audit_logs(admin_user_id);


create index if not exists idx_audit_target
on public.admin_audit_logs(target_user_id);


create index if not exists idx_audit_created
on public.admin_audit_logs(created_at);


-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table public.profiles
enable row level security;

alter table public.user_controls
enable row level security;

alter table public.wallets
enable row level security;

alter table public.deposit_settings
enable row level security;

alter table public.deposit_requests
enable row level security;

alter table public.withdrawal_requests
enable row level security;

alter table public.simulated_trades
enable row level security;

alter table public.simulated_profit_entries
enable row level security;

alter table public.user_activity
enable row level security;

alter table public.admin_audit_logs
enable row level security;


-- ============================================================
-- HELPER: CHECK ADMIN
-- ============================================================

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$

    select exists (

        select 1

        from public.profiles

        where id = auth.uid()

        and role = 'admin'

        and status = 'active'

    );

$$;


-- ============================================================
-- PROFILE POLICIES
-- ============================================================

drop policy if exists
"Users can view own profile"
on public.profiles;

create policy
"Users can view own profile"

on public.profiles

for select

to authenticated

using (

    id = auth.uid()

    or public.is_admin()

);


-- ============================================================
-- USER CONTROL POLICIES
-- ============================================================

drop policy if exists
"Users can view own controls"
on public.user_controls;

create policy
"Users can view own controls"

on public.user_controls

for select

to authenticated

using (

    user_id = auth.uid()

    or public.is_admin()

);


-- ============================================================
-- WALLET POLICIES
-- ============================================================

drop policy if exists
"Users can view own wallet"
on public.wallets;

create policy
"Users can view own wallet"

on public.wallets

for select

to authenticated

using (

    user_id = auth.uid()

    or public.is_admin()

);


-- ============================================================
-- DEPOSIT SETTINGS POLICIES
-- ============================================================

drop policy if exists
"Users can view own deposit settings"
on public.deposit_settings;

create policy
"Users can view own deposit settings"

on public.deposit_settings

for select

to authenticated

using (

    user_id = auth.uid()

    or public.is_admin()

);


-- ============================================================
-- DEPOSIT REQUEST POLICIES
-- ============================================================

drop policy if exists
"Users can view own deposits"
on public.deposit_requests;

create policy
"Users can view own deposits"

on public.deposit_requests

for select

to authenticated

using (

    user_id = auth.uid()

    or public.is_admin()

);


drop policy if exists
"Users can create own deposits"
on public.deposit_requests;

create policy
"Users can create own deposits"

on public.deposit_requests

for insert

to authenticated

with check (

    user_id = auth.uid()

);


-- ============================================================
-- WITHDRAWAL POLICIES
-- ============================================================

drop policy if exists
"Users can view own withdrawals"
on public.withdrawal_requests;

create policy
"Users can view own withdrawals"

on public.withdrawal_requests

for select

to authenticated

using (

    user_id = auth.uid()

    or public.is_admin()

);


drop policy if exists
"Users can create own withdrawals"
on public.withdrawal_requests;

create policy
"Users can create own withdrawals"

on public.withdrawal_requests

for insert

to authenticated

with check (

    user_id = auth.uid()

);


-- ============================================================
-- TRADING POLICIES
-- ============================================================

drop policy if exists
"Users can view own simulated trades"
on public.simulated_trades;

create policy
"Users can view own simulated trades"

on public.simulated_trades

for select

to authenticated

using (

    user_id = auth.uid()

    or public.is_admin()

);


drop policy if exists
"Users can create own simulated trades"
on public.simulated_trades;

create policy
"Users can create own simulated trades"

on public.simulated_trades

for insert

to authenticated

with check (

    user_id = auth.uid()

);


-- ============================================================
-- USER ACTIVITY POLICIES
-- ============================================================

drop policy if exists
"Users can view own activity"
on public.user_activity;

create policy
"Users can view own activity"

on public.user_activity

for select

to authenticated

using (

    user_id = auth.uid()

    or public.is_admin()

);


-- ============================================================
-- ADMIN AUDIT POLICIES
-- ============================================================

drop policy if exists
"Admins can view audit logs"
on public.admin_audit_logs;

create policy
"Admins can view audit logs"

on public.admin_audit_logs

for select

to authenticated

using (

    public.is_admin()

);


-- ============================================================
-- AUTOMATIC PROFILE CREATION
-- ============================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$

begin

    insert into public.profiles (
        id,
        email
    )

    values (
        new.id,
        new.email
    )

    on conflict (id)
    do nothing;


    insert into public.user_controls (
        user_id
    )

    values (
        new.id
    )

    on conflict (user_id)
    do nothing;


    insert into public.wallets (
        user_id,
        asset,
        available_balance,
        locked_balance
    )

    values (
        new.id,
        'USD',
        0,
        0
    )

    on conflict (user_id, asset)
    do nothing;


    insert into public.deposit_settings (
        user_id
    )

    values (
        new.id
    )

    on conflict (user_id)
    do nothing;


    return new;

end;

$$;


-- ============================================================
-- AUTH USER TRIGGER
-- ============================================================

drop trigger if exists
on_auth_user_created
on auth.users;


create trigger
on_auth_user_created

after insert

on auth.users

for each row

execute function
public.handle_new_user();


-- ============================================================
-- UPDATED_AT HELPER
-- ============================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$

begin

    new.updated_at =
        now();

    return new;

end;

$$;


-- ============================================================
-- UPDATED_AT TRIGGERS
-- ============================================================

drop trigger if exists
profiles_updated_at
on public.profiles;

create trigger
profiles_updated_at

before update

on public.profiles

for each row

execute function
public.set_updated_at();


drop trigger if exists
controls_updated_at
on public.user_controls;

create trigger
controls_updated_at

before update

on public.user_controls

for each row

execute function
public.set_updated_at();


drop trigger if exists
wallets_updated_at
on public.wallets;

create trigger
wallets_updated_at

before update

on public.wallets

for each row

execute function
public.set_updated_at();


drop trigger if exists
deposit_settings_updated_at
on public.deposit_settings;

create trigger
deposit_settings_updated_at

before update

on public.deposit_settings

for each row

execute function
public.set_updated_at();


-- ============================================================
-- END OF BITFINEY SCHEMA
-- ============================================================
