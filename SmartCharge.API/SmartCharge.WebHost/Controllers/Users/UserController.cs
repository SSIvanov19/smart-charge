﻿using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharge.Services.Contracts;
using SmartCharge.Shared.Models.Auth.User;
using SmartCharge.Shared.Models.Auth;
using SmartCharge.Shared.Models;

namespace SmartCharge.WebHost.Controllers.Users;


/// <summary>
/// Controller for managing users.
/// </summary>
[Route("api/user")]
[ApiController]
[Authorize]
public class UserController : ControllerBase
{
    private readonly IUserService userService;
    private readonly IAuthService authService;
    private readonly ICurrentUser currentUser;
    private readonly IMapper mapper;
    private readonly ILogger<UserController> logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="UserController"/> class.
    /// </summary>
    /// <param name="userService">User Service.</param>
    /// <param name="authService">Auth Service.</param>
    /// <param name="currentUser">Current User.</param>
    /// <param name="mapper">Mapper.</param>
    /// <param name="logger">Logger.</param>
    public UserController(
        IUserService userService,
        IAuthService authService,
        ICurrentUser currentUser,
        IMapper mapper,
        ILogger<UserController> logger)
    {
        this.userService = userService;
        this.authService = authService;
        this.currentUser = currentUser;
        this.mapper = mapper;
        this.logger = logger;
    }

    /// <summary>
    /// Gets info of the current user.
    /// </summary>
    /// <returns>Response with the result.</returns>
    [HttpGet("current")]
    public async Task<ActionResult<UserVM>> GetUserMeAsync()
    {
        var result = await this.userService.GetUserByIdAsync(this.currentUser.UserId);

        if (result is null)
        {
            return this.NotFound();
        }

        return result;
    }

    /// <summary>
    /// Changes the password of the current user.
    /// </summary>
    /// <param name="updatePasswordModel">Update password model.</param>
    /// <returns>Response with the result.</returns>
    [HttpPost("change-password")]
    public async Task<IActionResult> ChangerUserPasswordAsync([FromBody] UpdatePasswordModel updatePasswordModel)
    {
        this.logger.LogInformation("Changing password for user with id {UserId}", this.currentUser.UserId);

        var user = await this.userService.GetUserByIdAsync(this.currentUser.UserId);

        if (!await this.authService.CheckIsPasswordCorrectAsync(user!.Email, updatePasswordModel.OldPassword))
        {
            this.logger.LogWarning("Changing password for user with id {UserId} failed. Old password is incorrect.", this.currentUser.UserId);

            return this.BadRequest(new Response
            {
                Status = "password-change-failed",
                Message = "Old password is incorrect",
            });
        }

        var result = await this.userService.ChangePasswordAsync(this.currentUser.UserId, updatePasswordModel.NewPassword);

        if (!result.Succeeded)
        {
            this.logger.LogWarning("Changing password for user with id {UserId} failed. {Errors}", this.currentUser.UserId, result.Errors.First().Description);

            return this.BadRequest(new Response
            {
                Status = "password-change-failed",
                Message = result.Errors.FirstOrDefault()?.Description,
            });
        }

        this.logger.LogInformation("Changing password for user with id {UserId} succeeded.", this.currentUser.UserId);

        return this.Ok(new Response
        {
            Status = "password-changed-success",
            Message = "Password change successful",
        });
    }

    /// <summary>
    /// Updates the current user.
    /// </summary>
    /// <param name="model">User Update Model.</param>
    /// <returns>Response with the result.</returns>
    [HttpPut]
    public async Task<IActionResult> UpdateUserAsync([FromBody] UserUM model)
    {
        this.logger.LogInformation("Updating user with id {UserId}", this.currentUser.UserId);

        var user = await this.userService.GetUserByIdAsync(this.currentUser.UserId);

        if (user is null)
        {
            this.logger.LogWarning("Updating user with id {UserId} failed. User not found.", this.currentUser.UserId);

            return this.NotFound(new Response
            {
                Status = "user-update-failed",
                Message = "User not found",
            });
        }

        var result = await this.userService.UpdateUserAsync(user.Email, model);

        if (!result)
        {
            this.logger.LogWarning("Updating user with id {UserId} failed.", this.currentUser.UserId);

            return this.BadRequest(new Response
            {
                Status = "update-failed",
            });
        }

        this.logger.LogInformation("Updating user with id {UserId} succeeded.", this.currentUser.UserId);

        return this.Ok(new Response
        {
            Status = "update-success",
            Message = "User updated successfully",
        });
    }
}

