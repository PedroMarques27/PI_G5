using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;

namespace MUP_RR
{
    public class ValidateUserInSessionFilterAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var config = context.HttpContext.RequestServices.GetService<IConfiguration>();
            var db = context.HttpContext.RequestServices
                .GetService<DbModels.muprrdevContext>();

            //Verifica dados do shiboleth
            var IsAuthenticated = new Helpers.Authentication(context.HttpContext, config, db);
            //Se existem, vai verificar se o utilizador tem autorização
            if (IsAuthenticated.Success)
            {
                return;
            }
            else
            {
                //var helper = new Microsoft.AspNetCore.Mvc.Routing.UrlHelper(filterContext);
                //var url = helper.Action("Index", "Secure");
                //filterContext.Result = new RedirectResult(url);

                context.Result = new RedirectResult("~/Error/NoPermissions");
            }
        }
    }
}