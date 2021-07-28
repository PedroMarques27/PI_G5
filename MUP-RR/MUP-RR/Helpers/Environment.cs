using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Security.Policy;
using System.Threading.Tasks;

namespace MUP_RR.Helpers
{
    public class Environment
    {
        private readonly IConfiguration Configuration;

        public Environment(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public const int SystemUserId = 24;

        public bool IsLocalhost(HttpContext context)
        {
            return Current == development &&
                (context.Connection?.RemoteIpAddress?.ToString() == "::1"
                    || context.Connection?.RemoteIpAddress?.ToString() == "127.0.0.1")
                && context.Request.Headers["Referer"].ToString().Contains("localhost");
        }

        public bool IsDevelopment
        {
            get { return Current == development; }
        }

        public bool IsStaging
        {
            get { return Current == staging; }
        }

        public bool IsProduction
        {
            get { return Current == producao; }
        }

        public string Current
        {
            get
            {
                return Configuration["Environment"];
            }
        }

        private const string producao = "production";
        private const string development = "development";
        private const string staging = "staging";
    }
}