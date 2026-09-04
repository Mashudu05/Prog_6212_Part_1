CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

/* ------------------------------------------------------------
   1. Roles
   ------------------------------------------------------------ */
CREATE TABLE Roles (
    RoleID      INT IDENTITY(1,1) PRIMARY KEY,
    RoleName    NVARCHAR(20) NOT NULL UNIQUE
);
GO

/* ------------------------------------------------------------
   2. Users  (Organisers and Participants, role-based)
   ------------------------------------------------------------ */
CREATE TABLE Users (
    UserID        INT IDENTITY(1,1) PRIMARY KEY,
    RoleID        INT NOT NULL,
    FullName      NVARCHAR(100) NOT NULL,
    Email         NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash  NVARCHAR(255) NOT NULL,
    PhoneNumber   NVARCHAR(20) NULL,
    CreatedAt     DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

/* ------------------------------------------------------------
   3. Events
   ------------------------------------------------------------ */
CREATE TABLE Events (
    EventID       INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID   INT NOT NULL,
    EventName     NVARCHAR(150) NOT NULL,
    EventType     NVARCHAR(50) NOT NULL,   -- Running, Cycling, Walking
    EventDate     DATE NOT NULL,
    Location      NVARCHAR(150) NOT NULL,
    Description   NVARCHAR(1000) NULL,
    CreatedAt     DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Users FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);
GO

/* ------------------------------------------------------------
   4. Categories
   ------------------------------------------------------------ */
CREATE TABLE Categories (
    CategoryID       INT IDENTITY(1,1) PRIMARY KEY,
    EventID          INT NOT NULL,
    CategoryName     NVARCHAR(50) NOT NULL,
    DistanceKM       DECIMAL(5,2) NOT NULL,
    EntryFee         DECIMAL(8,2) NOT NULL DEFAULT 0,
    MaxParticipants  INT NOT NULL DEFAULT 100,
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventID) REFERENCES Events(EventID)
);
GO

/* ------------------------------------------------------------
   5. EventEnrolments  (junction: Events <-> Users, via Categories)
   ------------------------------------------------------------ */
CREATE TABLE EventEnrolments (
    EnrolmentID     INT IDENTITY(1,1) PRIMARY KEY,
    EventID         INT NOT NULL,
    CategoryID      INT NOT NULL,
    ParticipantID   INT NOT NULL,
    EnrolmentDate   DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentStatus   NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    RaceNumber      NVARCHAR(10) NULL,
    CONSTRAINT FK_Enrolments_Events FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
    CONSTRAINT UQ_Enrolment UNIQUE (EventID, ParticipantID, CategoryID)
);
GO

/* ------------------------------------------------------------
   6. Results
   ------------------------------------------------------------ */
CREATE TABLE Results (
    ResultID      INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID   INT NOT NULL UNIQUE,
    FinishTime    TIME NULL,
    Position      INT NULL,
    Status        NVARCHAR(20) NOT NULL DEFAULT 'Not Started',
    RecordedAt    DATETIME NULL,
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID) REFERENCES EventEnrolments(EnrolmentID)
);
GO


/* ============================================================
   SEED DATA
   ============================================================ */

-- Roles
INSERT INTO Roles (RoleName) VALUES
('Organiser'),
('Participant');
GO

-- Users: 2 Organisers, 2 Participants
INSERT INTO Users (RoleID, FullName, Email, PasswordHash, PhoneNumber) VALUES
(1, 'Thabo Mokoena',  'thabo.mokoena@raceday.co.za',  'HASH_PLACEHOLDER_1', '0821234567'),
(1, 'Lindiwe Dlamini', 'lindiwe.dlamini@raceday.co.za', 'HASH_PLACEHOLDER_2', '0837654321'),
(2, 'Sipho Nkosi',     'sipho.nkosi@example.com',       'HASH_PLACEHOLDER_3', '0731122334'),
(2, 'Anje van der Merwe','anje.vdm@example.com',        'HASH_PLACEHOLDER_4', '0764455667');
GO

-- Events: 3 events, created by the two organisers
INSERT INTO Events (OrganiserID, EventName, EventType, EventDate, Location, Description) VALUES
(1, 'Bloemfontein Spring Marathon', 'Running', '2026-10-18', 'Bloemfontein, Free State',
    'Annual road running event through the city centre with multiple distance options.'),
(1, 'Mangaung Park Run Challenge',  'Running', '2026-11-08', 'Mangaung, Free State',
    'Community-focused park run supporting local charities.'),
(2, 'Free State Cycle Tour',        'Cycling', '2026-09-27', 'Bloemfontein, Free State',
    'Road cycling event with routes for both casual and competitive riders.');
GO

-- Categories: at least one per event (here, two per event)
INSERT INTO Categories (EventID, CategoryName, DistanceKM, EntryFee, MaxParticipants) VALUES
(1, '10km Fun Run',   10.00, 150.00, 500),
(1, '21km Half Marathon', 21.10, 250.00, 300),
(2, '5km Park Run',   5.00,  50.00,  400),
(2, '10km Challenge', 10.00, 100.00, 250),
(3, '40km Road Ride', 40.00, 200.00, 200),
(3, '80km Road Ride', 80.00, 350.00, 150);
GO

-- Event Enrolments: sample enrolments for the two participants
INSERT INTO EventEnrolments (EventID, CategoryID, ParticipantID, PaymentStatus, RaceNumber) VALUES
(1, 2, 3, 'Paid', 'BFN-1001'),
(1, 1, 4, 'Paid', 'BFN-1002'),
(2, 3, 3, 'Paid', 'MPR-2001'),
(3, 5, 4, 'Pending', 'FSC-3001');
GO

-- Results: sample results for the completed enrolments
INSERT INTO Results (EnrolmentID, FinishTime, Position, Status, RecordedAt) VALUES
(1, '01:52:30', 12, 'Finished', '2026-10-18 10:15:00'),
(2, '00:48:10', 5,  'Finished', '2026-10-18 09:20:00');
GO