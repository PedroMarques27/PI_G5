
namespace MUP_RR.Models
{
    public class User
    {   
        public int id { get; set; }
        public HashSet<Permission> additional { get; set; }
        
        public void setPermission(int _permissionId){
            additional.Add(_permissionId);
        }

        public void removePermission(int _permissionId){
            try{
                additional.remove(_permissionId);
            }catch (Exception e){
                Console.WriteLine("Permission Not Found In Group: "+_permissionId);
            }
        }

    }
    
}