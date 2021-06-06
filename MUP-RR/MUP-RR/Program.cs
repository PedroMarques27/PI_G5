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
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MUP_RR.Models;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System;
using System.Collections.Generic;
using System.Linq;
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
        private int UPDATE_DB_PERIOD = 7200000 * 24;

        static async Task Main(string[] args)
        {
            await BRBConnector.OpenConnection();
            Program obj = new Program();
            
            
            
            Task.Factory.StartNew(obj.updateDatabaseAssocTable);
            Task.Factory.StartNew(obj.updateNewBRBUsers);
            Task.Factory.StartNew(obj.updateDatabaseWithNewBrbData);
            
            CreateHostBuilder(args).Build().Run();
        }
        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
        
        
        public async void UpdateProfile(string iupi, List<Tuple<UO,Vinculo>> pairs){

            BRB_RCU_ASSOC currentUser = database.SelectUserFromIUPI(iupi);
            
            
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
                    profiles.Add(database.SelectProfileByName("DEFAULT"));
                }
            }
           
            var higher = Profile.getHigherStatus(profiles);
            
            

            string json = await BRBConnector.getUserById(currentUser.brb_id);
            JObject jObject = JObject.Parse(json);
            var jsonUser = jObject["data"];
            BRB_User newUser = new BRB_User();
            newUser = newUser.fromJson(jsonUser.ToString());
            newUser.profile = higher;
            updateBRBUser(newUser, classroomGroups);
        }




        public async Task<String> addBrbRcuUserAssoc(BRB_User user){
            var iupi = RCUConnector.getRcuIupi(user.email);
            BRB_RCU_ASSOC newAssoc = new BRB_RCU_ASSOC();
            newAssoc.email = user.email;
            newAssoc.brb_id = user.id;
            newAssoc.rcu_id = iupi;
            database.InsertUserAssociation(newAssoc);  
            return iupi;
        }


        public async void updateBRB_RCU_ASSOC(){
            //GET BRB CURRENT USERS
            List<string> rcuids = new List<string>();
            foreach (var item in database.SelectUserAssociations())
            {
                rcuids.Add(item.rcu_id);
            }
            var brbUsers = await BRBConnector.getUserList();
            JObject jObject = JObject.Parse(brbUsers);
            List<BRB_User> usersAvailableBRB = new List<BRB_User>();
            foreach (var jsonUser in jObject["data"])
            {
                BRB_User newUser = new BRB_User();
                usersAvailableBRB.Add(newUser.fromJson(jsonUser.ToString()));
            }
            //GET RCU IUPI ID's
            foreach (BRB_User item in usersAvailableBRB)
            {
                var iupi = RCUConnector.getRcuIupi(item.email);
                
                if(!iupi.Contains("EXCEPTION:")){
                    BRB_RCU_ASSOC newAssoc = new BRB_RCU_ASSOC();
                    newAssoc.email = item.email;
                    newAssoc.brb_id = item.id;
                    newAssoc.rcu_id = iupi;

                    if (!rcuids.Contains(iupi)){
                        database.InsertUserAssociation(newAssoc);
                    }
                }
            } 
        }


        public async void updateBRBUser(BRB_User updatedUser, HashSet<ClassroomGroup> newGroups){
           
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

            //string json = JsonConvert.SerializeObject(points);
            Console.WriteLine(classRoomGroups.ToString());
            Console.WriteLine(profile.ToString());
            await BRBConnector.postUpdateUser(classRoomGroups.ToString(), profile.ToString());

        }
        public async Task<List<Tuple<UO,Vinculo>>> getUserData(string IUPI){
            List<Tuple<UO,Vinculo>> tupleList = new List<Tuple<UO,Vinculo>>();
     
            try{
                var data = RCUConnector.getUserData(IUPI);
                JObject jsonObjectGeneral = JObject.Parse(data);
                JArray info = new JArray();
                try{
                    info = (JArray)(jsonObjectGeneral["Vinculo"]);
                }catch(Exception e){
                    JObject singleData = (JObject)jsonObjectGeneral["Vinculo"]; 
                    info.Add(singleData);
                }
                
                foreach(JObject obj in info){
                    UO userUO  = database.selectUnidadeOrganicaBySigla(obj["unidade"]["Sigla"].ToString());
                    Vinculo vc =  database.selectVinculoBySigla(obj["tipovinculo"]["Sigla"].ToString());
                    tupleList.Add(new Tuple<UO, Vinculo>(userUO,vc));
                }

                
                return tupleList;
            }catch(Exception e){
                //Console.WriteLine(e.ToString());
                return new List<Tuple<UO,Vinculo>>();
            }
        }
        
        //Async Periodic Functions
        public async void updateDatabaseAssocTable(){
            //GET BRB CURRENT USERS
            List<string> rcuids = new List<string>();
            foreach (var item in database.SelectUserAssociations())
            {
                rcuids.Add(item.rcu_id);
            }
            var brbUsers = await BRBConnector.getUserList();
            JObject jObject = JObject.Parse(brbUsers);
            List<BRB_User> usersAvailableBRB = new List<BRB_User>();
            foreach (var jsonUser in jObject["data"])
            {
                BRB_User newUser = new BRB_User();
                usersAvailableBRB.Add(newUser.fromJson(jsonUser.ToString()));
            }
            //GET RCU IUPI ID's
            foreach (BRB_User item in usersAvailableBRB)
            {
                var iupi = RCUConnector.getRcuIupi(item.email);
                
                if(!iupi.Contains("EXCEPTION:")){
                    BRB_RCU_ASSOC newAssoc = new BRB_RCU_ASSOC();
                    newAssoc.email = item.email;
                    newAssoc.brb_id = item.id;
                    newAssoc.rcu_id = iupi;

                    if (!rcuids.Contains(iupi)){
                        database.InsertUserAssociation(newAssoc);
                    }
                }
            } 
            Thread.Sleep(UPDATE_DB_PERIOD/2);
        }
        public async void updateNewBRBUsers(){
            var data = await BRBConnector.getNewUsersInTimeframe(NEW_USERS_PERIOD);
            JObject jObject = JObject.Parse(data);
            List<BRB_User> usersAvailableBRB = new List<BRB_User>();
            
            foreach (var jsonUser in jObject["data"])
            {
                BRB_User newUser = new BRB_User();
                usersAvailableBRB.Add(newUser.fromJson(jsonUser.ToString()));

            }

            foreach (var user in usersAvailableBRB){
                    var iupi = RCUConnector.getRcuIupi(user.email);
                    BRB_RCU_ASSOC newAssoc = new BRB_RCU_ASSOC();
                    newAssoc.email = user.email;
                    newAssoc.brb_id = user.id;
                    newAssoc.rcu_id = iupi;
                    database.InsertUserAssociation(newAssoc);  
        
                List<Tuple<UO,Vinculo>> userData = await getUserData(iupi);
                UpdateProfile(iupi, userData);
            }
            Thread.Sleep(NEW_USERS_PERIOD);
            
        }
       
        public async void updateDatabaseWithNewBrbData(){
            var brbProfiles = await BRBConnector.getProfileList();
            var databaseProfiles = database.SelectProfile();

            var max = 0;
            var dbIds = new List<int>();
            foreach(var i in databaseProfiles){
                if (i.priority>max) max = i.priority;
                dbIds.Add(i.id);
       
            }
            
            foreach (var item in brbProfiles)
            {
                if (!dbIds.Contains(item.id)){
                    max++;
                    database.InsertProfile(item, max);
                }                
            }

            var brbClassroomGroups = await BRBConnector.getClassroomGroups();
            var databaseClassroomGroups = database.SelectClassroomGroup();

            dbIds = new List<int>();
            foreach(var i in databaseClassroomGroups){
                dbIds.Add(i.id);
            }
            foreach (var item in brbClassroomGroups)
            {
                if (!dbIds.Contains(item.id)){
                    database.InsertClassroomGroup(item);
                }                
            }
            Thread.Sleep(UPDATE_DB_PERIOD);
        }   
        
        
        
    }

}