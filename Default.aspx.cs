using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    public string title = "";
    public string selectp = "";
    public string address1 = "";
    public string address = "";
    public string brokerId = "";
    public string selectBrokerId = "";

    /// <summary>  
    /// 创建GET方式的HTTP请求  
    /// </summary>  
    public HttpWebResponse CreateGetHttpResponse(string url)
    {
        HttpWebRequest request = null;
        request = WebRequest.Create(url) as HttpWebRequest;
        request.Method = "GET";
        HttpWebResponse response = request.GetResponse() as HttpWebResponse;
        return response;
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        var name = Request.QueryString["name"];
        var brokerId = Request.QueryString["broker"];
        if (!string.IsNullOrEmpty(name) && !string.IsNullOrEmpty(brokerId))
        {
            if (name == "kuangyuan")
            {
                title = "匡元";
                this.selectBrokerId = brokerId;
                this.selectp = "上海市";
                this.address1 = "普陀区";
                this.address = "西康路1255号13层";
                this.brokerId = "20051";
            }
        }
        else
        {
            Response.Redirect("error.html", true);
        }
    }
}