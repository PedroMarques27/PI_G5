
namespace MUP_RR.Models
{
    public class ClassroomGroup
    {   
        public int id { get; set; }
        public string name { get; set; }
        
        override
        public string ToString(){
            return string.Format("Group {0}: {1}", id, name);
        }
    }
    
}