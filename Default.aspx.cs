﻿using Newtonsoft.Json.Linq;
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
    public string brokerSelectDatas = "";

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
        if (!string.IsNullOrEmpty(name))
        {
            string brokers = "";
            Stream stream = null;
            StreamReader sr = null;
            HttpWebResponse res = null;
            Dictionary<string, string> brokerDic = new Dictionary<string, string>();
            var url = @"http://kuangyuan.shtx.com.cn/brokers/" + name;
            try
            {
                res = CreateGetHttpResponse(url);
                using (stream = res.GetResponseStream())
                {
                    sr = new StreamReader(stream);
                    brokers = sr.ReadToEnd();
                    if (!string.IsNullOrEmpty(brokers))
                    {
                        JObject jobj = JObject.Parse(brokers);
                        this.title = jobj["title"].ToString();
                        this.selectp = jobj["city"].ToString();
                        this.address1 = jobj["address1"].ToString();
                        this.address = jobj["address"].ToString();
                        this.brokerId = jobj["Id"].ToString();
                        var brokersStr = jobj["brokers"].ToString();
                        JArray jArray = JArray.Parse(brokersStr);
                        StringBuilder sb = new StringBuilder();
                        sb.Append("<option></option>");
                        foreach (var job in jArray)
                        {
                            //brokerDic.Add(job["id"].ToString(), job["value"].ToString());
                            sb.Append("<option value='" + job["id"].ToString() + "'>" + job["value"].ToString() + "</option>");
                        }
                        this.brokerSelectDatas = sb.ToString();
                    }
                    else
                    {
                        //没有brokers，跳转到错误页面
                        Response.Redirect("error.html", true);
                        Response.End();
                        return;
                    }
                }
            }
            catch (Exception)
            {
                //没有获取到brokers，跳转到错误页面
                Response.Redirect("error.html", true);
                Response.End();
                return;
            }
            finally
            {
                if(res!=null)
                    res.Close();
            }

            //if (name == "kuangyuan")
            //{
            //    title = "匡元";
                
                
            //    this.selectp = "上海市";
            //    this.address1 = "普陀区";
            //    this.address = "西康路1255号13层";
            //    this.brokerId = "20051";
            //}
        }
        else
        {
            Response.Redirect("error.html", true);
        }
    }
}