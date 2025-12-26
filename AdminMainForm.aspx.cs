using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminMainForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Load your initial data for GridViews here
        }
    }
    protected void btnUpdateFaculty_Click(object sender, EventArgs e)
    {
        
    }

   
    protected void btnUpdateStudent_Click(object sender, EventArgs e)
    {
       
       
    }
    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Response.Redirect("Login.aspx");
    }
}