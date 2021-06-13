using System;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using System.Collections.Generic;
using System.Linq;


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
			HashSet<Profile> distinct = new HashSet<Profile>(database.SelectProfile());
			ViewData["Profiles"] = distinct;
			var logs = database.SelectLogsByDate();
			ViewData["LOGS"] = logs;
			return View();
		}

		public ActionResult InfoPage()
		{
			List<Vinculo> vinculos = database.SelectVinculo();
			List<Tuple<string, string>> vTable = vinculos.Select(x => new Tuple<string, string>(x.sigla, x.description)).ToList();
			ViewData["Vinculo-Table"] = vTable;

			List<UO> uos = database.SelectUO();
			List<Tuple<string, string>> uTable = uos.Select(x => new Tuple<string, string>(x.sigla, x.description)).ToList();
			ViewData["UO-Table"] = uTable;

			
			HashSet<Profile> profiles = new HashSet<Profile>(database.SelectProfile());
			ViewData["Profile-Table"] = profiles;

			
			HashSet<ClassroomGroup> crgs = new HashSet<ClassroomGroup>(database.SelectClassroomGroup());
			ViewData["CRG-Table"] = crgs;
			return View();
		}

		[HttpPost]
		public ActionResult DeleteRule(int id){
			database.DeleteMup(id);
			return RedirectToAction("Interface");
		}
		[HttpPost]
		public ActionResult ChangePriority(int id, int priority){
			var currentProfile = database.SelectProfileById(id.ToString());
			database.UpdatePriorityOfProfiles(currentProfile.priority, priority);

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
