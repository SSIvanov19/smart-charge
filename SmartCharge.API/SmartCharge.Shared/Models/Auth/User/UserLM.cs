using System.ComponentModel.DataAnnotations;

namespace SmartCharge.Shared.Models.Auth.User;

public class UserLM
{
    /// <summary>
    /// Gets or sets the email address of the user.
    /// </summary>
    [EmailAddress]
    [Required(ErrorMessage = "Email is required")]
    public string Email { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the password of the user.
    /// </summary>
    [Required(ErrorMessage = "Password is required")]
    public string Password { get; set; } = string.Empty;
}
