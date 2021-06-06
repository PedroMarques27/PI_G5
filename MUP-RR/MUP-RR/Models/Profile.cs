
using System.Collections.Generic;

namespace MUP_RR.Models
{
    public class Profile
    {   
        public int id { get; set; }
        public string name { get; set; }

        private Dictionary<string, int> hierarchy = new Dictionary<string, int>(){
            { "Dono", 0 },
            { "Gestor", 1 },
            { "Ver e Requisitar", 2 }
        };

        public override string ToString()
        {
            return string.Format("{1}", id, name);
        }


        public static string getHigherStatus(HashSet<Profile> profiles){
            Profile toReturn = new Profile();
            toReturn.name = "Ver e Requisitar";

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