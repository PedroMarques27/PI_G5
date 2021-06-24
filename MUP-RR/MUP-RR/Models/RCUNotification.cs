using System;
using System.Collections.Generic;

namespace MUP_RR.Models
{
    public class RCUNotification
    {
        public string iupi { get; set; }
        public List<List<string>> pairs { get; set; }
    }
}