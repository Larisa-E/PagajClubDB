USE PagajClubDB;
GO
SELECT DB_NAME() AS current_db;
GO

-- confirm tables and their schema
SELECT schema_name(schema_id) AS schema_name, name
FROM sys.tables
WHERE name IN ('categories','members','arrangements','images','news');
GO

-- show first rows to confirm content
SELECT TOP (5) * FROM dbo.arrangements;
SELECT TOP (5) * FROM dbo.categories;
SELECT TOP (5) * FROM dbo.members;
GO

-- 1) Show all parties (Party) that are held in the clubhouse
SELECT a.id,
       a.title,
       c.name AS category,
       a.start_time,
       a.duration_minutes,
       a.max_participants,
       a.place_type,
       a.place_details,
       CONCAT(m.first_name, ' ', m.last_name) AS responsible
FROM dbo.arrangements AS a
JOIN dbo.categories AS c ON a.category_id = c.id
JOIN dbo.members AS m ON a.responsible_member_id = m.id
WHERE c.name = 'Party'
  AND a.place_type = 'club'
ORDER BY a.start_time;
GO

-- 2) Show all events that have taken place, and sort them alphabetically by category
SELECT a.id,
       a.title,
       c.name AS category,
       a.start_time,
       a.duration_minutes,
       DATEADD(minute, a.duration_minutes, a.start_time) AS end_time,
       CONCAT(m.first_name, ' ', m.last_name) AS responsible
FROM dbo.arrangements AS a
JOIN dbo.categories AS c ON a.category_id = c.id
JOIN dbo.members AS m ON a.responsible_member_id = m.id
WHERE DATEADD(minute, a.duration_minutes, a.start_time) < GETDATE()
ORDER BY c.name ASC, a.start_time DESC;
GO

-- 3) Approve all not-approved news
UPDATE dbo.news
SET is_approved = 1
WHERE is_approved = 0;
GO

-- Verification: show news items after approval
SELECT id, title, start_time, end_time, author_id, is_approved, created_at
FROM dbo.news
ORDER BY created_at DESC;
GO