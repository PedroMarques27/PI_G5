
using System.Collections.Generic;

namespace MUP_RR.Models
{
    public class Profile
    {   
        public string id { get; set; }
        public string name { get; set; }

        private Dictionary<string, int> hierarchy = new Dictionary<string, int>(){
            { "OWNER", 0 },
            { "STAFF", 1 },
            { "DEFAULT", 2 }
        };

        public override string ToString()
        {
            return string.Format("Profile {0}: {1}", id, name);
        }


        public static string getHigherStatus(HashSet<Profile> profiles){
            Profile toReturn = new Profile();
            toReturn.name = "DEFAULT";

            foreach (Profile item in profiles)
            {
                int current = toReturn.hierarchy[toReturn.name];
                int latest = toReturn.hierarchy[item.name];
                if (current>latest){
                    toReturn = item;
                } 
            }
            return toReturn.name;
        }

        
    }
    
}