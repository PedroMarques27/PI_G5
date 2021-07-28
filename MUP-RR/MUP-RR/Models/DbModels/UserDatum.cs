using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class UserDatum
    {
        public string Id { get; set; }
        public int Uo { get; set; }
        public int Vinculo { get; set; }

        public virtual BrbRcuAssoc IdNavigation { get; set; }
        public virtual Vinculo UoNavigation { get; set; }
        public virtual UnidadeOrganica VinculoNavigation { get; set; }
    }
}
