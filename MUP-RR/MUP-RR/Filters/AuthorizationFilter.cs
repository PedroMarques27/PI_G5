using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;

namespace MUP_RR
{
    public class CustomAuthorizationAttribute : ActionFilterAttribute
    {
        public string Roles { get; set; }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            bool autorizado = new Helpers.RoleAuthorization(Roles, filterContext.HttpContext.Session).UserAuthorized;

            if (!autorizado)
                filterContext.Result = new RedirectResult("~/Error/NoPermissions");
        }
    }
}