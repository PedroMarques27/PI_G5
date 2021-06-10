using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using MUP_RR.Models;

using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using MUP_RR.Controllers;
using System.Linq;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Text;
using System.Runtime.Serialization.Json;
using System.IO;
using System.Threading;


namespace MUP_RR
{
    class Program
    {

        public DBConnector database = new DBConnector();
        private int NEW_USERS_PERIOD = 7200000;
        private bool INITIALIZING = true;
        static void Main(string[] args)
        {
            BRBConnector.OpenConnection();
            Program obj = new Program();
            obj.database.addLog(LOG.INFO, "Initializing MUP-RR");
            
            Task.Factory.StartNew(obj.startPeriodicTasks);
            CreateHostBuilder(args).Build().Run();
        }

        public void startPeriodicTasks(){
            while(true){
                database.addLog(LOG.INFO, "Starting Database Update");
                updateDatabaseWithNewBrbData();
                updateNewBRBUsers();
                INITIALIZING = false;
                Thread.Sleep(NEW_USERS_PERIOD); 
            }
            

        }
        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
        
        public async void UpdateProfile(string iupi, List<Tuple<UO,Vinculo>> pairs){
            database.addLog(LOG.INFO, "Determining new User Permissions");
            MupTable finalDecision = new MupTable();  
            HashSet<Profile> profiles = new HashSet<Profile>();
            HashSet<ClassroomGroup> classroomGroups = new HashSet<ClassroomGroup>();
            foreach (Tuple<UO, Vinculo> item in pairs)
            {
                UO currentUO = item.Item1;
                Vinculo currentVinculo = item.Item2;
                List<MupTable> queryResult= database.SelectSpecificMup(currentUO.id, currentVinculo.id);
               
                foreach (var qritem in queryResult)
                {
                    profiles.Add(database.SelectProfileById(qritem.profile));
                    classroomGroups.Add(database.SelectClassroomGroupById(qritem.classGroup));
                }

                if (queryResult.Count()==0){
                    profiles.Add(database.SelectProfileByName("Default"));
                }
            }
           
            var higher = Profile.getHigherStatus(profiles);
            var brbId = database.SelectUserFromIUPI(iupi).brb_id;
            string json = await BRBConnector.getUserById(brbId);

            JObject jObject = JObject.Parse(json);
            var jsonUser = jObject["data"];
            BRB_User newUser = new BRB_User();
            newUser = newUser.fromJson(jsonUser.ToString());
            newUser.profile = higher;
            database.addLog(LOG.INFO, "New User Permissions Defined");
            updateBRBUser(newUser, classroomGroups);
        }
        public async void updateBRBUser(BRB_User updatedUser, HashSet<ClassroomGroup> newGroups){
            database.addLog(LOG.INFO, "Updating User "+updatedUser.email);
            HashSet<int> groupsToDelete = new HashSet<int>();
            HashSet<int> groupsToAdd = new HashSet<int>();

            HashSet<int> currentIds = updatedUser.getClassesIds(updatedUser.userClassroomGroupBookings);
            HashSet<int> latestIds = updatedUser.getClassesIds(newGroups);
           
            foreach (int item in latestIds)
            {
                if (!currentIds.Contains(item)){
                    groupsToAdd.Add(item);
                }
            }
            foreach (int item in currentIds)
            {
                if (!latestIds.Contains(item)){
                    groupsToDelete.Add(item);
                }
            }

            JArray classes = new JArray(
                from p in groupsToDelete
                orderby p
                select 
                new JObject(
                    new JProperty("model",
                        new JObject(
                            new JProperty("userEmail",  updatedUser.email),
                            new JProperty("classroomGroupBookingId",p)
                        )
                    ),
                    new JProperty("status", 3))
            );
            JArray toAdd = new JArray(
                from p in groupsToAdd
                orderby p
                select 
                new JObject(
                    new JProperty("model",
                        new JObject(
                            new JProperty("userEmail", updatedUser.email),
                            new JProperty("classroomGroupBookingId", p)
                        )
                    ),
                    new JProperty("status", 1))     
            );

            JObject classRoomGroups =
            new JObject(
                new JProperty("usersClassroommGroups", new JArray(
                    new JObject(
                        new JProperty("userClassroomGroupsBooking",new JArray(classes.Union(toAdd)))
                    )
                )
            ));

            JObject profile =
            new JObject( 
                new JProperty("usersEmailProfiles", new JArray(
                    new JObject(
                        new JProperty("userEmail", updatedUser.email),
                        new JProperty("profileId", updatedUser.profile.id)
                    )
                )
            ));

           
            await BRBConnector.postUpdateUser(classRoomGroups.ToString(), profile.ToString());

            database.addLog(LOG.USER_UPDATE, "Updated User " + updatedUser.email+ " With New Permissions");
        }
        public List<Tuple<UO,Vinculo>> getUserData(string IUPI){
            database.addLog(LOG.INFO, "Retrieving User Data From RCU");  
            List<Tuple<UO,Vinculo>> tupleList = new List<Tuple<UO,Vinculo>>();
     
            try{
                var data = RCUConnector.getUserData(IUPI);
                JObject jsonObjectGeneral = JObject.Parse(data);
                JArray info = new JArray();
                try{
                    info = (JArray)(jsonObjectGeneral["Vinculo"]);
                }catch(Exception){
                    JObject singleData = (JObject)jsonObjectGeneral["Vinculo"]; 
                    info.Add(singleData);
                }
                
                foreach(JObject obj in info){
                    UO userUO  = database.selectUnidadeOrganicaBySigla(obj["unidade"]["Sigla"].ToString());
                    Vinculo vc =  database.selectVinculoBySigla(obj["tipovinculo"]["Sigla"].ToString());
                    tupleList.Add(new Tuple<UO, Vinculo>(userUO,vc));
                }
                database.addLog(LOG.INFO, "User Data Retrieved From RCU");  
                return tupleList;
            }catch(Exception){
                return new List<Tuple<UO,Vinculo>>();
            }
        }
        
