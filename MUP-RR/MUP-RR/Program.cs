using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using MUP_RR.Models;

using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using MUP_RR.Controllers;
using System;
using System.Collections.Generic;
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
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization.Json;
using System.IO;
using System.Runtime.Serialization.Json;



namespace MUP_RR
{
    class Program
    {

        public enum PROFILES {OWNER, STAFF, DEFAULT};
        public DBConnector database = new DBConnector();

        
        static async Task Main(string[] args)
        {
            

            await BRBConnector.OpenConnection();
            Program obj = new Program();
            await BRBConnector.OpenConnection();
            
            obj.updateBRB_RCU_ASSOC();
            

            //obj.UpdateProfile("0bbefa9e-590b-4b1d-ab57-273bc3e3c1db");
            CreateHostBuilder(args).Build().Run();
        }
        public async void UpdateProfile(string iupi, List<Tuple<UO,Vinculo>> pairs){

            BRB_RCU_ASSOC currentUser = database.SelectUserFromIUPI(iupi);
            
            //remover
            //List<Tuple<UO,Vinculo>> data = await getUserData(iupi);
            
            MupTable finalDecision = new MupTable();  
            HashSet<Profile> profiles = new HashSet<Profile>();
            HashSet<ClassroomGroup> classroomGroups = new HashSet<ClassroomGroup>();
            foreach (Tuple<UO, Vinculo> item in pairs)
            {

                UO currentUO = item.Item1;
                Vinculo currentVinculo = item.Item2;
                Console.WriteLine(currentUO.id.ToString()+"-------------------------------");
                Console.WriteLine(currentVinculo.id.ToString()+"-------------------------------");
                MupTable queryResult= database.SelectSpecificMup(currentUO.id, currentVinculo.id);

                Console.WriteLine(queryResult.ToString()+"-------------------------------");
                profiles.Add(database.SelectProfileById(queryResult.profile));
                classroomGroups.Add(database.SelectClassroomById(queryResult.classGroup));

            }

            Profile higher = database.SelectProfileByName(Profile.getHigherStatus(profiles));

            string json = await BRBConnector.getUserById(currentUser.brb_id);
            JObject jObject = JObject.Parse(json);
            var jsonUser = jObject["data"];
            BRB_User newUser = new BRB_User();
            newUser = newUser.fromJson(jsonUser.ToString());

            newUser.profile = higher;
            updateBRBUser(newUser, classroomGroups);
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
           
            HashSet<ClassroomGroup> groupsToDelete = new HashSet<ClassroomGroup>();
            HashSet<ClassroomGroup> groupsToAdd = new HashSet<ClassroomGroup>();

            foreach (ClassroomGroup item in newGroups)
            {
                if (!updatedUser.classroomGroups.Contains(item)){
                    groupsToAdd.Add(item);
                }
            }

            foreach (ClassroomGroup item in updatedUser.classroomGroups)
            {
                if (!newGroups.Contains(item)){
                    groupsToDelete.Add(item);
                }
            }


            JArray classes = new JArray(
                from p in groupsToDelete
                orderby p.id
                select 
                new JObject(
                    new JProperty("model",
                        new JObject(
                            new JProperty("userId",  updatedUser.id),
                            new JProperty("classroomGroupId",p.id)
                        )
                    ),
                    new JProperty("status", "Deleted"))
            );
            JArray toAdd = new JArray(
                from p in groupsToAdd
                orderby p.id
                select 
                new JObject(
                    new JProperty("model",
                        new JObject(
                            new JProperty("userId", updatedUser.id),
                            new JProperty("classroomGroupId", p.id)
                        )
                    ),
                    new JProperty("status", "Added"))     
            );

            JObject o =
            new JObject(
                
                new JProperty("id", updatedUser.id),
                new JProperty("userName", updatedUser.username),
                new JProperty("isAdmin", updatedUser.isAdmin),
                new JProperty("email", updatedUser.email),
                new JProperty("isActive", updatedUser.isActive),
                new JProperty("profileId", updatedUser.profile.id),
                new JProperty("userClassroomGroups",
                    new JArray(classes.Union(toAdd))
                )
            );

           
           

            //string json = JsonConvert.SerializeObject(points);
            Console.WriteLine(o.ToString());
            BRBConnector.postUpdateUser(o.ToString());

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