using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MUP_RR.Helpers
{
    public class RoleAuthorization
    {
        private string permissions;

        public List<Roles> UserRoles { get; private set; }
        public bool UserAuthorized { get; private set; }

        public RoleAuthorization(string Permission, ISession session)
        {
            var ses = new Session(session);
            permissions = Permission;
            UserRoles = ses.Roles;
            CheckUserAuth();
        }

        protected void CheckUserAuth()
        {
            List<string> userRoles = UserRoles.Select(r => r.ToString()).ToList();
            List<string> allowedRoles = permissions.Split(',').ToList();

            UserAuthorized = userRoles.Intersect(allowedRoles).Any();
        }

        public enum Roles
        {
            user,
            admin
        };
    }
}