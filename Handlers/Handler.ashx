<%@ WebHandler Language="C#" Class="Handler" %>

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
        context.Response.Write(fileName);
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
}