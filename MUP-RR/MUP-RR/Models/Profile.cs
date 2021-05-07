
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

        public void isHigher(Profile newprofile){
            int current = hierarchy[this.name];
            int latest = hierarchy[newprofile.name];
            if (current<latest){
                this.name=newprofile.name;
            } 
        }
        
    }
    
}