using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Show_FacultyEvent : Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadData();
        }
    }

    private void LoadData()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string sql = "SELECT Id, EventName, StartDate, EndDate, Description, FileData FROM FacultyEvents_tbl ORDER BY Id DESC";
            SqlDataAdapter da = new SqlDataAdapter(sql, con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvEvents.DataSource = dt;
            gvEvents.DataBind();
        }
    }

    protected void gvEvents_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvEvents.PageIndex = e.NewPageIndex;
        LoadData();
    }

    protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Download")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            DownloadFile(id);
        }
    }

    private void DownloadFile(int id)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand("SELECT EventName, FileData FROM FacultyEvents_tbl WHERE Id = @Id", con))
        {
            cmd.Parameters.AddWithValue("@Id", id);
            con.Open();

            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                if (dr["FileData"] == DBNull.Value) return;

                byte[] bytes = (byte[])dr["FileData"];
                string eventName = dr["EventName"].ToString();
                string fileName = eventName.Replace(" ", "_") + ".pdf";

                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                Response.BinaryWrite(bytes);
                Response.End();
            }
        }
    }
}
