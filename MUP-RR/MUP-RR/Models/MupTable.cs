
namespace MUP_RR.Models
{
    public class MupTable
    {   
        public int id { get; set; }
        public string uo { get; set; }
        public string vinculo { get; set; }
        public string profile { get; set; }
        public string classGroup { get; set; }
       

       public string ToString(){
           return string.Format(" {0}  {1}  {2}  {3} ", uo, vinculo,profile, classGroup);
       }
    }
    
}