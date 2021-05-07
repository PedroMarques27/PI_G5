
namespace MUP_RR.Models
{
    public class MupTable
    {   
        public int id { get; set; }
        public int uo { get; set; }
        public int vinculo { get; set; }
        public string profile { get; set; }
        public string classGroup { get; set; }
       

       public bool isNull(){
           if (this.uo == 0 && this.vinculo == 0 && profile == null && classGroup == null ){
               return true;
           }
           return false;

       }

       public string ToString(){
           return string.Format(" {0}  {1}  {2}  {3} ", uo, vinculo,profile, classGroup);
       }
    }
    
}