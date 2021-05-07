
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;


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
  
        [HttpGet]
        [Route("api/v1/notify/{iupi}")]
        public string GetAuthor(string iupi)
        {
            currentProgram.UpdateProfile(iupi);
            return "This Is "+ iupi;
        }
    }

}
