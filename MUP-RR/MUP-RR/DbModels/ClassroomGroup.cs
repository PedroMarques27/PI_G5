using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class ClassroomGroup
    {
        public ClassroomGroup()
        {
            Mups = new HashSet<Mup>();
        }

        public string Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Mup> Mups { get; set; }
    }
}
