using System;
using System.Collections.Generic;

namespace MUP_RR.Models.dbModels
{
    public partial class PersonIdentifier
    {
        public int PersonId { get; set; }
        public int IdentifierId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Value { get; set; }
        public int VisibilityId { get; set; }

        public virtual Person Person { get; set; }
    }
}