using System;
using System.Collections.Generic;

namespace MUP_RR.Models.dbModels
{
    public partial class Person
    {
        public Person()
        {
            PersonIdentifier = new HashSet<PersonIdentifier>();
        }

        public int PersonId { get; set; }
        public DateTime? BirthDate { get; set; }
        public int GenderId { get; set; }
        public string Photo { get; set; }

        public virtual Admin Admin { get; set; }
        public virtual ICollection<PersonIdentifier> PersonIdentifier { get; set; }
    }
}