
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
namespace MUP_RR.Models
{
    public class Profile
    {   
        public int id { get; set; }
        public string name { get; set; }
        public int priority { get; set; }
   

        public override string ToString()
        {
            return string.Format("Profile {0}: {1}", id, name);
        }


        public static Profile getHigherStatus(HashSet<Profile> profiles){
            Profile toReturn = new Profile();
            var priorities = new List<int>();
            foreach(var p in profiles)
                priorities.Add(p.priority);

            var max = priorities.Min();;

        
            foreach (Profile item in profiles)
            {
                if (item.priority == max){
                    toReturn = item;
                    break;
                }
            }
            return toReturn;
        }
        public Profile fromJson(string json){
            Profile p = Newtonsoft.Json.JsonConvert.DeserializeObject<Profile>(json);
            return p;
        }

        
    }
    
}