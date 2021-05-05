using System;
using System.Xml;
using System.Net;
using System.Text;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace MUP_RR.Controllers
{
    public class RCUConnector
    {
       

        public static string XmlToJson(String data){
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data);
            string jsonString = JsonConvert.SerializeXmlNode(doc);
            JObject json = JObject.Parse(jsonString);
            
            return json["soap:Envelope"]["soap:Body"].ToString();
        }
        
        public static string getRcuIupi(string userEmail)
        {
            string action = "http://app.web.ua.pt/UU/getIUPI";
            //Calling CreateSOAPWebRequest method  
            HttpWebRequest request = CreateSOAPWebRequest(action);
            XmlDocument SOAPReqBody = new XmlDocument();
            //SOAP Body Request  
            SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""utf-8""?>  
            <soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">  
             <soap:Body>  
                <getIUPI xmlns=""http://app.web.ua.pt/UU/"">  
                  <UU>" + userEmail + @"</UU>  
                </getIUPI>  
              </soap:Body>  
            </soap:Envelope>");


            using (Stream stream = request.GetRequestStream())
            {
                SOAPReqBody.Save(stream);
            }
            try{
                using (WebResponse Serviceres = request.GetResponse())
                {
                    using (StreamReader rd = new StreamReader(Serviceres.GetResponseStream()))
                    {
                        var ServiceResult = rd.ReadToEnd();
                        
                        JObject json = JObject.Parse(RCUConnector.XmlToJson(ServiceResult));
                        return json["getIUPIResponse"]["getIUPIResult"].ToString();
                    }
                }
            }catch(Exception e){
                return string.Format("EXCEPTION: {0}", e);
            }
            
        }

        public static String getUserData(string IUPI)
        {
            string action = "http://app.web.ua.pt/UU/getInfoUtilizador";
            //Calling CreateSOAPWebRequest method  
            HttpWebRequest request = CreateSOAPWebRequest(action);
            XmlDocument SOAPReqBody = new XmlDocument();
            //SOAP Body Request  
            SOAPReqBody.LoadXml(
                @"<?xml version=""1.0"" encoding=""utf-8""?>
                <soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" 
                xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
                  <soap:Body>
                    <getInfoUtilizador xmlns=""http://app.web.ua.pt/UU/"">
                      <iupi>" + IUPI + @"</iupi>
                    </getInfoUtilizador>
                  </soap:Body>
                </soap:Envelope>");


            using (Stream stream = request.GetRequestStream())
            {
                SOAPReqBody.Save(stream);
            }
            using (WebResponse Serviceres = request.GetResponse())
            {
                using (StreamReader rd = new StreamReader(Serviceres.GetResponseStream()))
                {
                    var ServiceResult = rd.ReadToEnd();
                    return RCUConnector.XmlToJson(ServiceResult);
                }
            }
        }

        public static HttpWebRequest CreateSOAPWebRequest(string _ACTION)
        {
            HttpWebRequest Req = (HttpWebRequest)WebRequest.Create(@"https://ws-ext.ua.pt/UUExt/UUExt.asmx");
            string authInfo = "muprr-rcu-srvc@ua.pt:8p#Dw8*FS9e=$T@";
            authInfo = Convert.ToBase64String(Encoding.Default.GetBytes(authInfo));
            Req.Headers["Authorization"] = "Basic " + authInfo;
            Req.Headers.Add(@"SOAPAction:"+_ACTION);
            Req.ContentType = "text/xml;charset=\"utf-8\"";
            Req.Accept = "text/xml";
            //HTTP method  
            Req.Method = "POST";
            //return HttpWebRequest  
            return Req;
        }



    }
}
