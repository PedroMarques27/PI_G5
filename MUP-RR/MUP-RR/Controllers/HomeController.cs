using System;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Extensions.Configuration;

namespace MUP_RR.Controllers
{
    public class HomeController : Controller
    {
        private readonly IConfiguration _config;

        public HomeController(IConfiguration configuration)
        {
            _config = configuration;
        }

        public ActionResult Index()
        {
            return View();
        }

        public IActionResult SingleLogout()
        {
            HttpContext.Session.Clear();
            string returnTo = HttpContext.Request.Query["return"].ToString();
            if (!string.IsNullOrEmpty(returnTo))
                return Redirect(returnTo);
            return Redirect("/");
        }

        public IActionResult Logout()
        {
            HttpContext.Session.Clear();

            // redireciona para logout shibboleth
            var env = new Helpers.Environment(_config);
            var session = new Helpers.Session(HttpContext.Session);
            if (env.IsLocalhost(HttpContext) || session.Impersonated)
            {
                return RedirectToAction("Index", "Home");
            }
            else
            {
                session.Logout();
                string url = this.HttpContext.Request.Query["return"].ToString();
                if (string.IsNullOrEmpty(url))
                    url = _config["Auth:LogoutPath"];

                return Redirect(url);
            }
        }
    }
}