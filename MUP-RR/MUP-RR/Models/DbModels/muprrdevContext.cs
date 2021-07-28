using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class muprrdevContext : DbContext
    {
        public muprrdevContext()
        {
        }

        public muprrdevContext(DbContextOptions<muprrdevContext> options)
            : base(options)
        {
        }

        public virtual DbSet<AdminTable> AdminTables { get; set; }
        public virtual DbSet<BrbRcuAssoc> BrbRcuAssocs { get; set; }
        public virtual DbSet<ClassroomGroup> ClassroomGroups { get; set; }
        public virtual DbSet<Log> Logs { get; set; }
        public virtual DbSet<Mup> Mups { get; set; }
        public virtual DbSet<Profile> Profiles { get; set; }
        public virtual DbSet<UnidadeOrganica> UnidadeOrganicas { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<UserDatum> UserData { get; set; }
        public virtual DbSet<Vinculo> Vinculos { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Server=sql-dev.ua.pt;Database=muprr-dev;Trusted_Connection=True;MultipleActiveResultSets=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:Collation", "Latin1_General_CI_AS");

            modelBuilder.Entity<AdminTable>(entity =>
            {
                entity.HasKey(e => e.Iupi)
                    .HasName("PK__AdminTab__9975570128753919");

                entity.ToTable("AdminTable", "MUPRR");

                entity.Property(e => e.Iupi)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("iupi");
            });

            modelBuilder.Entity<BrbRcuAssoc>(entity =>
            {
                entity.HasKey(e => e.RcuId)
                    .HasName("PK__BRB_RCU___104E8C5A3280C5BC");

                entity.ToTable("BRB_RCU_ASSOC", "MUPRR");

                entity.Property(e => e.RcuId)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("RCU_ID");

                entity.Property(e => e.BrbId)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("BRB_ID");

                entity.Property(e => e.Uu)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("UU");
            });

            modelBuilder.Entity<ClassroomGroup>(entity =>
            {
                entity.ToTable("ClassroomGroup", "MUPRR");

                entity.Property(e => e.Id)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("id");

                entity.Property(e => e.Name)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("name");
            });

            modelBuilder.Entity<Log>(entity =>
            {
                entity.ToTable("logs", "MUPRR");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Context)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("context");

                entity.Property(e => e.Date)
                    .HasColumnType("datetime")
                    .HasColumnName("date")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Description)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("description");
            });

            modelBuilder.Entity<Mup>(entity =>
            {
                entity.ToTable("MUP", "MUPRR");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.ClassGroup)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("classGroup");

                entity.Property(e => e.Profile)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("profile");

                entity.Property(e => e.Uo).HasColumnName("uo");

                entity.Property(e => e.Vinculo).HasColumnName("vinculo");

                entity.HasOne(d => d.ClassGroupNavigation)
                    .WithMany(p => p.Mups)
                    .HasForeignKey(d => d.ClassGroup)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__MUP__classGroup__4AB81AF0");

                entity.HasOne(d => d.ProfileNavigation)
                    .WithMany(p => p.Mups)
                    .HasForeignKey(d => d.Profile)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__MUP__profile__49C3F6B7");

                entity.HasOne(d => d.UoNavigation)
                    .WithMany(p => p.Mups)
                    .HasForeignKey(d => d.Uo)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__MUP__uo__47DBAE45");

                entity.HasOne(d => d.VinculoNavigation)
                    .WithMany(p => p.Mups)
                    .HasForeignKey(d => d.Vinculo)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__MUP__vinculo__48CFD27E");
            });

            modelBuilder.Entity<Profile>(entity =>
            {
                entity.ToTable("Profile", "MUPRR");

                entity.HasIndex(e => e.Priority, "priority_unique")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("id");

                entity.Property(e => e.Name)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("name");

                entity.Property(e => e.Priority).HasColumnName("priority");
            });

            modelBuilder.Entity<UnidadeOrganica>(entity =>
            {
                entity.ToTable("UnidadeOrganica", "MUPRR");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Descricao)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("descricao");

                entity.Property(e => e.Sigla)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("sigla");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("User", "MUPRR");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Active)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.Iupi).HasColumnName("IUPI");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(400)
                    .IsFixedLength(true);

                entity.Property(e => e.Uu)
                    .IsRequired()
                    .HasMaxLength(200)
                    .HasColumnName("UU")
                    .IsFixedLength(true);
            });

            modelBuilder.Entity<UserDatum>(entity =>
            {
                entity.HasKey(e => new { e.Id, e.Uo, e.Vinculo })
                    .HasName("PK__UserData__87D5A88A598B7A2D");

                entity.ToTable("UserData", "MUPRR");

                entity.Property(e => e.Id)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("id");

                entity.Property(e => e.Uo).HasColumnName("uo");

                entity.Property(e => e.Vinculo).HasColumnName("vinculo");

                entity.HasOne(d => d.IdNavigation)
                    .WithMany(p => p.UserData)
                    .HasForeignKey(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__UserData__id__76969D2E");

                entity.HasOne(d => d.UoNavigation)
                    .WithMany(p => p.UserData)
                    .HasForeignKey(d => d.Uo)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__UserData__uo__74AE54BC");

                entity.HasOne(d => d.VinculoNavigation)
                    .WithMany(p => p.UserData)
                    .HasForeignKey(d => d.Vinculo)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__UserData__vincul__75A278F5");
            });

            modelBuilder.Entity<Vinculo>(entity =>
            {
                entity.ToTable("Vinculo", "MUPRR");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Descricao)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("descricao");

                entity.Property(e => e.Sigla)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("sigla");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}