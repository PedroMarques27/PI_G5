using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace MUP_RR.Controllers
{
    public class ErrorController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public ErrorController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult NoPermissions()
        {
            return View();
        }
    }
}