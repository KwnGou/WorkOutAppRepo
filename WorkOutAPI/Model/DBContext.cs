using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace WorkOutAPI.Model
{
    public partial class DBContext : DbContext
    {
         public DBContext(DbContextOptions<DBContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Category> Categories { get; set; } = null!;
        public virtual DbSet<Exercis> Exercises { get; set; } = null!;
        public virtual DbSet<Schedule> Schedules { get; set; } = null!;
        public virtual DbSet<ScheduleDailyExercis> ScheduleDailyExercises { get; set; } = null!;


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Category>(entity =>
            {
                entity.Property(e => e.Description).HasMaxLength(100);

                entity.Property(e => e.Name).HasMaxLength(50);

                entity.Property(e => e.Rowversion)
                    .IsRowVersion()
                    .IsConcurrencyToken();
            });

            modelBuilder.Entity<Exercis>(entity =>
            {
                entity.Property(e => e.Description).HasMaxLength(255);

                entity.Property(e => e.Name).HasMaxLength(50);

                entity.Property(e => e.Rowversion)
                    .IsRowVersion()
                    .IsConcurrencyToken();

                entity.Property(e => e.VideoLink).IsUnicode(false);

                entity.HasOne(d => d.Category)
                    .WithMany(p => p.Exercis)
                    .HasForeignKey(d => d.CategoryId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Exercises_Categories");
            });

            modelBuilder.Entity<Schedule>(entity =>
            {
                entity.Property(e => e.Rowversion)
                    .IsRowVersion()
                    .IsConcurrencyToken();
            });

            modelBuilder.Entity<ScheduleDailyExercis>(entity =>
            {
                entity.Property(e => e.Rowversion)
                    .IsRowVersion()
                    .IsConcurrencyToken();

                entity.HasOne(d => d.Exercise)
                    .WithMany(p => p.ScheduleDailyExercis)
                    .HasForeignKey(d => d.ExerciseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ScheduleExercise_Exercises");

                entity.HasOne(d => d.Schedule)
                    .WithMany(p => p.ScheduleDailyExercis)
                    .HasForeignKey(d => d.ScheduleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ScheduleExercise_Schedule");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
