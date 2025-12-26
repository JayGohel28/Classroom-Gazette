using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.UI; // ScriptResourceDefinition

public partial class ManageReport_admin : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Init(object sender, EventArgs e)
    {
        // Register ScriptResourceMapping named "jquery" so unobtrusive / client validators can find it.
        // You can host jQuery locally at ~/scripts/jquery-3.6.0.min.js or rely on CDN (below).
        try
        {
            ScriptManager.ScriptResourceMapping.AddDefinition(
                "jquery",
                new ScriptResourceDefinition
                {
                    Path = "~/scripts/jquery-3.6.0.min.js",
                    DebugPath = "~/scripts/jquery-3.6.0.js",
                    CdnPath = "https://code.jquery.com/jquery-3.6.0.min.js",
                    CdnDebugPath = "https://code.jquery.com/jquery-3.6.0.js"
                }
            );
        }
        catch
        {
            // ignore (mapping may already exist)
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindReports();
        }
    }

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        // Basic server-side validation (in addition to client validators)
        if (string.IsNullOrWhiteSpace(txtName.Text) ||
            string.IsNullOrWhiteSpace(txtFacultyID.Text) ||
            string.IsNullOrWhiteSpace(txtDate.Text))
        {
            // Let ValidationSummary show client-side errors; show message as fallback
            // Do not proceed with DB insert
            return;
        }

        string name = txtName.Text.Trim();
        string facultyID = txtFacultyID.Text.Trim();
        string description = txtDescription.Text.Trim();

        byte[] fileBytes = null;
        string fileName = null;

        if (fileReport.HasFile)
        {
            fileName = fileReport.FileName;
            using (MemoryStream ms = new MemoryStream())
            {
                fileReport.PostedFile.InputStream.CopyTo(ms);
                fileBytes = ms.ToArray();
            }
        }

        // parse date (if invalid, use today)
        DateTime reportDate;
        if (!DateTime.TryParse(txtDate.Text, out reportDate))
        {
            reportDate = DateTime.Now;
        }

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            string query = @"INSERT INTO FacultyReports
                            (ReportDate, Name, FacultyID, Stream, Course, Description, FileName, FileData)
                             VALUES
                            (@ReportDate, @Name, @FacultyID, @Stream, @Course, @Description, @FileName, @FileData)";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ReportDate", reportDate);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@FacultyID", facultyID);
                // these fields not present on the form - set to DBNull for now
                cmd.Parameters.AddWithValue("@Stream", DBNull.Value);
                cmd.Parameters.AddWithValue("@Course", DBNull.Value);
                cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                cmd.Parameters.AddWithValue("@FileName", string.IsNullOrEmpty(fileName) ? (object)DBNull.Value : fileName);
                if (fileBytes != null)
                    cmd.Parameters.AddWithValue("@FileData", fileBytes);
                else
                    cmd.Parameters.AddWithValue("@FileData", DBNull.Value);

                cmd.ExecuteNonQuery();
            }
        }

        // safe client-side alert
        string successMessage = "Report Created Successfully";
        string safe = HttpUtility.JavaScriptStringEncode(successMessage);
        Response.Write("<script>alert('" + safe + "');</script>");

        ClearForm();
        BindReports();
    }

    private void ClearForm()
    {
        txtName.Text = "";
        txtFacultyID.Text = "";
        txtDescription.Text = "";
        txtDate.Text = "";
        // reset file label (client-side)
        // We can't directly clear the hidden file input server-side; JS will show 'No file chosen' on next render.
    }

    private void BindReports()
    {
        DataTable dt = new DataTable();

        string sql = @"
        SELECT 
            Id,
            ReportDate,
            Name,
            FacultyID,
            Stream,
            Course,
            Description,
            FileName,
            CASE WHEN FileData IS NULL THEN 0 ELSE 1 END AS HasFile,
            DATALENGTH(FileData) AS FileSize
        FROM dbo.FacultyReports
        ORDER BY ReportDate DESC, Id DESC
    ";

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand(sql, con))
        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
        {
            da.Fill(dt);
        }

        gvReports.DataSource = dt;
        gvReports.DataBind();
    }

    protected void gvReports_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (string.Equals(e.CommandName, "download", StringComparison.OrdinalIgnoreCase))
        {
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id))
            {
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT FileData, FileName FROM FacultyReports WHERE Id = @Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    using (SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.SequentialAccess))
                    {
                        if (dr.Read())
                        {
                            object raw = dr["FileData"];
                            string storedName = dr["FileName"] != DBNull.Value ? dr["FileName"].ToString() : null;

                            if (raw != DBNull.Value && raw != null)
                            {
                                byte[] bytes = (byte[])raw;
                                string fileName = !string.IsNullOrEmpty(storedName) ? storedName : ("report_" + id + ".bin");

                                Response.Clear();
                                Response.Buffer = true;
                                Response.ContentType = "application/octet-stream";
                                Response.AddHeader("Content-Disposition", "attachment; filename=\"" + HttpUtility.UrlPathEncode(fileName) + "\"");
                                Response.BinaryWrite(bytes);
                                Response.Flush();
                                Response.End();
                            }
                            else
                            {
                                // no file attached - you could show message in future
                            }
                        }
                        else
                        {
                            // not found
                        }
                    }
                }
            }
        }

        // you may add handling for delete command here later (CommandName="delete")
    }
}
