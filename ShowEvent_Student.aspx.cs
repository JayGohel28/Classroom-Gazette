using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ShowEvent_Student : Page
{
    // uses your connection string name
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            BindEvents();
    }

    private void BindEvents()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = "SELECT Id, EventName, StartDate, EndDate, Description FROM StudentEvents_tbl ORDER BY Id DESC";
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvEvents.DataSource = dt;
                gvEvents.DataBind();
            }
        }
    }

    protected void gvEvents_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvEvents.PageIndex = e.NewPageIndex;
        BindEvents();
    }

    protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Download")
        {
            int id;
            if (int.TryParse((e.CommandArgument ?? "").ToString(), out id))
            {
                DownloadCircular(id);
            }
        }
    }

    private void DownloadCircular(int id)
    {
        // Adjust column names if you store filename/contenttype separately.
        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand("SELECT EventName, FileData FROM StudentEvents_tbl WHERE Id = @Id", con))
        {
            cmd.Parameters.AddWithValue("@Id", id);
            con.Open();

            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                if (!dr.Read())
                    return;

                if (dr["FileData"] == DBNull.Value)
                    return; // no file attached

                byte[] fileBytes = (byte[])dr["FileData"];
                string eventName = (dr["EventName"] as string) ?? "circular";

                // If you store original filename/content type:
                // string origName = dr["FileName"] as string;
                // string contentType = dr["ContentType"] as string;

                string fileName = eventName.Trim().Replace(" ", "_") + ".pdf";
                string contentType = "application/pdf"; // change if you store ContentType

                HttpResponse resp = HttpContext.Current.Response;
                resp.Clear();
                resp.Buffer = true;
                resp.ContentType = contentType;
                resp.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                resp.BinaryWrite(fileBytes);
                resp.Flush();

                // Use CompleteRequest to avoid ThreadAbortException from Response.End
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
    }
}
