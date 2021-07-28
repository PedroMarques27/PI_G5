using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class User
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Guid Iupi { get; set; }
        public string Uu { get; set; }
        public bool Active { get; set; }
        public bool IsAdmin { get; set; }
    }
}