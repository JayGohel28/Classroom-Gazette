using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI; // for ScriptResourceDefinition

public partial class ManageStudentEvents_admin : System.Web.UI.Page
{
    private string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Init(object sender, EventArgs e)
    {
        // Register jquery mapping to avoid unobtrusive validation errors
        try
        {
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery",
                new ScriptResourceDefinition
                {
                    Path = "~/scripts/jquery-3.6.0.min.js",
                    DebugPath = "~/scripts/jquery-3.6.0.js",
                    CdnPath = "https://code.jquery.com/jquery-3.6.0.min.js",
                    CdnDebugPath = "https://code.jquery.com/jquery-3.6.0.js"
                });
        }
        catch
        {
            // ignore if already registered
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // default dates to system date (yyyy-MM-dd for date input)
            string today = DateTime.Now.ToString("yyyy-MM-dd");
            if (txtStartDate != null) txtStartDate.Text = today;
            if (txtEndDate != null) txtEndDate.Text = today;

            BindEvents();
        }
    }

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        // Respect validators
        if (!Page.IsValid)
            return;

        try
        {
            string eventName = (txtEventName != null) ? txtEventName.Text.Trim() : string.Empty;
            string startText = (txtStartDate != null) ? txtStartDate.Text.Trim() : string.Empty;
            string endText = (txtEndDate != null) ? txtEndDate.Text.Trim() : string.Empty;
            string description = (txtDescription != null) ? txtDescription.Text.Trim() : string.Empty;

            DateTime startDate;
            DateTime endDate;
            object startParam = DBNull.Value;
            object endParam = DBNull.Value;

            if (!string.IsNullOrEmpty(startText) && DateTime.TryParse(startText, out startDate))
                startParam = startDate;

            if (!string.IsNullOrEmpty(endText) && DateTime.TryParse(endText, out endDate))
                endParam = endDate;

            byte[] fileBytes = null;
            string fileName = null;
            string fileType = null;

            if (fileCircular != null && fileCircular.HasFile)
            {
                fileName = Path.GetFileName(fileCircular.FileName);
                fileType = fileCircular.PostedFile.ContentType;

                using (BinaryReader br = new BinaryReader(fileCircular.PostedFile.InputStream))
                {
                    fileBytes = br.ReadBytes(fileCircular.PostedFile.ContentLength);
                }
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                string query = @"INSERT INTO StudentEvents_tbl
                                (EventName, StartDate, EndDate, Description, FileData, FileName, FileType)
                                VALUES (@EventName, @StartDate, @EndDate, @Description, @FileData, @FileName, @FileType)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventName", eventName);
                    cmd.Parameters.AddWithValue("@StartDate", startParam);
                    cmd.Parameters.AddWithValue("@EndDate", endParam);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);

                    if (fileBytes != null)
                        cmd.Parameters.AddWithValue("@FileData", fileBytes);
                    else
                        cmd.Parameters.AddWithValue("@FileData", DBNull.Value);

                    if (!string.IsNullOrEmpty(fileName))
                        cmd.Parameters.AddWithValue("@FileName", fileName);
                    else
                        cmd.Parameters.AddWithValue("@FileName", DBNull.Value);

                    if (!string.IsNullOrEmpty(fileType))
                        cmd.Parameters.AddWithValue("@FileType", fileType);
                    else
                        cmd.Parameters.AddWithValue("@FileType", DBNull.Value);

                    cmd.ExecuteNonQuery();
                }
            }

            ClientScript.RegisterStartupScript(GetType(), "created", "alert('Student Event Created Successfully!');", true);
            ClearForm();
            BindEvents();
        }
        catch (Exception ex)
        {
            ClientScript.RegisterStartupScript(GetType(), "err", "alert('Error: " + HttpUtility.JavaScriptStringEncode(ex.Message) + "');", true);
        }
    }

    private void ClearForm()
    {
        if (txtEventName != null) txtEventName.Text = string.Empty;
        if (txtStartDate != null) txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        if (txtEndDate != null) txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        if (txtDescription != null) txtDescription.Text = string.Empty;
        // file label reset will be handled client-side when user interacts next time
    }

    private void BindEvents()
    {
        DataTable dt = new DataTable();
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = "SELECT Id, EventName, StartDate, EndDate, Description, FileName FROM StudentEvents_tbl ORDER BY Id DESC";
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                da.Fill(dt);
            }
        }

        gvEvents.DataSource = dt;
        gvEvents.DataBind();
    }

    #region Grid Events

    protected void gvEvents_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvEvents.EditIndex = e.NewEditIndex;
        BindEvents();
    }

    protected void gvEvents_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvEvents.EditIndex = -1;
        BindEvents();
    }

    protected void gvEvents_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = Convert.ToInt32(gvEvents.DataKeys[e.RowIndex].Value);
        GridViewRow row = gvEvents.Rows[e.RowIndex];

        TextBox txtName = row.FindControl("txtEvtName_Edit") as TextBox;
        TextBox txtStart = row.FindControl("txtStart_Edit") as TextBox;
        TextBox txtEnd = row.FindControl("txtEnd_Edit") as TextBox;
        TextBox txtDesc = row.FindControl("txtDesc_Edit") as TextBox;
        FileUpload fileUpload = row.FindControl("file_Edit") as FileUpload;

        string eventName = (txtName != null) ? txtName.Text.Trim() : string.Empty;
        string startText = (txtStart != null) ? txtStart.Text.Trim() : string.Empty;
        string endText = (txtEnd != null) ? txtEnd.Text.Trim() : string.Empty;
        string description = (txtDesc != null) ? txtDesc.Text.Trim() : string.Empty;

        DateTime startDate;
        DateTime endDate;
        object startParam = DBNull.Value;
        object endParam = DBNull.Value;

        if (!string.IsNullOrEmpty(startText) && DateTime.TryParse(startText, out startDate))
            startParam = startDate;

        if (!string.IsNullOrEmpty(endText) && DateTime.TryParse(endText, out endDate))
            endParam = endDate;

        byte[] newFile = null;
        string newFileName = null;
        string newFileType = null;

        if (fileUpload != null && fileUpload.HasFile)
        {
            newFileName = Path.GetFileName(fileUpload.FileName);
            newFileType = fileUpload.PostedFile.ContentType;

            using (BinaryReader br = new BinaryReader(fileUpload.PostedFile.InputStream))
            {
                newFile = br.ReadBytes(fileUpload.PostedFile.ContentLength);
            }
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                string sql = @"UPDATE StudentEvents_tbl
                               SET EventName=@EventName, StartDate=@StartDate, EndDate=@EndDate, Description=@Description";

                if (newFile != null)
                    sql += ", FileData=@FileData, FileName=@FileName, FileType=@FileType";

                sql += " WHERE Id=@Id";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@EventName", eventName);
                    cmd.Parameters.AddWithValue("@StartDate", startParam);
                    cmd.Parameters.AddWithValue("@EndDate", endParam);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);

                    if (newFile != null)
                    {
                        cmd.Parameters.AddWithValue("@FileData", newFile);
                        cmd.Parameters.AddWithValue("@FileName", newFileName);
                        cmd.Parameters.AddWithValue("@FileType", newFileType);
                    }

                    cmd.Parameters.AddWithValue("@Id", id);

                    cmd.ExecuteNonQuery();
                }
            }

            gvEvents.EditIndex = -1;
            BindEvents();
            ClientScript.RegisterStartupScript(GetType(), "updated", "alert('Event updated successfully');", true);
        }
        catch (Exception ex)
        {
            ClientScript.RegisterStartupScript(GetType(), "errupd", "alert('Error updating: " + HttpUtility.JavaScriptStringEncode(ex.Message) + "');", true);
        }
    }

    protected void gvEvents_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = Convert.ToInt32(gvEvents.DataKeys[e.RowIndex].Value);

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                string sql = "DELETE FROM StudentEvents_tbl WHERE Id=@Id";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
            }

            BindEvents();
            ClientScript.RegisterStartupScript(GetType(), "deleted", "alert('Event deleted');", true);
        }
        catch (Exception ex)
        {
            ClientScript.RegisterStartupScript(GetType(), "errdel", "alert('Error deleting: " + HttpUtility.JavaScriptStringEncode(ex.Message) + "');", true);
        }
    }

    protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (string.Equals(e.CommandName, "ViewFile", StringComparison.OrdinalIgnoreCase))
        {
            int id;
            if (int.TryParse(Convert.ToString(e.CommandArgument), out id))
            {
                DownloadFile(id);
            }
        }
    }

    #endregion

    private void DownloadFile(int id)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                string sql = "SELECT FileData, FileName, FileType FROM StudentEvents_tbl WHERE Id=@Id";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Id", id);

                    using (SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.SingleRow))
                    {
                        if (dr.Read())
                        {
                            if (!dr.IsDBNull(0))
                            {
                                byte[] bytes = (byte[])dr["FileData"];
                                string fileName = dr["FileName"] != DBNull.Value ? dr["FileName"].ToString() : ("Event_" + id);
                                string fileType = dr["FileType"] != DBNull.Value ? dr["FileType"].ToString() : "application/octet-stream";

                                HttpResponse response = HttpContext.Current.Response;
                                response.Clear();
                                response.ContentType = fileType;
                                response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                                response.BinaryWrite(bytes);
                                response.Flush();

                                HttpContext.Current.ApplicationInstance.CompleteRequest();
                                return;
                            }
                            else
                            {
                                ClientScript.RegisterStartupScript(GetType(), "nofile", "alert('No file available for this event.');", true);
                                return;
                            }
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(GetType(), "notfound", "alert('Event not found.');", true);
                            return;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClientScript.RegisterStartupScript(GetType(), "errdl", "alert('Error while downloading: " + HttpUtility.JavaScriptStringEncode(ex.Message) + "');", true);
        }
    }
}
