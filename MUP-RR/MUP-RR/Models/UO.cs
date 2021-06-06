
namespace MUP_RR.Models
{
    public class UO
    {   
        public int id { get; set; }
        public string sigla { get; set; }
        public string description { get; set; }


        override
        public string ToString(){
            return string.Format("{0}", sigla.ToUpper() );
        }
        
    }
    
}