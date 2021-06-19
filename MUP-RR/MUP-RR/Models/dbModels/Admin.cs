using System;
using System.Collections.Generic;

namespace MUP_RR.Models.dbModels
{
    public partial class Admin
    {
        public int PersonId { get; set; }
        public bool Active { get; set; }

        public virtual Person Person { get; set; }
    }
}
