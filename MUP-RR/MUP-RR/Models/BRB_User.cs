using System;
using System.Collections.Generic;

namespace MUP_RR.Models
{
    public class BRB_User
    {   
        public string id { get; set; }
        public string username { get; set; }
        public bool isAdmin { get; set; }
        public string email { get; set; }
        public bool isActive { get; set; }

        public Profile profile { get; set; }
        public List<ClassroomGroup> classroomGroups { get; set; }

        public override string ToString()
        {
            return string.Format("User {0}: {1}", id, email);
        }

        public BRB_User fromJson(String json){
            BRB_User _user = Newtonsoft.Json.JsonConvert.DeserializeObject<BRB_User>(json);
            return _user;
        }
    }
}