        //Async Periodic Functions
    
        public async void updateNewBRBUsers(){
            database.addLog(LOG.INFO, "Retrieving New Users From BRB");  
            DateTime time;
            if (INITIALIZING){
                time = database.SelectLatestLogByContext(LOG.NEW_USER);
            }else{
                time = DateTime.Now.AddDays(-1);
            }
            String data;
            if (time == null)
                data = await BRBConnector.getUserList();
            else
                data  = await BRBConnector.getNewUsersInTimeframe(time);

            JObject jObject = JObject.Parse(data);
            List<BRB_User> usersAvailableBRB = new List<BRB_User>();
            
            foreach (var jsonUser in jObject["data"])
            {
                BRB_User newUser = new BRB_User();
                usersAvailableBRB.Add(newUser.fromJson(jsonUser.ToString()));

            }
            database.addLog(LOG.INFO, "New Users Retrieved From BRB");  
            var brb_users_added = 0;
            foreach (var user in usersAvailableBRB){
                if(database.SelectUserFromBrbId(user.id).brb_id == null && user.email.Contains("@ua.pt")){
                    var iupi = RCUConnector.getRcuIupi(user.email);
                    BRB_RCU_ASSOC newAssoc = new BRB_RCU_ASSOC();
                    newAssoc.email = user.email;
                    newAssoc.brb_id = user.id;
                    newAssoc.rcu_id = iupi;
                    
                    database.InsertUserAssociation(newAssoc);
                    database.addLog(LOG.NEW_USER, user.email +" Added To Database");  
                    brb_users_added++;
                    List<Tuple<UO,Vinculo>> userData = getUserData(iupi);
                    UpdateProfile(newAssoc.rcu_id, userData);
                }
                
            }
            database.addLog(LOG.NEW_USER, brb_users_added + " New Users Added To Database");  
            
            
        }
       
        public async void updateDatabaseWithNewBrbData(){
            database.addLog(LOG.INFO, "Retrieving New Profiles From BRB");
            var brbProfiles = await BRBConnector.getProfileList();
            var databaseProfiles = database.SelectProfile();

            var max = 0;
            var dbIds = new List<int>();
            foreach(var i in databaseProfiles){
                if (i.priority>max) max = i.priority;
                dbIds.Add(i.id);
            }
            var newProfilesCounter = 0;
            foreach (var item in brbProfiles)
            {
                if (!dbIds.Contains(item.id)){
                    max++;
                    database.InsertProfile(item, max);
                    newProfilesCounter++;
                    database.addLog(LOG.NEW_PROFILES, "Profile "+ item.name + " Added To Database");
                }                
            }
            database.addLog(LOG.NEW_PROFILES, newProfilesCounter + " New Profiles Added To Database");
            database.addLog(LOG.INFO, "Retrieving New Classroom Groups From BRB");
            var brbClassroomGroups = await BRBConnector.getClassroomGroups();
            var databaseClassroomGroups = database.SelectClassroomGroup();
            

            var classroomGroupsCounter = 0;
            dbIds = new List<int>();
            foreach(var i in databaseClassroomGroups){
                dbIds.Add(i.id);
            }
            foreach (var item in brbClassroomGroups)
            {
                if (!dbIds.Contains(item.id)){
                    database.InsertClassroomGroup(item);
                    classroomGroupsCounter++;
                     database.addLog(LOG.NEW_CLASSROOMGROUPS, "Classroom Groups "+ item.name + " Added To Database");
                }                
            }
            database.addLog(LOG.NEW_CLASSROOMGROUPS, classroomGroupsCounter + " New Classroom Groups Added To Database");
           
        }   
        
        
        
    }

}