using System;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using System.Collections.Generic;


namespace MUP_RR.Controllers
{
	public class HomeController : Controller
	{
		public DBConnector database = new DBConnector();


		public ActionResult Index()
		{
		 	//ViewData["MUP-Table"] = database.SelectMup();

			return View();
		}
		/*
		List<Tuple<string, string, string, string>> translateMup(){
			List<MupTable> mupTable = database.SelectMup();


			List<Tuple<int, string, string, string, string>> translation = new List<Tuple<int,string, string, string, string>>();
			foreach (var item in mupTable)
			{
				var profile = database.SelectProfileById(item.profile);
				var classroomGroup = database.SelectClassroomGroupById(item.classGroup);
				var uo = database.SelectUoById(item.uo);
				var vinculo = database.SelectVinculoById(item.vinculo);
			}


		
		} 
		*/
		
	}

	

}
