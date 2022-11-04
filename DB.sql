USE [master]
GO
/****** Object:  Database [WorkOutDB]    Script Date: 11/1/2022 10:21:00 AM ******/
CREATE DATABASE [WorkOutDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WorkOutDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WorkOutDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WorkOutDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WorkOutDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [WorkOutDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WorkOutDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WorkOutDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WorkOutDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WorkOutDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WorkOutDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WorkOutDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [WorkOutDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WorkOutDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WorkOutDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WorkOutDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WorkOutDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WorkOutDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WorkOutDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WorkOutDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WorkOutDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WorkOutDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WorkOutDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WorkOutDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WorkOutDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WorkOutDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WorkOutDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WorkOutDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WorkOutDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WorkOutDB] SET RECOVERY FULL 
GO
ALTER DATABASE [WorkOutDB] SET  MULTI_USER 
GO
ALTER DATABASE [WorkOutDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WorkOutDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WorkOutDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WorkOutDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WorkOutDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WorkOutDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'WorkOutDB', N'ON'
GO
ALTER DATABASE [WorkOutDB] SET QUERY_STORE = OFF
GO
USE [WorkOutDB]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 11/1/2022 10:21:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[Modified] [datetimeoffset](7) NULL,
	[Rowversion] [timestamp] NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exercises]    Script Date: 11/1/2022 10:21:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exercises](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[VideoLink] [varchar](max) NULL,
	[CategoryId] [int] NOT NULL,
	[Rowversion] [timestamp] NULL,
	[IsAerobic] [bit] NOT NULL,
 CONSTRAINT [PK_Exercises] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduleDailyExercises]    Script Date: 11/1/2022 10:21:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleDailyExercises](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleId] [int] NOT NULL,
	[ExerciseId] [int] NOT NULL,
	[Date] [datetimeoffset](7) NOT NULL,
	[Rowversion] [timestamp] NULL,
 CONSTRAINT [PK_ScheduleExercise] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Schedules]    Script Date: 11/1/2022 10:21:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedules](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetimeoffset](7) NOT NULL,
	[EndDate] [datetimeoffset](7) NOT NULL,
	[Rowversion] [timestamp] NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exercises] ADD  CONSTRAINT [DF_Exercises_IsAerobic]  DEFAULT ((0)) FOR [IsAerobic]
GO
ALTER TABLE [dbo].[Exercises]  WITH CHECK ADD  CONSTRAINT [FK_Exercises_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Exercises] CHECK CONSTRAINT [FK_Exercises_Categories]
GO
ALTER TABLE [dbo].[ScheduleDailyExercises]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleExercise_Exercises] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercises] ([Id])
GO
ALTER TABLE [dbo].[ScheduleDailyExercises] CHECK CONSTRAINT [FK_ScheduleExercise_Exercises]
GO
ALTER TABLE [dbo].[ScheduleDailyExercises]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleExercise_Schedule] FOREIGN KEY([ScheduleId])
REFERENCES [dbo].[Schedules] ([Id])
GO
ALTER TABLE [dbo].[ScheduleDailyExercises] CHECK CONSTRAINT [FK_ScheduleExercise_Schedule]
GO
USE [master]
GO
ALTER DATABASE [WorkOutDB] SET  READ_WRITE 
GO

INSERT INTO Categories (Name, Description)
VALUES ('SampleCategoryName', 'SampleCategoryDescription');

INSERT INTO Exercises(Name, Description, VideoLink, CategoryId)
VALUES ('SampleExerciseName', 'SampleExerciseDescription', 'SampleExerciseVideoLink', 1);

INSERT INTO Schedules(StartDate, EndDate)
VALUES ('2022-11-16 00:00:00.0000000 +02:00', '2022-11-23 00:00:00.0000000 +02:00');