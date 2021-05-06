
namespace MUP_RR.Models
{
    public class Vinculo
    {
        public int id { get; set; }
        public string sigla { get; set; }
        public string description { get; set; }


        public override string ToString()
        {
            return string.Format("Vinculo {1} - {2}", id, sigla, description);
        }
    }

}