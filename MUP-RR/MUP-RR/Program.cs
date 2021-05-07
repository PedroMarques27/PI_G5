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



namespace MUP_RR
{
    class Program
    {

        public enum PROFILES {OWNER, STAFF, DEFAULT};
        private DBConnector database;

        
        static async Task Main(string[] args)
        {
            

            await BRBConnector.OpenConnection();
            Program obj = new Program();
            obj.database = new DBConnector();
            await BRBConnector.OpenConnection();
            
            obj.updateBRB_RCU_ASSOC();

            CreateHostBuilder(args).Build().Run();
        }
        public async void UpdateProfile(string iupi){
            BRB_RCU_ASSOC currentUser = database.SelectUserFromIUPI(iupi);
            List<Tuple<UO,Vinculo>> data = await getUserData(iupi);
            MupTable finalDecision = new MupTable();  
            foreach (Tuple<UO, Vinculo> item in data)
            {
                UO currentUO = item.Item1;
                Vinculo currentVinculo = item.Item2;
                MupTable queryResult= database.SelectSpecificMup(currentUO.id, currentVinculo.id);
                if (finalDecision.isNull())
                    finalDecision = queryResult;
                else{

                }
            }
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
                    UO userUO = new UO();   
                    userUO.description = obj["unidade"]["Descricao"].ToString();
                    userUO.sigla = obj["unidade"]["Sigla"].ToString();

                    Vinculo vc = new Vinculo();
                    vc.sigla = obj["tipovinculo"]["Sigla"].ToString();
                    vc.description = obj["tipovinculo"]["Descricao"].ToString();

                    
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