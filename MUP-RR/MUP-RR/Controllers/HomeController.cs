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

		[HttpPost]
		public ActionResult DeleteRule(int id){
			Console.WriteLine("-----------");
			database.DeleteMup(id);
			return RedirectToAction("Interface");
		}
		
		[HttpGet]
		public ActionResult AddRule(){
			ViewData["P"] = database.SelectProfile();
			ViewData["V"] = database.SelectVinculo();
			ViewData["CSG"] = database.SelectClassroomGroup();
			ViewData["UO"] = database.SelectUO();
			
			return View();
		}
		[HttpPost]
		public ActionResult AddRule(MupRuleForm newrule){
			MupTable _temp = new MupTable();
			var profile = database.SelectProfileByName(newrule.profile);
			_temp.profile = profile.id.ToString();

			var classroomGroup = database.SelectClassroomGroupByName(newrule.classGroup);
			_temp.classGroup = classroomGroup.id.ToString();

			var uo = database.selectUnidadeOrganicaBySigla(newrule.uo);
			_temp.uo = uo.id;

			var vinculo = database.selectVinculoBySigla(newrule.vinculo);
			_temp.vinculo = vinculo.id;

			database.InsertMup(_temp);
			return RedirectToAction("interface", "home");;
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
