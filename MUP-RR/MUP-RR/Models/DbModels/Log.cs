using System;
using System.Collections.Generic;

#nullable disable

namespace MUP_RR.DbModels
{
    public partial class Log
    {
        public int Id { get; set; }
        public string Context { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
    }
}
