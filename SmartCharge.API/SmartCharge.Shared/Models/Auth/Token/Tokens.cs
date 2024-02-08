using System.IdentityModel.Tokens.Jwt;

namespace SmartCharge.Shared.Models.Auth.Token;

public class Tokens
{
    /// <summary>
    /// Gets or sets access token.
    /// </summary>
    public JwtSecurityToken AccessToken { get; set; } = new();

    /// <summary>
    /// Gets or sets refresh token.
    /// </summary>
    public JwtSecurityToken RefreshToken { get; set; } = new();
}
