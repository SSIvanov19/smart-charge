using Microsoft.Extensions.DependencyInjection;
using SmartCharge.Services.Contracts;
using SmartCharge.Services.Implementations;

namespace SmartCharge.Services;

/// <summary>
/// Static class for dependency injection.
/// </summary>
public static class DependencyInjection
{
    /// <summary>
    /// Add Services.
    /// </summary>
    /// <param name="services">Services.</param>
    public static void AddServices(this IServiceCollection services)
    {
        services
            .AddScoped<ICurrentUser, CurrentUser>()
            .AddScoped<IAuthService, AuthService>()
            .AddScoped<ITokenService, TokenService>()
            .AddScoped<IUserService, UserService>()
            .AddScoped<IEmailService, EmailService>();
    }
}
