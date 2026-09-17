-- NPSD Teacher Portal
-- Run once in Supabase SQL Editor after the core NPSD schema.

create table if not exists public.teachers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  full_name text not null,
  phone text,
  employee_id text unique,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.teacher_class_assignments (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid not null references public.teachers(id) on delete cascade,
  class_id uuid not null references public.classes(id) on delete cascade,
  subject_id uuid,
  subject text,
  created_at timestamptz not null default now(),
  unique(teacher_id,class_id,subject_id)
);

create unique index if not exists attendance_student_date_unique
  on public.attendance(student_id, attendance_date);

alter table public.teachers enable row level security;
alter table public.teacher_class_assignments enable row level security;

create policy "teachers read own profile" on public.teachers
  for select to authenticated using (user_id = auth.uid());

create policy "teachers read own assignments" on public.teacher_class_assignments
  for select to authenticated using (
    teacher_id in (select id from public.teachers where user_id = auth.uid() and active = true)
  );

create index if not exists teacher_assignments_teacher_idx on public.teacher_class_assignments(teacher_id);
create index if not exists teacher_assignments_class_idx on public.teacher_class_assignments(class_id);

-- After creating a teacher in Authentication > Users, run an insert like:
-- insert into public.teachers(user_id,full_name,employee_id) values ('AUTH-USER-UUID','Teacher Name','T-001');
-- Then assign their classes:
-- insert into public.teacher_class_assignments(teacher_id,class_id,subject) values ('TEACHER-UUID','CLASS-UUID','English');
