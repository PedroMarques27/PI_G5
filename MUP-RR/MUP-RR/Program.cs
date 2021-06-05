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
using System.Threading;


namespace MUP_RR
{
    class Program
    {

        public DBConnector database = new DBConnector();

        
        static async Task Main(string[] args)
        {
            

            await BRBConnector.OpenConnection();
            Program obj = new Program();
            await BRBConnector.OpenConnection();
            
            obj.updateBRB_RCU_ASSOC();
            
            Task.Factory.StartNew(obj.updateNewBRBUsers);
            //obj.UpdateProfile("0bbefa9e-590b-4b1d-ab57-273bc3e3c1db");
            CreateHostBuilder(args).Build().Run();
        }


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
           
            var higher = database.SelectProfileByName(Profile.getHigherStatus(profiles));
            
            

            string json = await BRBConnector.getUserById(currentUser.brb_id);
            JObject jObject = JObject.Parse(json);
            var jsonUser = jObject["data"];
            BRB_User newUser = new BRB_User();
            newUser = newUser.fromJson(jsonUser.ToString());
            newUser.profile = higher;
            updateBRBUser(newUser, classroomGroups);
        }


        public async void updateNewBRBUsers(){
            var data = await BRBConnector.getNewUsersInTimeframe("2");
            JObject jObject = JObject.Parse(data);
            List<BRB_User> usersAvailableBRB = new List<BRB_User>();
            
            foreach (var jsonUser in jObject["data"])
            {
                BRB_User newUser = new BRB_User();
                usersAvailableBRB.Add(newUser.fromJson(jsonUser.ToString()));

            }

            foreach (var user in usersAvailableBRB){
                var iupi = await addBrbRcuUserAssoc(user);
                List<Tuple<UO,Vinculo>> userData = await getUserData(iupi);
                UpdateProfile(iupi, userData);
            }
            Thread.Sleep(7200000);
            
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

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
        
        
        
    }

}