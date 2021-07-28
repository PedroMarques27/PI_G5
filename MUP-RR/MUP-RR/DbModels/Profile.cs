using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class Profile
    {
        public Profile()
        {
            Mups = new HashSet<Mup>();
        }

        public string Id { get; set; }
        public string Name { get; set; }
        public int? Priority { get; set; }

        public virtual ICollection<Mup> Mups { get; set; }
    }
}
