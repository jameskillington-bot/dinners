-- This Week's Dinners — the shared kitchen list
--
-- Paste this whole file into the Supabase SQL editor and press Run. It is
-- safe to run more than once.
--
-- How the privacy works: the table has row level security switched on and
-- no policies, which means nothing can read or write it directly — not even
-- with the public key that sits in index.html. The only way in is the two
-- functions below, and both of them need your household code, which lives
-- on your phones and is never written into the public repo.

create table if not exists public.kitchens (
  code       text primary key,
  data       jsonb       not null,
  rev        bigint      not null default 1,
  updated_at timestamptz not null default now()
);

alter table public.kitchens enable row level security;

-- Read the list for one code.
create or replace function public.kitchen_get(p_code text)
returns table (data jsonb, rev bigint)
language sql
security definer
set search_path = public
as $$
  select k.data, k.rev from public.kitchens k where k.code = p_code;
$$;

-- Write the list for one code.
-- p_rev is the revision the phone last saw. If the other phone has saved
-- something newer in the meantime, nothing is overwritten: the newer version
-- is handed back with clash = true, and the phone adopts it instead.
create or replace function public.kitchen_put(p_code text, p_data jsonb, p_rev bigint)
returns table (data jsonb, rev bigint, clash boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  current_rev bigint;
begin
  if p_code is null or length(p_code) < 8 then
    raise exception 'code missing or too short';
  end if;

  select k.rev into current_rev
    from public.kitchens k
   where k.code = p_code
     for update;

  if current_rev is null then
    insert into public.kitchens (code, data, rev) values (p_code, p_data, 1);
    return query select k.data, k.rev, false from public.kitchens k where k.code = p_code;

  elsif coalesce(p_rev, 0) >= current_rev then
    update public.kitchens
       set data = p_data, rev = current_rev + 1, updated_at = now()
     where code = p_code;
    return query select k.data, k.rev, false from public.kitchens k where k.code = p_code;

  else
    return query select k.data, k.rev, true from public.kitchens k where k.code = p_code;
  end if;
end;
$$;

revoke all on function public.kitchen_get(text)                from public;
revoke all on function public.kitchen_put(text, jsonb, bigint)  from public;
grant execute on function public.kitchen_get(text)               to anon;
grant execute on function public.kitchen_put(text, jsonb, bigint) to anon;
