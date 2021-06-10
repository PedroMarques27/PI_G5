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
        private static string AUTH_TOKEN = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2MjMwMDUwMjYsImV4cCI6MTYyNTU5NzAyNiwiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjoiYmVzdGxlZ2FjeV9hcGlfcmVzb3VyY2UiLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.QOkcuoXIiwzhY6d7SmdiBANtO9N8Ow8FWH-xUB3CV52jBay90Qdx16qkg0I6RfR7XmIRvEOgx5HYfX659sZ7C0lgKIPJxep_SRRRLyyqEKCqxbD8sePhvOn7mNAmy2mFfDRorzDrDCzP8TyJbpxVlHTJzYI_CC8q_0ers_Ig40h_Ar5Z7cdy-DV5ZpEyZVt-mZsVhAC40ZZiqQylqmf1dCkKiZbYryWWghuYIkdviO0adpsMGCjA9M2JTt81swk4fbI6n-7XuPgRQREK0M7D8M8YfubIJwjpBbKKqVzgvL4GuodEj8k0l7yZ5qFvUdYteqa_V6SBDcF7kWEnvAAWag";
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
            Console.WriteLine(BASE_URL+"Users/"+id);
            var msg = await stringTask;
            return msg;
        }

        public static async Task<bool> postUpdateUser(string classRoomGroups, string profile){

            //Update profile

            var httpContent2 = new StringContent(profile, Encoding.UTF8, "application/json");
            Console.WriteLine(profile);
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
            Console.WriteLine(httpResponse);
            
            return true;
        }

       

    }
}
 