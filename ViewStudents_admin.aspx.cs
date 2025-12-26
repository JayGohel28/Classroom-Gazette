using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class ViewStudents_admin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnStudent_Click(object sender, EventArgs e)
    {
        string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            string query = "SELECT * FROM Students_tbl";   // full table
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Remove any Designer-defined BoundFields that refer to EnrollmentNo etc.
                gvStudents.Columns.Clear();

                // Let GridView build columns from the DataTable automatically
                gvStudents.AutoGenerateColumns = true;
                gvStudents.DataSource = dt;
                gvStudents.DataBind();
            }
        }


    }
    protected void btnFaculty_Click(object sender, EventArgs e)
    {
        string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            string query = "SELECT * FROM Faculty_tbl";   // full table
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Remove any Designer-defined BoundFields that refer to EnrollmentNo etc.
                gvStudents.Columns.Clear();

                // Let GridView build columns from the DataTable automatically
                gvStudents.AutoGenerateColumns = true;
                gvStudents.DataSource = dt;
                gvStudents.DataBind();
            }
        }

    }
}