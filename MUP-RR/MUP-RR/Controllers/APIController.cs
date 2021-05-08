using System;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using System.Collections.Generic;


namespace MUP_RR.Controllers
{
    public class APIController : Controller
    {
        Program currentProgram = new Program();
        // GET: Method To Start Function  
        public string Index()  
        {  
            return "This is Index action method of StudentController";
        }  
  
        [HttpPost]
        [Route("api/v1/notify")]
        public IActionResult UpdatePermissions([FromBody] RCUNotification notification)
        {
            //currentProgram.UpdateProfile(iupi);
            Console.WriteLine(notification.pairs[0][0]);
            //Debug.WriteLine(pairs);
            return Ok();
        }
    }

}
