
namespace MUP_RR.Models
{
    public class Vinculo
    {
        public int id { get; set; }
        public string sigla { get; set; }
        public string description { get; set; }


        public override string ToString()
        {
            return string.Format("{0}", sigla);
        }
    }

}