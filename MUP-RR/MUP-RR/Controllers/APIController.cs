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

        public string Index()  
        {  
            return "This is Index action method of StudentController";
        }  
  
        [HttpPost]
        [Route("api/v1/notify")]
        public IActionResult UpdatePermissions([FromBody] RCUNotification notification)
        {
            Console.WriteLine("++++++++++++++++++++++++++++++++++++++++++++++++++++++");
            List<Tuple<UO,Vinculo>> formated_pairs = new List<Tuple<UO, Vinculo>>();

            foreach (List<string> pair in notification.pairs)
            {
                Vinculo v = currentProgram.database.selectVinculoBySigla(pair[0]);
                UO uo = currentProgram.database.selectUnidadeOrganicaBySigla(pair[1]);
                formated_pairs.Add(Tuple.Create(uo, v));
            }
            currentProgram.UpdateProfile(notification.iupi, formated_pairs);
            return Ok();
        }
    }

}
