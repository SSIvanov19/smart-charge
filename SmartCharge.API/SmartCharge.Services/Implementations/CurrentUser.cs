﻿using Microsoft.AspNetCore.Http;
using SmartCharge.Services.Contracts;
using System.Security.Claims;

namespace SmartCharge.Services.Implementations;


/// <summary>
/// Class that implements <see cref="ICurrentUser"/>.
/// </summary>
internal class CurrentUser : ICurrentUser
{
    /// <summary>
    /// Initializes a new instance of the <see cref="CurrentUser"/> class.
    /// </summary>
    /// <param name="httpContextAccessor">HTTP Context Accessors.</param>
    public CurrentUser(IHttpContextAccessor httpContextAccessor)
    {
        this.UserId = httpContextAccessor?
            .HttpContext?
            .User
            .Claims
            .FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?
            .Value!;
    }

    /// <inheritdoc/>
    public string UserId { get; }
}

