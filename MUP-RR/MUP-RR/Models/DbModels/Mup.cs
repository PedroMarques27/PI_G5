using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class Mup
    {
        public int Id { get; set; }
        public int Uo { get; set; }
        public int Vinculo { get; set; }
        public string Profile { get; set; }
        public string ClassGroup { get; set; }

        public virtual ClassroomGroup ClassGroupNavigation { get; set; }
        public virtual Profile ProfileNavigation { get; set; }
        public virtual UnidadeOrganica UoNavigation { get; set; }
        public virtual Vinculo VinculoNavigation { get; set; }
    }
}
