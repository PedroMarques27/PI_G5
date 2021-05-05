using System;
using System.Collections.Generic;

namespace MUP_RR.Models
{
    public class BRB_RCU_ASSOC
    {   
        public string brb_id { get; set; }
        public string rcu_id { get; set; }
        public string email { get; set; }
     

        public override string ToString()
        {
            return string.Format("(RCU) {0} - (BRB) {1} : {2}", brb_id,rcu_id, email);
        }

    }
}