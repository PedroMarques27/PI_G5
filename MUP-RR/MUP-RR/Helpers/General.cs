using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MUP_RR.Helpers
{
    public class General
    {
        /// <summary>
        /// Dicionários dos IDs das tabelas
        /// </summary>
        public static class Dict
        {
            public static class PersonNameClas
            {
                public static int NomeCompleto { get { return 140; } }
            }

            public static class PersonAddressClas
            {
                public static int Email { get { return 136; } }
            }

            public static class PersonIdentifier
            {
                public static int IUPI { get { return 1; } }
            }
        }
    }
}