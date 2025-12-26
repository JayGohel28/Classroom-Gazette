using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI; // for ScriptResourceDefinition

public partial class FacultyReport : System.Web.UI.Page
{
    // Use your connection string name from web.config
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    // Register ScriptResourceMapping early in the page lifecycle
    protected void Page_Init(object sender, EventArgs e)
    {
        // If you have jquery locally at ~/scripts/jquery-3.6.0.min.js, mapping will use it.
        // It also provides CDN paths as fallback.
        try
        {
            // If mapping already exists, this call will replace it safely
            ScriptManager.ScriptResourceMapping.AddDefinition(
                "jquery",
                new ScriptResourceDefinition
                {
                    // Local (project) path - put jquery file at this location if you want local hosting
                    Path = "~/scripts/jquery-3.6.0.min.js",
                    DebugPath = "~/scripts/jquery-3.6.0.js",

                    // CDN fallback - will be used if you enable CDN or if local not present depending on ScriptManager settings
                    CdnPath = "https://code.jquery.com/jquery-3.6.0.min.js",
                    CdnDebugPath = "https://code.jquery.com/jquery-3.6.0.js"
                }
            );
        }
        catch
        {
            // ignore mapping errors - mapping may already be present
        }

        // OPTIONAL: If you prefer to completely disable unobtrusive mode and avoid jQuery,
        // uncomment the following line (less recommended):
        // this.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtReportDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            BindGrid();
        }
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtDescription.Text = "";
        if (ddlCourse != null) ddlCourse.Items.Clear();
        ddlStream.SelectedIndex = 0;
        txtFacultyID.Text = "";
        txtFacultyName.Text = "";
        txtReportDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        lblMsg.Text = "";
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime reportDate;
            if (!DateTime.TryParse(txtReportDate.Text, out reportDate))
                reportDate = DateTime.Now;

            string name = txtFacultyName.Text.Trim();
            string facultyId = txtFacultyID.Text.Trim();
            string stream = ddlStream.SelectedValue;
            string course = (ddlCourse != null) ? ddlCourse.Value : string.Empty;
            string description = txtDescription.Text.Trim();

            byte[] fileBytes = null;
            string fileName = null;

