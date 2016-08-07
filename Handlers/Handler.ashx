﻿<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

public class Handler : IHttpHandler
{
    //private static readonly string DefaultUserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)";
    private CookieCollection cookies = new CookieCollection();
    
    public void ProcessRequest(HttpContext context)
    {
        var method = context.Request["method"];
        if (method == "getPic")
        {
            context.Response.ContentType = "text/plain";
            string picUrl = "https://z.hbyoubi.com:16919/SelfOpenAccount/image.jsp?" + GetTimestamp();
            var response = CreateGetHttpResponse(picUrl, cookies);

            
            Stream stream = response.GetResponseStream();
            var fileName = Guid.NewGuid() + ".jpeg";
            FileStream fs = File.Create(Path.Combine(context.Server.MapPath("/yzm"), fileName));
            long length = response.ContentLength;
            int i = 0;
            do
            {
                byte[] buffer = new byte[1024];

                i = stream.Read(buffer, 0, 1024);

                fs.Write(buffer, 0, i);

            } while (i > 0);
            fs.Close();
            for (int j = 0; j < cookies.Count; j++)
            {
                context.Response.Cookies.Add(new HttpCookie(cookies[j].Name, cookies[j].Value));
            }
            
            context.Response.Write(fileName);
        }
        else if (method == "dataInfo")
        {
            var name = context.Request["name"];
            var registeredPhoneNo = context.Request["registeredPhoneNo"];
            var fax = context.Request["fax"];
            var cardType = context.Request["cardType"];
            var cardNumber = context.Request["cardNumber"];
            var email = context.Request["email"];
            var recommendBankCode = context.Request["recommendBankCode"];
            var bankAccount = context.Request["bankAccount"];
            var postCode = context.Request["postCode"];
            var selectp = context.Request["selectp"];
            var address1 = context.Request["address1"];
            var address = context.Request["address"];
            var contactMan = context.Request["contactMan"];
            var brokerId1 = context.Request["brokerId1"];
            var type = context.Request["type"];
            var industryCode = context.Request["industryCode"];
            var zoneCode = context.Request["zoneCode"];
            var organizationCode = context.Request["organizationCode"];
            var corporateRepresentative = context.Request["corporateRepresentative"];
            var brokerId = context.Request["brokerId"];
            var brokerageid = context.Request["brokerageid"];
            var yanzhengma = context.Request["yanzhengma"];
            var ck = context.Request["ck"];

            IDictionary<string, string> parameters = new Dictionary<string, string>();
            parameters.Add("name", name);
            parameters.Add("registeredPhoneNo", registeredPhoneNo);
            parameters.Add("fax", fax);
            parameters.Add("cardType", cardType);
            parameters.Add("cardNumber", cardNumber);
            parameters.Add("email", email);
            parameters.Add("recommendBankCode", recommendBankCode);
            parameters.Add("bankAccount", bankAccount);
            parameters.Add("postCode", postCode);
            parameters.Add("selectp", selectp);
            parameters.Add("address1", address1);
            parameters.Add("address", address);
            parameters.Add("contactMan", contactMan);
            parameters.Add("brokerId1", brokerId1);
            parameters.Add("type", type);
            parameters.Add("industryCode", industryCode);
            parameters.Add("zoneCode", zoneCode);
            parameters.Add("organizationCode", organizationCode);
            parameters.Add("corporateRepresentative", corporateRepresentative);
            parameters.Add("brokerId", brokerId);
            parameters.Add("brokerageid", brokerageid);
            parameters.Add("yanzhengma", yanzhengma);
            parameters.Add("ck", ck);
            string url = "https://z.hbyoubi.com:16919/SelfOpenAccount/firmController.fir?funcflg=eidtFirm";
                     
            HttpPostedFile files = context.Request.Files["attach"];
            HttpCookieCollection hcc = context.Request.Cookies;
            cookies = new CookieCollection();
            for (int i = 0; i < hcc.Count; i++)
            {
                Cookie c = new Cookie(hcc[i].Name, hcc[i].Value);
                c.Secure = true;
                c.Discard = false;
                c.Expired = false;
                c.Path = "/SelfOpenAccount";
                cookies.Add(new Cookie(hcc[i].Name, hcc[i].Value));
            }

            HttpWebResponse response = CreatePostHttpResponseWithFile(url, parameters, files, "attach", cookies, "z.hbyoubi.com");

            Stream stream = response.GetResponseStream();   //获取响应的字符串流  
            StreamReader sr = new StreamReader(stream); //创建一个stream读取流  
            string html = sr.ReadToEnd();   //从头读到尾，放到
            
        }

    }

