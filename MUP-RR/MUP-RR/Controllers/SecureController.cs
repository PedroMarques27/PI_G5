using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using Microsoft.Extensions.Configuration;
using MUP_RR.Helpers;

namespace MUP_RR.Controllers
{
    [ValidateUserInSessionFilter]
    public class SecureController : Controller
    {
        private readonly IConfiguration _config;

        public SecureController(IConfiguration configuration)
        {
            _config = configuration;
        }

        // GET: Secure
        public IActionResult Index()
        {
            return RedirectToAction("Index", "Home");
        }
    }
}