            if (fuReportFile.HasFile)
            {
                fileName = fuReportFile.FileName;
                using (var ms = new System.IO.MemoryStream())
                {
                    fuReportFile.PostedFile.InputStream.CopyTo(ms);
                    fileBytes = ms.ToArray();
                }
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO dbo.FacultyReports
                    (ReportDate, Name, FacultyID, Stream, Course, Description, FileName, FileData)
                    VALUES (@ReportDate, @Name, @FacultyID, @Stream, @Course, @Description, @FileName, @FileData)
                ", con))
                {
                    cmd.Parameters.Add("@ReportDate", SqlDbType.DateTime).Value = reportDate;
                    cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 150).Value = string.IsNullOrEmpty(name) ? (object)DBNull.Value : name;
                    cmd.Parameters.Add("@FacultyID", SqlDbType.NVarChar, 50).Value = string.IsNullOrEmpty(facultyId) ? (object)DBNull.Value : facultyId;
                    cmd.Parameters.Add("@Stream", SqlDbType.NVarChar, 150).Value = string.IsNullOrEmpty(stream) ? (object)DBNull.Value : stream;
                    cmd.Parameters.Add("@Course", SqlDbType.NVarChar, 150).Value = string.IsNullOrEmpty(course) ? (object)DBNull.Value : course;
                    cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(description) ? (object)DBNull.Value : description;
                    cmd.Parameters.Add("@FileName", SqlDbType.NVarChar, 260).Value = string.IsNullOrEmpty(fileName) ? (object)DBNull.Value : fileName;
                    cmd.Parameters.Add("@FileData", SqlDbType.VarBinary, -1).Value = (object)fileBytes ?? DBNull.Value;

                    cmd.ExecuteNonQuery();
                }
            }

            // Use client-side alert with safe encoding
            string successMessage = "Saved successfully.";
            string safeSuccess = HttpUtility.JavaScriptStringEncode(successMessage);
            Response.Write("<script>alert('" + safeSuccess + "');</script>");

            BindGrid();
            btnClear_Click(null, null);
        }
        catch (Exception ex)
        {
            // For production hide details; during development show for debugging
            lblMsg.Text = "Error: " + ex.Message;
        }
    }

    private void BindGrid()
    {
        DataTable dt = new DataTable();

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand(
            "SELECT Id, Name, FacultyID, Description FROM dbo.Reports_tbl_admin ORDER BY Id DESC", con))
        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
        {
            da.Fill(dt);
        }

        gvReports.DataSource = dt;
        gvReports.DataBind();
    }


    protected void gvReports_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "download")
        {
            int id;
            if (!int.TryParse(e.CommandArgument.ToString(), out id))
                return;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT FileData FROM dbo.Reports_tbl_admin WHERE Id=@Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", id);

                    using (SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.SequentialAccess))
                    {
                        if (dr.Read())
                        {
                            object raw = dr["FileData"];

                            if (raw != DBNull.Value && raw != null)
                            {
                                byte[] bytes = (byte[])raw;

                                // Because the DB does not store FileName
                                string fileName = "Report_" + id + ".bin";

                                Response.Clear();
                                Response.ContentType = "application/octet-stream";
                                Response.AddHeader("Content-Disposition",
                                    "attachment; filename=\"" + fileName + "\"");
                                Response.BinaryWrite(bytes);
                                Response.Flush();
                                Response.End();
                            }
                            else
                            {
                                lblMsg.Text = "No file attached.";
                            }
                        }
                        else
                        {
                            lblMsg.Text = "Report not found.";
                        }
                    }
                }
            }
        }
    }

    // AJAX WebMethod for course list
    [WebMethod]
    public static List<string> GetCourses(string stream)
    {
        if (string.IsNullOrEmpty(stream)) return new List<string>();

        switch (stream)
        {
            case "Computer & IT Streams":
                return new List<string> {
                    "BCA – Bachelor of Computer Applications","MCA – Master of Computer Applications",
                    "B.Sc IT – Information Technology","B.Sc Computer Science","M.Sc Computer Science",
                    "Artificial Intelligence (AI)","Data Science","Cyber Security","Cloud Computing","Software Engineering"
                };

            case "Engineering & Technology Streams":
                return new List<string> {
                    "B.Tech – Computer Engineering","B.Tech – Information Technology","B.Tech – Mechanical Engineering",
                    "B.Tech – Civil Engineering","B.Tech – Electrical Engineering","B.Tech – Electronics Engineering",
                    "Diploma – Computer Engineering","Diploma – Mechanical Engineering","Diploma – Civil Engineering","M.Tech – Any Specialization"
                };

            case "Management & Commerce Streams":
                return new List<string> {
                    "BBA – Bachelor of Business Administration","MBA – Master of Business Administration",
                    "B.Com – General","B.Com – Accounting & Finance","M.Com – Commerce",
                    "Banking & Insurance","Digital Marketing","Retail Management","Logistics & Supply Chain","Entrepreneurship & Family Business"
                };

            case "Science Streams":
                return new List<string> {
                    "B.Sc – Physics, Chemistry, Maths","B.Sc – Biotechnology","B.Sc – Microbiology","B.Sc – Chemistry",
                    "B.Sc – Physics","B.Sc – Mathematics","M.Sc – Physics","M.Sc – Chemistry","M.Sc – Mathematics","B.Sc – Nursing"
                };

            case "Arts & Humanities Streams":
                return new List<string> {
                    "BA – English Literature","BA – Psychology","BA – Sociology","BA – History","BA – Political Science",
                    "BA – Economics","MA – English","MA – Psychology","Journalism & Mass Communication","Liberal Arts – Interdisciplinary"
                };

            case "Medical & Health Streams":
                return new List<string> {
                    "MBBS","BDS – Dental","BAMS – Ayurveda","BHMS – Homeopathy","B.Sc – Nursing",
                    "Physiotherapy","Medical Lab Technology","Radiology","Pharmacy – B.Pharm","Pharmacy – D.Pharm"
                };

            case "Law & Education":
                return new List<string> {
                    "LLB – Bachelor of Law","LLM – Master of Law","BBA LLB – Integrated","BA LLB – Integrated",
                    "B.Ed – Bachelor of Education","M.Ed – Master of Education","D.El.Ed – Diploma in Elementary Education"
                };

            case "Design, Media & Creative Fields":
                return new List<string> {
                    "Fashion Designing","Interior Designing","Graphic Designing","Animation & VFX","Film Making",
                    "Photography","UI/UX Design","Game Design","3D Animation","Visual Communication"
                };

            case "Polytechnic & Skill-Based Streams":
                return new List<string> {
                    "ITI – Electrician","ITI – Fitter","ITI – Welder","Diploma – Automobile Engineering","Diploma – Electronics",
                    "Hardware & Networking","Mobile Repairing","CNC Machine Operation"
                };

            case "School Level Streams":
                return new List<string> {
                    "9th Standard","10th Standard","11th Science","11th Commerce","11th Arts","12th Science","12th Commerce","12th Arts"
                };

            default:
                return new List<string>();
        }
    }
}
