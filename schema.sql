-- Drop if exists (safe for re-running during development)
IF OBJECT_ID('dbo.images', 'U') IS NOT NULL DROP TABLE dbo.images;
IF OBJECT_ID('dbo.news', 'U') IS NOT NULL DROP TABLE dbo.news;
IF OBJECT_ID('dbo.arrangements', 'U') IS NOT NULL DROP TABLE dbo.arrangements;
IF OBJECT_ID('dbo.members', 'U') IS NOT NULL DROP TABLE dbo.members;
IF OBJECT_ID('dbo.categories', 'U') IS NOT NULL DROP TABLE dbo.categories;
GO

-- Categories
CREATE TABLE dbo.categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Members
CREATE TABLE dbo.members (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    phone NVARCHAR(50) NULL,
    username NVARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME2 NOT NULL DEFAULT (GETDATE())
);
GO

-- Arrangements (events)
CREATE TABLE dbo.arrangements (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    responsible_member_id INT NOT NULL,
    category_id INT NOT NULL,
    start_time DATETIME2 NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    max_participants INT NULL,
    description NVARCHAR(MAX) NULL,
    place_type NVARCHAR(20) NOT NULL DEFAULT ('club'), -- 'club' or 'other'
    place_details NVARCHAR(255) NULL,
    created_at DATETIME2 NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT chk_place_type CHECK (place_type IN ('club','other'))
);
GO

-- Enforce: if place_type = 'other' then place_details is not null
ALTER TABLE dbo.arrangements
ADD CONSTRAINT chk_place_details_other
CHECK (place_type = 'club' OR (place_type = 'other' AND place_details IS NOT NULL));
GO

-- Foreign keys for arrangements
ALTER TABLE dbo.arrangements
ADD CONSTRAINT fk_arrangements_responsible_member
FOREIGN KEY (responsible_member_id) REFERENCES dbo.members(id)
    ON DELETE NO ACTION;
GO

ALTER TABLE dbo.arrangements
ADD CONSTRAINT fk_arrangements_category
FOREIGN KEY (category_id) REFERENCES dbo.categories(id)
    ON DELETE NO ACTION;
GO

-- Images attached to arrangements (one-to-many)
CREATE TABLE dbo.images (
    id INT IDENTITY(1,1) PRIMARY KEY,
    arrangement_id INT NULL,
    title NVARCHAR(255) NULL,
    filename NVARCHAR(255) NOT NULL,
    uploaded_at DATETIME2 NOT NULL DEFAULT (GETDATE())
);
GO

ALTER TABLE dbo.images
ADD CONSTRAINT fk_images_arrangement
FOREIGN KEY (arrangement_id) REFERENCES dbo.arrangements(id)
    ON DELETE CASCADE;
GO

-- News
CREATE TABLE dbo.news (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    body NVARCHAR(MAX) NOT NULL,
    start_time DATETIME2 NOT NULL,
    end_time DATETIME2 NOT NULL,
    author_id INT NULL,
    is_approved BIT NOT NULL DEFAULT (0),
    created_at DATETIME2 NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT chk_news_time CHECK (end_time >= start_time)
);
GO

ALTER TABLE dbo.news
ADD CONSTRAINT fk_news_author
FOREIGN KEY (author_id) REFERENCES dbo.members(id)
    ON DELETE SET NULL;
GO

-- Index recommendations
CREATE INDEX idx_arrangements_category ON dbo.arrangements(category_id);
CREATE INDEX idx_arrangements_start ON dbo.arrangements(start_time);
CREATE INDEX idx_arrangements_place_type ON dbo.arrangements(place_type);
CREATE INDEX idx_images_arrangement ON dbo.images(arrangement_id);
CREATE INDEX idx_news_approved_time ON dbo.news(is_approved, start_time, end_time);
GO
