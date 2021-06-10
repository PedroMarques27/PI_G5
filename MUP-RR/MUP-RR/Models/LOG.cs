using System;
namespace MUP_RR.Models
{
    
        public enum LOG {INFO, NEW_USER, NEW_PROFILES, USER_UPDATE, NEW_BRB_RCU_ASSOC, NEW_CLASSROOMGROUPS}
        public class Log{
                public LOG context;
                public string description;
                public DateTime date;
        }
}