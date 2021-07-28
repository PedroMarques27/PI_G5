using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Session;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MUP_RR.Helpers
{
    public class Session
    {
        public ISession _session { get; set; }

        public Session(ISession session)
        {
            _session = session;
        }

        public string FullName
        {
            get
            {
                string nome = "";
                try
                {
                    nome = _session.GetString(SessionManager.Keys.FullName.ToString());
                }
                catch { }
                return nome;
            }
            set
            {
                _session.SetString(SessionManager.Keys.FullName.ToString(), value);
            }
        }

        public string ShortName
        {
            get
            {
                string nome = "";
                try
                {
                    nome = _session.GetString(SessionManager.Keys.ShortName.ToString());
                }
                catch { }
                return nome;
            }
            set
            {
                _session.SetString(SessionManager.Keys.ShortName.ToString(), value);
            }
        }

        public int UserID
        {
            get
            {
                int id = 0;
                try
                {
                    if (_session.GetString(SessionManager.Keys.UserID.ToString()) != null)
                        Int32.TryParse(_session.GetString(SessionManager.Keys.UserID.ToString()), out id);
                }
                catch { }
                return id;
            }
            set
            {
                _session.SetString(SessionManager.Keys.UserID.ToString(), value.ToString());
            }
        }

        public Guid IUPI
        {
            get
            {
                Guid iupi = new Guid();
                try
                {
                    iupi = Guid.Parse(_session.GetString(SessionManager.Keys.Iupi.ToString()));
                }
                catch { }
                return iupi;
            }
            set
            {
                try
                {
                    _session.SetString(SessionManager.Keys.Iupi.ToString(), value.ToString());
                }
                catch { }
            }
        }

        public string Email
        {
            get
            {
                string s = "";
                try
                {
                    s = _session.GetString(SessionManager.Keys.Email.ToString());
                }
                catch { }
                return s;
            }
            set
            {
                _session.SetString(SessionManager.Keys.Email.ToString(), value);
            }
        }

        public bool IsAdmin
        {
            get
            {
                bool admin = false;
                try
                {
                    Roles.Contains(RoleAuthorization.Roles.admin);
                }
                catch { }
                return admin;
            }
        }

        private string Language
        {
            get
            {
                string s = "";
                try
                {
                    if (_session.GetString("s_Language") != null)
                        s = _session.GetString("s_Language");
                }
                catch { }
                return s;
            }
            set
            {
                _session.SetString("s_UserIsAdmin", value);
            }
        }

        public string ContentLanguage
        {
            get
            {
                string s = "pt";
                try
                {
                    if (_session.GetString("s_ContentLanguage") != null)
                        s = _session.GetString("s_ContentLanguage");
                }
                catch { }
                return s;
            }
            set
            {
                _session.SetString("s_ContentLanguage", value);
            }
        }

        public bool Impersonated
        {
            get
            {
                bool imp = false;
                try
                {
                    if (_session.GetString(SessionManager.Keys.Impersonated.ToString()) != null)
                        imp = Boolean.Parse(_session.GetString(SessionManager.Keys.Impersonated.ToString()));
                }
                catch { }
                return imp;
            }
            set
            {
                _session.SetString(SessionManager.Keys.Impersonated.ToString(), value.ToString());
            }
        }

        public bool AuthTried
        {
            get
            {
                bool temp = false;
                try
                {
                    if (_session.GetString("s_SecureAccessed") != null)
                        temp = Boolean.Parse(_session.GetString("s_SecureAccessed"));
                }
                catch { }
                return temp;
            }
            set
            {
                _session.SetString("s_SecureAccessed", value.ToString());
            }
        }

        public string Roles_
        {
            get
            {
                string s = "";
                try
                {
                    if (_session.GetString("s_UserRoles") != null)
                        s = _session.GetString("s_UserRoles");
                }
                catch { }
                return s;
            }
            set
            {
                _session.SetString("s_UserRoles", value.ToString());
            }
        }

        public List<RoleAuthorization.Roles> Roles
        {
            get
            {
                var roles = new List<RoleAuthorization.Roles>();

                //var strRoles = HttpContext.Current.Session["s_UserRoles"]?.ToString() ?? "";
                var strRoles = _session.GetString(SessionManager.Keys.Roles.ToString())?.ToString() ?? "";

                if (!string.IsNullOrEmpty(strRoles))
                {
                    foreach (var r in strRoles.Split(','))
                    {
                        if (Enum.TryParse(r, out RoleAuthorization.Roles role))
                        {
                            roles.Add(role);
                        }
                    }
                }

                return roles;
            }
            set
            {
                var txt = string.Join(",", value.Select(r => r.ToString()));
                _session.SetString(SessionManager.Keys.Roles.ToString(), txt);
            }
        }

        public string ReturnAddress
        {
            get
            {
                string s = "";
                try
                {
                    if (_session.GetString("s_ReturnTo") != null)
                        s = _session.GetString("s_ReturnTo");
                }
                catch { }
                return s;
            }
            set
            {
                _session.SetString("s_ReturnTo", value.ToString());
            }
        }

        public int Unit
        {
            get
            {
                int id = 0;
                try
                {
                    if (_session.GetString("s_Unit") != null)
                        Int32.TryParse(_session.GetString("s_Unit"), out id);
                }
                catch { }
                return id;
            }
            set
            {
                _session.SetString("s_ReturnTo", value.ToString());
            }
        }

        public bool UserActive
        {
            get
            {
                bool temp = false;
                try
                {
                    if (_session.GetString("s_UserActive") != null)
                        temp = Boolean.Parse(_session.GetString("s_UserActive"));
                }
                catch { }
                return temp;
            }
            set
            {
                _session.SetString("s_ReturnTo", value.ToString());
            }
        }

        public bool SessionActive
        {
            get
            {
                bool temp = false;
                try
                {
                    if (_session.GetString(SessionManager.Keys.SessionIsActive.ToString()) != null)
                        temp = Boolean.Parse(_session.GetString(SessionManager.Keys.SessionIsActive.ToString()));
                }
                catch { }
                return temp;
            }
            set
            {
                _session.SetString(SessionManager.Keys.SessionIsActive.ToString(), value.ToString());
            }
        }

        public void Logout()
        {
            _session.Clear();
            SessionActive = false;
        }
    }

    /// <summary>
    /// Helper para sessões com dependency injection
    ///
    /// Para usar em controladores adicionar:
    /// private readonly Helpers.SessionManager _session; //private field
    ///
    ///  public ProjectController(Helpers.SessionManager session)
    ///    {
    ///        _session = session;
    ///    }
    ///
    /// Para usar em Views:
    /// @using Microsoft.AspNetCore.Http
    /// @inject IHttpContextAccessor httpContextAccessor
    /// @{ var _session = new CRIS.Helpers.SessionManager(httpContextAccessor);}
    ///
    /// Nota: falta forma de aceder à sessão sem ser por dependency injection
    ///
    /// </summary>
    public class SessionManager
    {
        #region private fields

        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ISession _session;

        #endregion private fields

        #region ctor

        public SessionManager(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
            _session = _httpContextAccessor.HttpContext.Session;
        }

        #endregion ctor

        #region properties

        public string FullName
        {
            get
            {
                return _session.GetString(Keys.FullName.ToString());
                //string nome = "";
                //try
                //{
                //    nome = _session.GetString(nameof(FullName));
                //}
                //catch { }
                //return nome;
            }
            set
            {
                _session.SetString(Keys.FullName.ToString(), value);
            }
        }

        public string ShortName
        {
            get
            {
                return _session.GetString(Keys.ShortName.ToString());
                //string nome = "";
                //try
                //{
                //    nome = _session.GetString(nameof(ShortName));
                //}
                //catch { }
                //return nome;
            }
            set
            {
                _session.SetString(Keys.ShortName.ToString(), value);
            }
        }

        public int UserID
        {
            get
            {
                var v = _session.GetString(Keys.UserID.ToString());
                try
                {
                    return int.Parse(v);
                }
                catch (Exception)
                {
                    return 0;
                }

                //int id = 0;
                //try
                //{
                //    var name = nameof(UserID);
                //    if (_session.GetString(name) != null)
                //        int.TryParse(_session.GetString(name), out id);
                //}
                //catch { }
                //return id;
            }
            set
            {
                _session.SetString(Keys.UserID.ToString(), value.ToString());
            }
        }

        public Guid IUPI
        {
            get
            {
                var v = _session.GetString(Keys.Iupi.ToString());
                Guid.TryParse(v, out Guid iupi);
                return iupi;

                //Guid iupi = new Guid();
                //try
                //{
                //    iupi = Guid.Parse(_session.GetString(nameof(IUPI)));
                //}
                //catch { }
                //return iupi;
            }
            set
            {
                try
                {
                    _session.SetString(Keys.Iupi.ToString(), value.ToString());
                }
                catch { }
            }
        }

        public string Email
        {
            get
            {
                return _session.GetString(Keys.Email.ToString());
                //string s = "";
                //try
                //{
                //    s = _session.GetString(nameof(Email));
                //}
                //catch { }
                //return s;
            }
            set
            {
                _session.SetString(Keys.Email.ToString(), value);
            }
        }

        public bool IsAdmin
        {
            get
            {
                return Roles.Contains(RoleAuthorization.Roles.admin);
                //bool admin = false;
                //try
                //{
                //    var strRoles = _session.GetString(nameof(Roles)) ?? "";
                //    admin = !string.IsNullOrEmpty(strRoles)
                //        && strRoles.Split(',')
                //            .Contains(RoleAuthorization.Roles.admin.ToString());
                //}
                //catch { }
                //return admin;
            }
        }

        public bool Impersonated
        {
            get
            {
                var v = _session.GetString(Keys.Impersonated.ToString());
                bool.TryParse(v, out bool impersonated);
                return impersonated;

                //bool imp = false;
                //try
                //{
                //    string name = nameof(Impersonated);
                //    if (_session.GetString(name) != null)
                //        imp = bool.Parse(_session.GetString(name));
                //}
                //catch { }
                //return imp;
            }
            set
            {
                _session.SetString(Keys.Impersonated.ToString(), value.ToString());
            }
        }

        public List<RoleAuthorization.Roles> Roles
        {
            get
            {
                var v = _session.GetString(Keys.Roles.ToString());
                var roles = new List<RoleAuthorization.Roles>();

                if (!string.IsNullOrEmpty(v))
                    foreach (var r in v.Split(','))
                        if (Enum.TryParse(r, out RoleAuthorization.Roles role))
                            roles.Add(role);

                return roles;
            }
            set
            {
                var v = string.Join(",", value.Select(r => r.ToString()));
                _session.SetString(Keys.Roles.ToString(), v);
            }
        }

        public bool SessionIsActive
        {
            get
            {
                var v = _session.GetString(Keys.SessionIsActive.ToString());
                bool.TryParse(v, out bool active);
                return active;

                //bool temp = false;
                //try
                //{
                //    string name = nameof(SessionActive);
                //    if (_session.GetString(name) != null)
                //        temp = bool.Parse(_session.GetString(name));
                //}
                //catch { }
                //return temp;
            }
            set
            {
                _session.SetString(Keys.SessionIsActive.ToString(), value.ToString());
            }
        }

        #endregion properties

        public enum Keys
        {
            UserID,
            FullName,
            ShortName,
            Email,
            Iupi,
            Roles,
            SessionIsActive,
            Impersonated
        }

        public void Clear()
        {
            _session.Clear();
        }
    }
}