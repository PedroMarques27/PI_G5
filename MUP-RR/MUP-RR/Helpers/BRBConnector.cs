using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System.Net.Http.Headers;
using Newtonsoft.Json;
using System.Text;      
using System.Threading;      
using System.Net.Http;   
using MUP_RR.Models;
using System.Runtime.Serialization.Json;
using Newtonsoft.Json.Linq;

namespace MUP_RR.Controllers
{
    public class BRBConnector
    {   
        private static string BASE_URL = "https://bullet-api.dev.ua.pt/api/";
        private static string AUTH_TOKEN = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2MjY1MTg0OTAsImV4cCI6MTYyOTExMDQ5MCwiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjoiYmVzdGxlZ2FjeV9hcGlfcmVzb3VyY2UiLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.uMQFkqJRypz-qD9HuVRmWaXCD3Ot8CGvQuRSzqKQjYIyWEk2FfavqYdxn3SSqrLZqReBeZC1oD561fzam38tz7V8eLynYs5TlhNAZVjqIXFeXO1VFXiZ0ZLl6IepGICxoJ4_vWwtvXiP8FTyJMSllfAsa8zhzO2j-YyuT5-xH4ZxOznaYg-H9zgpHT0tIEIiglaRZ0kWfm_t-NYQ64CzIZOnV7M9NFmgnIiv_hVfZZ29341RAsx9984GKCpJ6ZHQ5RnwjMm2h7h4V7t352TbP1zxrOihP-x_pvptBIIqzy1kaEHqtwAeuZR4K2gds3HHX-BMkZ42qCfzi4VOcLIWgA";
        private static HttpClient client;

        public static void OpenConnection()
        {
            client = new HttpClient();   
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
            new MediaTypeWithQualityHeaderValue("application/vnd.github.v3+json"));
            client.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");
            client.DefaultRequestHeaders.Add("Authorization",AUTH_TOKEN);
        }


        public static async Task<List<Profile>> getProfileList(){
            var stringTask = client.GetStringAsync(BASE_URL+"Profiles");
            var msg = await stringTask;
            
            JObject jObject = JObject.Parse(msg);
            List<Profile> profiles = new List<Profile>();
            foreach (var jsonProfile in jObject["data"])
            {
                Profile newProfile = new Profile();
                profiles.Add(newProfile.fromJson(jsonProfile.ToString()));
            }
            return profiles;
        }

        public static async Task<List<ClassroomGroup>> getClassroomGroups(){
            var stringTask = client.GetStringAsync(BASE_URL+"ClassroomGroupBooking");
            var msg = await stringTask;
            
            JObject jObject = JObject.Parse(msg);
            List<ClassroomGroup> classGroups = new List<ClassroomGroup>();
            foreach (var jsonProfile in jObject["data"])
            {
                ClassroomGroup newClassGroup = new ClassroomGroup();
                classGroups.Add(newClassGroup.fromJson(jsonProfile.ToString()));
            }
            return classGroups;
        }
        public static async Task<string> getUserList(){
            var stringTask = client.GetStringAsync(BASE_URL+"Users");
            var msg = await stringTask;
            return msg;
        }
        
        public static async Task<string> getNewUsersInTimeframe(DateTime before){
            DateTime now = DateTime.Now;
            var stringTask = client.GetStringAsync(BASE_URL+"Users/all/"+before.ToString(("yyyy-MM-dd"))+"/"+now.ToString(("yyyy-MM-dd")));

            var msg = await stringTask;
           
            return msg;
        }

        public static async Task<string> getUserById(string id){
            var stringTask = client.GetStringAsync(BASE_URL+"Users/"+id);
            var msg = await stringTask;
            return msg;
        }

        public static async Task<bool> postUpdateUser(string classRoomGroups, string profile){

            //Update profile

            var httpContent2 = new StringContent(profile, Encoding.UTF8, "application/json");
            var httpClient2 = new HttpClient();
            httpClient2.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");
            httpClient2.DefaultRequestHeaders.Add("Authorization",AUTH_TOKEN);

            var httpResponse2 = await httpClient2.PutAsync(BASE_URL+"UserProfile/usersprofilesByUsersEmail", httpContent2);


            //Update classRoomGroups
            var httpContent = new StringContent(classRoomGroups, Encoding.UTF8, "application/json");

            var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");
            httpClient.DefaultRequestHeaders.Add("Authorization",AUTH_TOKEN);

            var httpResponse = await httpClient.PutAsync(BASE_URL+"UserClassroomGroupBookings/usersclassroomgroupbookingsbyusersEmail", httpContent);
  
            
            return true;
        }

       

    }
}
 