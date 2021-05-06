
namespace MUP_RR.Models
{
    public class Profile
    {   
        public string id { get; set; }
        public string name { get; set; }


        public override string ToString()
        {
            return string.Format("Profile {0}: {1}", id, name);
        }
    }
    
}