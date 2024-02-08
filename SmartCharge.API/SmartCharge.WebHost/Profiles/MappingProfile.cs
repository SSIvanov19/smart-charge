using AutoMapper;
using SmartCharge.Data.Data;
using SmartCharge.Shared.Models.Auth.User;

namespace SmartCharge.WebHost.Profiles;

/// <summary>
/// Mapping profile.
/// </summary>
public class MappingProfile : Profile
{
    /// <summary>
    /// Initializes a new instance of the <see cref="MappingProfile"/> class.
    /// </summary>
    public MappingProfile()
    {
        this.CreateMap<User, UserVM>();
        this.CreateMap<UserUM, UserIM>();
    }
}
