using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class BrbRcuAssoc
    {
        public BrbRcuAssoc()
        {
            UserData = new HashSet<UserDatum>();
        }

        public string RcuId { get; set; }
        public string BrbId { get; set; }
        public string Uu { get; set; }

        public virtual ICollection<UserDatum> UserData { get; set; }
    }
}
