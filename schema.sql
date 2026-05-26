-- A.T.E Smart Repair System - Database Schema DDL
-- Copy and paste this script into the Supabase SQL Editor to initialize your database!

-- 1. Create the 'users' table
CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('student', 'employee', 'admin')),
  initials TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create the 'requests' table
CREATE TABLE IF NOT EXISTS requests (
  id TEXT PRIMARY KEY, -- e.g., 'MR-1234'
  subject TEXT NOT NULL,
  category TEXT NOT NULL,
  reporter TEXT NOT NULL,
  reporter_username TEXT NOT NULL,
  phone TEXT NOT NULL, -- New field for phone numbers
  date TEXT NOT NULL, -- Thai formatted date string, e.g., '21 พ.ค. 2569'
  status TEXT NOT NULL CHECK (status IN ('รอดำเนินการ', 'กำลังดำเนินการ', 'รออะไหล่', 'เสร็จสิ้น')),
  details TEXT,
  assignee TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Enable Row Level Security (RLS) or simple policies if needed.
-- Note: Since the backend (Express server) manages access, you can keep standard policies or disable RLS for simplicity of dev.
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE requests DISABLE ROW LEVEL SECURITY;
