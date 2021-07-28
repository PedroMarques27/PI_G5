using System;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using System.Collections.Generic;
using System.Linq;

namespace MUP_RR.Controllers
{
    [ValidateUserInSessionFilter]
    [CustomAuthorization(Roles = "user,admin")]
    public class InformationController : Controller
    {
        public DBConnector database = new DBConnector();
        private readonly DbModels.muprrdevContext _db;

        public InformationController(DbModels.muprrdevContext db)
        {
            _db = db;
        }

        public ActionResult Index()
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
    }
}