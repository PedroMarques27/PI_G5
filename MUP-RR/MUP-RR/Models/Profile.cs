
namespace MUP_RR.Models
{
    public class Profile
    {   
        public string id { get; set; }
        public string name { get; set; }
        enum PROFILES {OWNER, STAFF, DEFAULT};

        public override string ToString()
        {
            return string.Format("Profile {0}: {1}", id, name);
        }


        
    }
    
}