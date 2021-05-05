using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using MUP_RR.Models;

using Newtonsoft.Json.Linq;

using MUP_RR.Controllers;

namespace MUP_RR
{
    class Program
    {
        private List<BRB_RCU_ASSOC> _assoc;
        static async Task Main(string[] args)
        {
            await BRBConnector.OpenConnection();
            //Console.Write("\n\nDONEEEEEEEE\n\n");
            //CreateHostBuilder(args).Build().Run(); //MVC starter
        
            //RCUConnector.getRcuIupi(
            //"pedroagoncalvesmarques@ua.pt");
            
            Program obj = new Program();

            obj._assoc = new List<BRB_RCU_ASSOC>();
            await BRBConnector.OpenConnection();

            var brbUserList = await obj.getBrbRcuUsers();

            foreach(var item in obj._assoc){
                obj.getUserData(item.rcu_id);
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
                }
                
            }

            return usersAvailableBRB;
            
        }

        public async void getUserData(string IUPI){
            //GET RCU IUPI ID's
            RCUConnector rcu = new RCUConnector();
            var data = RCUConnector.getUserData(IUPI);
            Console.WriteLine(data.ToString());
            
        }


        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
        
    }

}