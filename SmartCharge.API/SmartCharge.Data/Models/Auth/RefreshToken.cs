using Microsoft.AspNetCore.Identity;
using SmartCharge.Data.Data;
using System.ComponentModel.DataAnnotations.Schema;

namespace SmartCharge.Data.Models.Auth;

/// <summary>
/// Refresh token model.
/// </summary>
public class RefreshToken
{
    /// <summary>
    /// Gets or sets id of the refresh token.
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// Gets or sets refresh token.
    /// </summary>
    public string? Token { get; set; }

    /// <summary>
    /// Gets or sets id of the user to which the refresh token belongs.
    /// </summary>
    public string? UserId { get; set; }

    /// <summary>
    /// Gets or sets user to which the refresh token belongs.
    /// </summary>
    [ForeignKey(nameof(UserId))]
    public User? User { get; set; }
}