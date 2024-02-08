using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using SmartCharge.Data.Models.Auth;

namespace SmartCharge.Data.Data;

/// <summary>
/// Application database context.
/// </summary>
public class ApplicationDbContext : IdentityDbContext<User>
{
    /// <summary>
    /// Initializes a new instance of the <see cref="ApplicationDbContext"/> class.
    /// </summary>
    /// <param name="options">Options.</param>
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
       : base(options)
    {
    }

    /// <summary>
    /// Gets or sets RefreshTokens.
    /// </summary>
    public virtual DbSet<RefreshToken> RefreshTokens { get; set; }

    /// <summary>
    /// On model creating.
    /// </summary>
    /// <param name="builder">Builder.</param>
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
    }
}
