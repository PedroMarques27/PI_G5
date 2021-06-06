
namespace MUP_RR.Models
{
    public class ClassroomGroup
    {   
        public int id { get; set; }
        public string name { get; set; }
        
        override
        public string ToString(){
            return string.Format("{1}", id, name);
        }

        public ClassroomGroup fromJson(string json){
            ClassroomGroup p = Newtonsoft.Json.JsonConvert.DeserializeObject<ClassroomGroup>(json);
            return p;
        }
    }
    
}