    private string GetTimestamp()
    {
        System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1));
        return ((int)(DateTime.Now - startTime).TotalSeconds).ToString();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private static bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
    {
        return true; //总是接受     
    }

    /// <summary>
    /// 获取请求的数据
    /// </summary>
    private string GetResponseString(HttpWebResponse webresponse)
    {
        using (Stream s = webresponse.GetResponseStream())
        {
            StreamReader reader = new StreamReader(s, Encoding.UTF8);
            return reader.ReadToEnd();
        }
    }

    /// <summary>  
    /// 创建GET方式的HTTP请求  
    /// </summary>  
    public HttpWebResponse CreateGetHttpResponse(string url, CookieCollection cookies)
    {
        HttpWebRequest request = null;
        if (url.StartsWith("https", StringComparison.OrdinalIgnoreCase))
        {
            //对服务端证书进行有效性校验（非第三方权威机构颁发的证书，如自己生成的，不进行验证，这里返回true）
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
            request = WebRequest.Create(url) as HttpWebRequest;
            request.ProtocolVersion = HttpVersion.Version10;    //http版本，默认是1.1,这里设置为1.0
        }
        else
        {
            request = WebRequest.Create(url) as HttpWebRequest;
        }
        request.Method = "GET";

        //设置代理UserAgent和超时
        //request.UserAgent = userAgent;
        //request.Timeout = timeout;
        if (cookies != null)
        {
            request.CookieContainer = new CookieContainer();
            request.CookieContainer.Add(cookies);
        }
        HttpWebResponse response = request.GetResponse() as HttpWebResponse;
        foreach (Cookie ck in response.Cookies)
        {
            cookies.Add(ck);
        }

        return response;
    }

    /// <summary>  
    /// 创建POST方式的HTTP请求  (没有文件上传)
    /// </summary>  
    public HttpWebResponse CreatePostHttpResponse(string url, IDictionary<string, string> parameters, CookieCollection cookies)
    {
        HttpWebRequest request = null;
        //如果是发送HTTPS请求  
        if (url.StartsWith("https", StringComparison.OrdinalIgnoreCase))
        {
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
            request = WebRequest.Create(url) as HttpWebRequest;
            request.ProtocolVersion = HttpVersion.Version10;
        }
        else
        {
            request = WebRequest.Create(url) as HttpWebRequest;
        }
        request.Method = "POST";
        request.ContentType = "application/x-www-form-urlencoded";

        if (cookies != null)
        {
            request.CookieContainer = new CookieContainer();
            request.CookieContainer.Add(cookies);
        }
        //发送POST数据  
        if (!(parameters == null || parameters.Count == 0))
        {
            StringBuilder buffer = new StringBuilder();
            int i = 0;
            foreach (string key in parameters.Keys)
            {
                if (i > 0)
                {
                    buffer.AppendFormat("&{0}={1}", key, parameters[key]);
                }
                else
                {
                    buffer.AppendFormat("{0}={1}", key, parameters[key]);
                    i++;
                }
            }
            byte[] data = Encoding.ASCII.GetBytes(buffer.ToString());
            using (Stream stream = request.GetRequestStream())
            {
                stream.Write(data, 0, data.Length);
            }
        }
        string[] values = request.Headers.GetValues("Content-Type");
        HttpWebResponse response = request.GetResponse() as HttpWebResponse;
        foreach (Cookie ck in response.Cookies)
        {
            cookies.Add(ck);
        }
        return response;
    }

    public HttpWebResponse CreatePostHttpResponseWithFile(string url, IDictionary<string, string> parameters, HttpPostedFile file, string fileParam, CookieCollection cookies, string Domain)
    {
        HttpWebRequest request = null;
        //如果是发送HTTPS请求  
        if (url.StartsWith("https", StringComparison.OrdinalIgnoreCase))
        {
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
            request = WebRequest.Create(url) as HttpWebRequest;
            request.ProtocolVersion = HttpVersion.Version10;
        }
        else
        {
            request = WebRequest.Create(url) as HttpWebRequest;
        }
        string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");
        byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");
        request.Method = "POST";
        request.ContentType = "multipart/form-data; boundary=" + boundary;
        request.KeepAlive = true;
        if (cookies != null)
        {
            for (int i = 0; i < cookies.Count; i++)
            {
                //不知道为啥外边给Domain赋值不成功。
                cookies[i].Domain = Domain;
            }
            
            request.CookieContainer = new CookieContainer();
            request.CookieContainer.Add(cookies);
        }
        //发送POST数据  
        Stream rs = request.GetRequestStream();

        string formdataTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
        foreach (string key in parameters.Keys)
        {
            rs.Write(boundarybytes, 0, boundarybytes.Length);
            string formitem = string.Format(formdataTemplate, key, parameters[key]);
            byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
            rs.Write(formitembytes, 0, formitembytes.Length);
        }
        rs.Write(boundarybytes, 0, boundarybytes.Length);


        string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n";
        string header = string.Format(headerTemplate, fileParam, file.FileName, file.ContentType);
        byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);
        rs.Write(headerbytes, 0, headerbytes.Length);

        Stream stream = file.InputStream;
        byte[] buffer = new byte[4096];
        int bytesRead = 0;
        
        
        
        //FileStream fileStream = new FileStream(file, FileMode.Open, FileAccess.Read);

        while ((bytesRead = stream.Read(buffer, 0, buffer.Length)) != 0)
        {
            rs.Write(buffer, 0, bytesRead);
        }
        stream.Close();

        byte[] trailer = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
        rs.Write(trailer, 0, trailer.Length);
        rs.Close();

        HttpWebResponse wresp = null;

        try
        {
            wresp = request.GetResponse() as HttpWebResponse;
            return wresp;
            //Stream stream2 = wresp.GetResponseStream();
            //StreamReader reader2 = new StreamReader(stream2);

            //result = reader2.ReadToEnd();
        }
        catch (Exception)
        {
            if (wresp != null)
            {
                wresp.Close();
                wresp = null;
            }
        }
        finally
        {
            request = null;
        }
        return wresp;
    }
}