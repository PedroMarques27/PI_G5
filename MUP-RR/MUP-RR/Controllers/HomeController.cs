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
			return View();
		}
		public ActionResult Interface()
		{
		 	ViewData["MUP-Table"] = translateMup();
			return View();
		}
		List<Tuple<int, string, string, string, string>> translateMup(){
			List<MupTable> mupTable = database.SelectMup();


			List<Tuple<int, string, string, string, string>> translation = new List<Tuple<int,string, string, string, string>>();
			foreach (var item in mupTable)
			{
				
				var profile = database.SelectProfileById(item.profile);
				var classroomGroup = database.SelectClassroomGroupById(item.classGroup);
				var uo = database.SelectUoById(item.uo.ToString());
				var vinculo = database.SelectVinculoById(item.vinculo);
				var _temp = new Tuple<int,string, string, string, string>(item.id,profile.name, classroomGroup.name, uo.sigla, vinculo.sigla);
				translation.Add(_temp);
			}

			return translation;
		} 
		
		
	}

	

}
