using System;
using System.Collections.Generic;
using System.Linq;
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
    //public string brokerSelectDatas = "";
    public string selectBrokerId = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        var name = Request.QueryString["name"];
        var brokerId = Request.QueryString["broker"];
        if (!string.IsNullOrEmpty(name) && !string.IsNullOrEmpty(brokerId))
        {
            if (name == "kuangyuan")
            {
                title = "匡元";
                //StringBuilder sb = new StringBuilder();
                //sb.Append("<option></option>");
                //sb.Append("<option value='200510008'>(200510008)A</option>");
                //sb.Append("<option value='200510018'>(200510018)B</option>");
                //sb.Append("<option value='200510028'>(200510028)C</option>");
                //sb.Append("<option value='200510038'>(200510038)D</option>");
                //sb.Append("<option value='200510068'>(200510068)E</option>");
                //sb.Append("<option value='200510088'>(200510088)F</option>");
                //sb.Append("<option value='200510099'>(200510099)A7</option>");
                //sb.Append("<option value='200510100'>(200510100)A4</option>");
                //sb.Append("<option value='200510166'>(200510166)P2P</option>");
                //sb.Append("<option value='200510188'>(200510188)A6</option>");
                //sb.Append("<option value='200510189'>(200510189)B6</option>");
                //sb.Append("<option value='200510190'>(200510190)C6</option>");
                //sb.Append("<option value='200510191'>(200510191)D6</option>");
                //sb.Append("<option value='200511000'>(200511000)A2</option>");
                //sb.Append("<option value='200512000'>(200512000)C1</option>");
                //sb.Append("<option value='200513000'>(200513000)A5</option>");
                //sb.Append("<option value='200514000'>(200514000)B1</option>");
                //sb.Append("<option value='200514700'>(200514700)A1</option>");
                //sb.Append("<option value='200516001'>(200516001)W1</option>");
                //sb.Append("<option value='200516002'>(200516002)W2</option>");
                //brokerSelectDatas = sb.ToString();
                this.selectp = "上海市";
                this.address1 = "普陀区";
                this.address = "西康路1255号13层";
                this.brokerId = "20051";
                this.selectBrokerId = brokerId;
            }
        }
        else
        {
            Response.Redirect("error.html", true);
        }
    }
}