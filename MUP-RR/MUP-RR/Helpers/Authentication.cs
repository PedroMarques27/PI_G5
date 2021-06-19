using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using MUP_RR.Controllers;

namespace MUP_RR.Helpers
{
    public class Authentication
    {
        public bool Success { get; private set; }
        public string Error { get; private set; }
        public static HttpContext Ses { get; set; }

        public Authentication(
            HttpContext context,
            IConfiguration configuration,
            DBConnector database)
        {
            try
            {
                var shibboleth = new Shibboleth(context, configuration);
                var session = new Session(context.Session);

                // se não houver iupi em sessão
                if (session.IUPI == Guid.Empty)
                {
                    Contract.Assert(context != null);

                    Environment env = new Environment(configuration);

                    // verifica se existem Headers para a autenticação
                    if (!string.IsNullOrWhiteSpace(shibboleth.Email) || env.IsLocalhost(context))
                    {
                        // existem cabeçalhos, processa o login
                        Guid iupi;
                        string fullName;
                        string shortName;
                        string email;

                        // bloco para acesso local, simula credenciais
                        if (env.IsLocalhost(context))
                        {
                            fullName = "! Teste user nome";
                            shortName = "! Teste user";
                            email = "cobaia@ua.pt";
                            iupi = new Guid("e8f6d698-33d9-4f91-a5ea-4fb6e844b950");
                        }
                        else
                        {
                            // existem cabeçalhos, processa o login
                            iupi = shibboleth.IUPI;
                            fullName = shibboleth.NomeCompleto;
                            shortName = shibboleth.NomeCurto;
                            email = shibboleth.Email;
                        }

                        session.FullName = fullName;
                        session.ShortName = string.IsNullOrWhiteSpace(shortName) ? StringNormalizer.FirstAndLastName(fullName) : shortName;
                        session.IUPI = iupi;
                        session.Email = email;
                        session.SessionActive = true;

                        // carrega info da base de dados
                        session.Roles = GetRolesForUser(iupi.ToString(), database);

                        Success = true;

                        Console.Write("Utilizador autenticado: {@sessions}",session);

                    }
                    else
                    {

                        Console.Write("Utilizador não autenticado: {@Email}",shibboleth.Email);
                        Error = "Utilizador não autenticado: " + shibboleth.Email;
                        Success = false;
                    }
                    //else
                    //{
                    //	// não existem cabeçalhos, redireciona para área segura (caso ainda não tenha ido lá)
                    //	if (requestCredentials && !Session.AuthTried)
                    //		c.Response.Redirect(String.Format("{0}Default.aspx?referer={1}", ConfigurationManager.AppSettings["Auth:SecurePath"], HttpUtility.UrlEncode(c.Request.Url.PathAndQuery)));
                    //	else
                    //		new Helpers.Log(Helpers.Log.ActionType.LoginFailed, "sem dados de Shibboleth");
                    //}
                }
                else
                {
                    Success = true;
                }
            }
            catch (Exception e)
            {
                Error = e.Message;
                Success = false;
            }
        }

        private static List<RoleAuthorization.Roles> GetRolesForUser(
            string iupi,
            DBConnector db)
        {
            var roles = new List<RoleAuthorization.Roles>();

            //verifica se é admin na BD
            if (db.isAdmin(iupi))
                roles.Add(RoleAuthorization.Roles.admin);

            roles.Add(RoleAuthorization.Roles.user);

            return roles;
        }

        public class Shibboleth
        {
            #region private fields

            private readonly HttpContext _c;
            private readonly bool useHeaders = false;

            #endregion private fields

            #region ctor

            public Shibboleth(HttpContext context, IConfiguration config)
            {
                // By default we use Variables as auth method, unless Headers
                // is specified in appSettings
                useHeaders = config["ShibbolethMethod"] == "Headers";
                _c = context;
            }

            #endregion ctor

            #region public properties

            public Guid IUPI
            {
                get
                {
                    string guid;

                    if (useHeaders)
                        guid = _c.Request.Headers[shib_iupi];
                    else
                        guid = _c.GetServerVariable(shib_iupi);

                    Guid.TryParse(guid, out Guid output);
                    return output;
                }
            }

            public string NomeCompleto
            {
                get
                {
                    string name;
                    if (useHeaders)
                        name = _c.Request.Headers[shib_nomecompleto];
                    else
                        name = _c.GetServerVariable(shib_nomecompleto);

                    return name;
                }
            }

            public string NomeCurto
            {
                get
                {
                    string shortname;

                    if (useHeaders)
                        shortname = _c.Request.Headers[shib_nomeamigavel];
                    else
                        shortname = _c.GetServerVariable(shib_nomeamigavel);

                    if (string.IsNullOrEmpty(shortname))
                    {
                        string firstName, lastName;

                        if (useHeaders)
                        {
                            firstName = _c.Request.Headers[shib_nome];
                            lastName = _c.Request.Headers[shib_apelido];
                        }
                        else
                        {
                            firstName = _c.GetServerVariable(shib_nome);
                            lastName = _c.GetServerVariable(shib_apelido);
                        }

                        shortname = $"{firstName} {lastName}";
                    }

                    return shortname;
                }
            }

            public string Email
            {
                get
                {
                    string email;
                    if (useHeaders)
                        email = _c.Request.Headers[shib_uu];
                    else
                        email = _c.GetServerVariable(shib_uu);

                    return email;
                }
            }

            #endregion public properties

            #region private constants

            private const string shib_iupi = "iupi";
            private const string shib_nomecompleto = "fullname";
            private const string shib_nomeamigavel = "shib_nomeamigavel";
            private const string shib_uu = "mail";
            private const string shib_nome = "shib_nome";
            private const string shib_apelido = "shib_apelido";

            #endregion private constants
        }
    }
}