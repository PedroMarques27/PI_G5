using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System.Net.Http.Headers;
using System.Net.Http;

namespace MUP_RR.Controllers
{
    public class BRBConnector
    {   
        private static string BASE_URL = "https://bullet-api.dev.ua.pt/api/";
        private static string AUTH_TOKEN = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2MTc4MDU1NjAsImV4cCI6MTYyMDM5NzU2MCwiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjpbImh0dHBzOi8vYnVsbGV0LWlzLmRldi51YS5wdC9yZXNvdXJjZXMiLCJiZXN0bGVnYWN5X2FwaV9yZXNvdXJjZSJdLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.xHV5FwA-WVvGzM4Up1KI6LJ4t0BLIOwXqBd86ccoIDtS1EjTGZ8vtbuJIeqsfvbMTLfPum-fQqvdPdLPWxkLXzHYD9Oc_Vq6PFOgDJrIS-8mBJ_axiUzA0depGW0K5VG8IM_lG0dr6j70kpkUBBMZsBLsa9ilo_09ITSVD36o_ZcE1PzOcaFaZso5ZsUVhVO_CGnAeVp9pJIht_ptrfv6v9GV-bzOl8mtXF_egxFmHEapBqoQkWWUlXdeTGCnRMlvTKtvr1TO_chV4x5-iTyRd-ZvrBkLGorL2wymaynrWLu4YxTkbXebgrv7sZnMqLGyFH6ryJy_GkK1bKxF_mqvQ";
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

        public static async Task<string> postUpdateUser(){
            var stringTask = client.GetStringAsync(BASE_URL+"Users");
            var msg = await stringTask;
            return msg;
        }

       

    }
}
 