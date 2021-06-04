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
namespace MUP_RR.Controllers
{
    public class BRBConnector
    {   
        private static string BASE_URL = "https://bullet-api.dev.ua.pt/api/";
        private static string AUTH_TOKEN = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2MjAzOTg5NTIsImV4cCI6MTYyMjk5MDk1MiwiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjpbImh0dHBzOi8vYnVsbGV0LWlzLmRldi51YS5wdC9yZXNvdXJjZXMiLCJiZXN0bGVnYWN5X2FwaV9yZXNvdXJjZSJdLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.kPaVYPTkhQIbODbDrjlJRbM-rGWM015WGGUVXLnsRfduGm-QZF9KPcnMFINPIosbKl0ezWZbwh34Az_wbEKz-eUEN-CaJJ2YS2xa7YLQGfDycuT542w67j-TZxa_ZXMUtXEnYNAw9eJc9sx1HjcEiwFytdK6ogiaAUdhpQHTQW8pjWbt31YOcOjyscj7tAwUlxUkKaTfGHqp9pOdjjPDEHUi6yhkzpd-a8ayNRXV8kCADPtfr9vNNYR9bOKRV8CmkJaxDks3-LTnmSgp1KWjKV4VAskNSfWsBYmgqSHcN8cwHwV30sJ_ffRHLCib_WUPnJRnb_W0O8JjoBEuGwYGQw";
        private static HttpClient client;

        public static async Task OpenConnection()
        {
            client = new HttpClient();   
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
            new MediaTypeWithQualityHeaderValue("application/vnd.github.v3+json"));
            client.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");
            client.DefaultRequestHeaders.Add("Authorization",AUTH_TOKEN);
        }


        public async Task<string> getProfileList(){
            var stringTask = client.GetStringAsync(BASE_URL+"Profiles");
            var msg = await stringTask;
            return msg;
        }

        public static async Task<string> getUserList(){
            var stringTask = client.GetStringAsync(BASE_URL+"Users");
            var msg = await stringTask;
            return msg;
        }
        
        public static async Task<string> getNewUsersInTimeframe(String hours){
            DateTime now = DateTime.Now;
            DateTime before = now.AddHours(- Int32.Parse(hours));
            var stringTask = client.GetStringAsync(BASE_URL+"Users/all/"+before.ToString("yyyy-MM-dd HH:mm:ss")+"/"+now.ToString("yyyy-MM-dd HH:mm:ss"));

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
            Console.WriteLine(profile);
            var httpClient2 = new HttpClient();
            httpClient2.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");
            httpClient2.DefaultRequestHeaders.Add("Authorization",AUTH_TOKEN);

            var httpResponse2 = await httpClient2.PutAsync(BASE_URL+"UserProfile/usersprofilesByUsersEmail", httpContent2);
            Console.WriteLine(httpResponse2);

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
 