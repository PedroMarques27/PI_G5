using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using MUP_RR.Models;

using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using MUP_RR.Controllers;

namespace MUP_RR
{
    class Program
    {
        private List<BRB_RCU_ASSOC> _assoc;
        private HashSet<MupTable> table;
        static async Task Main(string[] args)
        {
            await BRBConnector.OpenConnection();
            //Console.Write("\n\nDONEEEEEEEE\n\n");
            //CreateHostBuilder(args).Build().Run(); //MVC starter
        
            //RCUConnector.getRcuIupi(
            //"pedroagoncalvesmarques@ua.pt");
            
            Program obj = new Program();
            obj.table = new HashSet<MupTable>();
            obj._assoc = new List<BRB_RCU_ASSOC>();
            await BRBConnector.OpenConnection();

            await obj.getBrbRcuUsers();

            DBConnector db = new DBConnector();
            List<Vinculo> vinculosInDB = db.SelectVinculo();
            foreach(Vinculo v in vinculosInDB){
                Console.WriteLine(v);
            }
        }


        public async Task<List<BRB_User>> getBrbRcuUsers(){
            
            
            //GET BRB CURRENT USERS
            var brbUsers = await BRBConnector.getUserList();

            JObject jObject = JObject.Parse(brbUsers);
            List<BRB_User> usersAvailableBRB = new List<BRB_User>();
            foreach (var jsonUser in jObject["data"])
            {
                BRB_User newUser = new BRB_User();
                usersAvailableBRB.Add(newUser.fromJson(jsonUser.ToString()));
            }


            //GET RCU IUPI ID's
            RCUConnector rcu = new RCUConnector();
            foreach (BRB_User item in usersAvailableBRB)
            {
                var iupi = RCUConnector.getRcuIupi(item.email);
                if(!iupi.Contains("EXCEPTION:")){
                    BRB_RCU_ASSOC newAssoc = new BRB_RCU_ASSOC();
                    newAssoc.email = item.email;
                    newAssoc.brb_id = item.id;
                    newAssoc.rcu_id = iupi;
                    /*
                    Console.WriteLine(newAssoc.ToString());
                    Console.WriteLine("\t User "+item.username);
                    Console.WriteLine("\t\t "+item.profile.ToString());
                    Console.WriteLine("\t\t Classroom Groups");
                    foreach (ClassroomGroup classroomGroup in item.classroomGroups)
                        Console.WriteLine("\t\t\t "+classroomGroup.ToString());
                    */
                    List<Tuple<UO,Vinculo>> tuple = await getUserData(iupi);

                    foreach( Tuple<UO, Vinculo> data in tuple){
                        UO thisUserUO = data.Item1;
                        Vinculo thisUserVinc = data.Item2;
                        MupTable mup = new MupTable();
                        mup.profile = item.profile.id;
                        mup.uo = thisUserUO.sigla;
                        mup.vinculo = thisUserVinc.sigla;
                        foreach(ClassroomGroup csg in item.classroomGroups){
                            mup.classGroup = csg.id;
                            table.Add(mup);
                        }
                        
                    }
                
                }

                
            }
            foreach(var item in table){
                Console.WriteLine(item.ToString());
            }
            return usersAvailableBRB;
        }

        public async Task<List<Tuple<UO,Vinculo>>> getUserData(string IUPI){
            List<Tuple<UO,Vinculo>> tupleList = new List<Tuple<UO,Vinculo>>();
     
            try{
                RCUConnector rcu = new RCUConnector();
                var data = RCUConnector.getUserData(IUPI);
                JObject jsonObjectGeneral = JObject.Parse(data);
                JArray info = new JArray();
                try{
                    info = (JArray)(jsonObjectGeneral["Vinculo"]);
                }catch(Exception e){
                    JObject singleData = (JObject)jsonObjectGeneral["Vinculo"]; 
                    info.Add(singleData);
                }
                
                
                
                //Console.WriteLine("\t\t Vinculos");
                foreach(JObject obj in info){
                    UO userUO = new UO();   
                    userUO.description = obj["unidade"]["Descricao"].ToString();
                    userUO.sigla = obj["unidade"]["Sigla"].ToString();

                    Vinculo vc = new Vinculo();
                    vc.sigla = obj["tipovinculo"]["Sigla"].ToString();
                    vc.description = obj["tipovinculo"]["Descricao"].ToString();

                    
                    tupleList.Add(new Tuple<UO, Vinculo>(userUO,vc));
                    //Console.WriteLine("\t\t\t "+vc.ToString());
                    //Console.WriteLine("\t\t\t\t "+userUO.ToString());
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