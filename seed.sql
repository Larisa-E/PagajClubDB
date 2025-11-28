USE PagajClubDB;
GO

SET IDENTITY_INSERT dbo.categories ON;
INSERT INTO dbo.categories (id, name) VALUES
 (1, 'Trip'),
 (2, 'Course'),
 (3, 'Regatta'),
 (4, 'GroupTour'),
 (5, 'Party');
SET IDENTITY_INSERT dbo.categories OFF;
GO

SET IDENTITY_INSERT dbo.members ON;
INSERT INTO dbo.members (id, first_name, last_name, email, phone, username, created_at) VALUES
 (1, 'Alice', 'Smith', 'alice@example.com', '+12025550101', 'alice', '2024-01-01T08:00:00'),
 (2, 'Bob', 'Jones', 'bob@example.com', '+12025550102', 'bob', '2024-02-15T09:00:00'),
 (3, 'Carol', 'White', 'carol@example.com', '+12025550103', 'carol', '2024-03-20T10:00:00');
SET IDENTITY_INSERT dbo.members OFF;
GO

SET IDENTITY_INSERT dbo.arrangements ON;
INSERT INTO dbo.arrangements (id, title, responsible_member_id, category_id, start_time, duration_minutes, max_participants, description, place_type, place_details, created_at)
VALUES
 (1, 'Club Anniversary Party', 1, 5, '2025-06-20T19:00:00', 240, 200, 'Annual club party in the clubhouse. Bring snacks.', 'club', NULL, '2025-03-01T12:00:00'),
 (2, 'Summer Trip to the Fjord', 2, 1, '2026-07-10T08:00:00', 480, 30, 'Join us for a day trip to the fjord. Meeting at the club.', 'other', 'Fjord harbor, slipway at Havnvej', '2025-05-20T09:00:00'),
 (3, 'Autumn Training Session', 3, 4, '2024-10-10T10:00:00', 180, 20, 'Paddling techniques and group exercises. Location: clubhouse.', 'club', NULL, '2024-09-01T10:00:00'),
 (4, 'New Year Party at Local Hall', 2, 5, '2026-01-01T20:00:00', 360, 150, 'New year celebration at the community hall (not in the club).', 'other', 'Community Hall, Main St 12', '2025-09-10T11:00:00');
SET IDENTITY_INSERT dbo.arrangements OFF;
GO

SET IDENTITY_INSERT dbo.images ON;
INSERT INTO dbo.images (id, arrangement_id, title, filename, uploaded_at) VALUES
 (1, 1, 'Anniversary Banner', 'anniversary_banner.jpg', '2025-03-01T12:05:00'),
 (2, 2, 'Fjord Trip Map', 'fjord_map.png', '2025-05-21T08:30:00');
SET IDENTITY_INSERT dbo.images OFF;
GO

SET IDENTITY_INSERT dbo.news ON;
INSERT INTO dbo.news (id, title, body, start_time, end_time, author_id, is_approved, created_at) VALUES
 (1, 'Clubhouse Rules', 'Please note the new opening hours and rules for the clubroom.', '2025-01-01T00:00:00', '2026-01-01T00:00:00', 1, 0, '2025-01-01T07:00:00'),
 (2, 'Regatta Results', 'Results of last month''s regatta are now posted.', '2024-11-01T00:00:00', '2025-12-01T00:00:00', 2, 1, '2024-11-02T12:00:00'),
 (3, 'Maintenance Closure', 'The clubroom will be closed for maintenance between Nov 20-25.', '2025-11-20T00:00:00', '2025-11-25T23:59:59', 3, 0, '2025-11-18T10:00:00');
SET IDENTITY_INSERT dbo.news OFF;
GO

-- reseed identity values using variables

DECLARE @maxId INT;

-- categories
SELECT @maxId = ISNULL(MAX(id), 0) FROM dbo.categories;
DBCC CHECKIDENT ('dbo.categories', RESEED, @maxId);

-- members
SELECT @maxId = ISNULL(MAX(id), 0) FROM dbo.members;
DBCC CHECKIDENT ('dbo.members', RESEED, @maxId);

-- arrangements
SELECT @maxId = ISNULL(MAX(id), 0) FROM dbo.arrangements;
DBCC CHECKIDENT ('dbo.arrangements', RESEED, @maxId);

-- images
SELECT @maxId = ISNULL(MAX(id), 0) FROM dbo.images;
DBCC CHECKIDENT ('dbo.images', RESEED, @maxId);

-- news
SELECT @maxId = ISNULL(MAX(id), 0) FROM dbo.news;
DBCC CHECKIDENT ('dbo.news', RESEED, @maxId);
GO
