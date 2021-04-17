
namespace MUP_RR.Models
{
    public class Permission
    {   
        public int id { get; set; }
        public string name { get; set; }

        public void setPermission(Permission _permission){
            additional.Add(_permission);
        }

        public void unsetPermission(Permission _permission){
            try{
                additional.remove(_permission);
            }catch (Exception e){
                Console.WriteLine("Permission Not Found In Group: "+_permission);
            }
        }

        public string ToString(){
            return String.Format("Permission {0}: {1}", id, name);
        }
        
    }
    
}