using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentMainForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        /*if (!IsPostBack)
        {
            if (Session["EnrollmentNo"] != null)
            {
                lblEnroll.Text = Session["EnrollmentNo"].ToString();
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }*/

    }
    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Response.Redirect("Login.aspx");
    }
    
}