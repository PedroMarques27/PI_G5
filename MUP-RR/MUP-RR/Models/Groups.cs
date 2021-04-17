
namespace MUP_RR.Models
{
    public class Groups
    {   
        public int id { get; set; }
        public string name { get; set; }
        public List<User> users { get; set; }
        public List<Permission> permissions { get; set; }


        public void setPermission(Permission _permission){
            permissions.Add(_permission);
        }

        public void unsetPermission(Permission _permission){
            try{
                permissions.remove(_permission);
            }catch (Exception e){
                Console.WriteLine("Permission Not Found In Group: "+_permission.ToString());
            }
        }

        public void setPermission(Permission _permission){
            permissions.Add(_permission);
        }

        public void unsetPermission(Permission _permission){
            try{
                permissions.remove(_permission);
            }catch (Exception e){
                Console.WriteLine("Permission Not Found In Group: "+_permission.ToString());
            }
        }

        public string ToString(){
            return String.Format("Group {0}: {1}", id, name);
        }
    }
    
}