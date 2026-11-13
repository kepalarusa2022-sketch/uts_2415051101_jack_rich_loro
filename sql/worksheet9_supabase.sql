-- ============================================================================
-- WORKSHEET 9: SUPABASE DATABASE CONFIGURATION SCRIPT
-- KosFinder: Authentication, Authorization & Push Notification
-- Mahasiswa: Jack Rich Loro (NIM: 2415051101)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. TABEL PROFILES & ROLE-BASED AUTH (Praktik 3)
-- ----------------------------------------------------------------------------

-- Buat tabel profiles jika belum ada
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  name text,
  role text not null default 'seeker' check (role in ('seeker', 'owner', 'admin'))
);

-- Aktifkan Row Level Security (RLS) pada tabel profiles
alter table public.profiles enable row level security;

-- Policy: User hanya boleh membaca data profil miliknya sendiri
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select to authenticated
  using (auth.uid() = id);

-- Function & Trigger: Pembuatan profil otomatis setiap ada user baru registrasi
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'name', ''),
    case
      when new.raw_user_meta_data->>'role' in ('seeker', 'owner')
        then new.raw_user_meta_data->>'role'
      else 'seeker'
    end
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Migrasi profil untuk akun lama yang sudah terdaftar sebelum trigger dibuat
insert into public.profiles (id, email, name, role)
select id, email, '', 'seeker' from auth.users
on conflict (id) do nothing;

-- ----------------------------------------------------------------------------
-- 2. TABEL KOS & ROW LEVEL SECURITY (RLS) POLICIES (Praktik 5)
-- ----------------------------------------------------------------------------

-- Buat tabel kos jika belum ada
create table if not exists public.kos (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  address text,
  price integer,
  created_at timestamptz not null default now()
);

-- Pastikan kolom owner_id tersedia jika tabel sudah ada dari worksheet sebelumnya
alter table public.kos
  add column if not exists owner_id uuid
  references auth.users(id) on delete cascade default auth.uid();

-- Aktifkan RLS pada tabel kos
alter table public.kos enable row level security;

-- 1. SELECT: Semua user terautentikasi (seeker, owner, admin) boleh membaca seluruh katalog kos
drop policy if exists "kos_select_authenticated" on public.kos;
create policy "kos_select_authenticated"
  on public.kos for select to authenticated
  using (true);

-- 2. INSERT: Hanya owner atau admin yang boleh menambahkan kos, dan owner_id harus ID miliknya sendiri
drop policy if exists "kos_insert_owner" on public.kos;
create policy "kos_insert_owner"
  on public.kos for insert to authenticated
  with check (
    auth.uid() = owner_id
    and exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role in ('owner', 'admin')
    )
  );

-- 3. UPDATE: Hanya pemilik data (owner_id == auth.uid()) yang dapat mengubah kos
drop policy if exists "kos_update_own" on public.kos;
create policy "kos_update_own"
  on public.kos for update to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- 4. DELETE: Hanya pemilik data (owner_id == auth.uid()) yang dapat menghapus kos
drop policy if exists "kos_delete_own" on public.kos;
create policy "kos_delete_own"
  on public.kos for delete to authenticated
  using (auth.uid() = owner_id);

-- 5. ADMIN POLICY: Admin memiliki akses penuh terhadap seluruh baris
create or replace function public.is_admin()
returns boolean
language sql stable
security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

drop policy if exists "kos_admin_all" on public.kos;
create policy "kos_admin_all"
  on public.kos for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ----------------------------------------------------------------------------
-- 3. TABEL DEVICE TOKENS UNTUK PUSH NOTIFICATION FCM (Praktik 9)
-- ----------------------------------------------------------------------------

create table if not exists public.device_tokens (
  token text primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  platform text,
  updated_at timestamptz not null default now()
);

alter table public.device_tokens enable row level security;

drop policy if exists "tokens_select_own" on public.device_tokens;
create policy "tokens_select_own" on public.device_tokens
  for select to authenticated using (auth.uid() = user_id);

drop policy if exists "tokens_insert_own" on public.device_tokens;
create policy "tokens_insert_own" on public.device_tokens
  for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists "tokens_update_own" on public.device_tokens;
create policy "tokens_update_own" on public.device_tokens
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "tokens_delete_own" on public.device_tokens;
create policy "tokens_delete_own" on public.device_tokens
  for delete to authenticated using (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- 4. VERIFIKASI KEBIJAKAN RLS
-- ----------------------------------------------------------------------------

-- Cek apakah RLS aktif:
select relname, relrowsecurity from pg_class where relname in ('profiles', 'kos', 'device_tokens');

-- Cek daftar policy yang terdaftar:
select tablename, policyname, cmd from pg_policies where schemaname = 'public';

-- ----------------------------------------------------------------------------
-- 5. QUERY PENGUJIAN ROLE & SECURITY (SQL EDITOR SIMULATION)
-- ----------------------------------------------------------------------------

-- Mengubah role akun untuk pengujian:
-- update public.profiles set role = 'owner' where email = 'owner@contoh.com';
-- update public.profiles set role = 'admin' where email = 'admin@contoh.com';
-- update public.profiles set role = 'seeker' where email = 'seeker@contoh.com';
