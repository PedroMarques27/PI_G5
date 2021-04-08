using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using System.Net.Http;

using Newtonsoft.Json;

namespace MUP_RR.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

      

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }


        public async Task<IActionResult> Index()
        {
            List<Building> reservationList = new List<Building>();
            Console.WriteLine("----------------------------------------------------------------------------------------+++++++++++");
            using (var httpClient = new HttpClient())
            {
                using (var response = await httpClient.GetAsync("https://bullet-api.dev.ua.pt/api/Buildings"))
                {
                    string apiResponse = await response.Content.ReadAsStringAsync();
                    Console.WriteLine(apiResponse);
                    reservationList = JsonConvert.DeserializeObject<List<Building>>(apiResponse);
                }
            }
       
            
            return View(reservationList);
        }
    

    }
}
