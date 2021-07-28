using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class Vinculo
    {
        public Vinculo()
        {
            Mups = new HashSet<Mup>();
            UserData = new HashSet<UserDatum>();
        }

        public int Id { get; set; }
        public string Sigla { get; set; }
        public string Descricao { get; set; }

        public virtual ICollection<Mup> Mups { get; set; }
        public virtual ICollection<UserDatum> UserData { get; set; }
    }
}
