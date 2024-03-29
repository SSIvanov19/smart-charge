﻿namespace SmartCharge.Shared.Models;

/// <summary>
/// An API Response.
/// </summary>
public class Response
{
    /// <summary>
    /// Gets or sets the status of the response.
    /// </summary>
    public string Status { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the message of the response.
    /// </summary>
    public string Message { get; set; } = string.Empty;
}

