using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace SmartCharge.Data.Data;

public class User : IdentityUser
{
    /// <summary>
    /// Gets or sets first name of the user.
    /// </summary>
    [Required]
    public string FirstName { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets last name of the user.
    /// </summary>
    [Required]
    public string LastName { get; set; } = string.Empty;
}
