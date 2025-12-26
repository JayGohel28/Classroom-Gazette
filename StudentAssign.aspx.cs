using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI.WebControls;

public partial class StudentAssign : System.Web.UI.Page
{
    // connection string name in web.config
    private readonly string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Ensure only logged-in students can access
        if (Session["UserType"] == null || Session["UserType"].ToString() != "Student")
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            // set default date
            txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

            // populate stream from session
            if (Session["StudentStream"] != null)
                txtStream.Text = Session["StudentStream"].ToString();

            // --------- YOUR REQUESTED SEMESTER BLOCK (inserted exactly) ----------
            if (Session["StudentSemester"] != null)
            {
                string sem = Session["StudentSemester"].ToString();
                if (!string.IsNullOrEmpty(sem))
                {
                    ListItem item = ddlSem.Items.FindByValue(sem);
                    if (item != null)
                        ddlSem.SelectedValue = sem;
                    else
                    {
                        // if semester stored as number but dropdown has plain numbers, try to match by text
                        item = ddlSem.Items.FindByText(sem);
                        if (item != null) ddlSem.SelectedValue = item.Value;
                    }
                }
            }
            // --------------------------------------------------------------------

            BindFacultyAssignments();
            BindYourSubmissions();
        }
    }

    /// <summary>
    /// Handles student assignment submission: saves uploaded file, inserts record into StudentAssign_tbl
    /// </summary>
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        // Basic validation
        if (string.IsNullOrEmpty(txtStream.Text) || string.IsNullOrWhiteSpace(txtSubject.Text))
        {
            Response.Write("<script>alert('Please ensure Stream and Subject are filled.');</script>");
            return;
        }

        try
        {
            // Prepare upload folder
            string uploadsFolder = Server.MapPath("~/Uploads/StudentAssignments/");
            if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);

            string fileName = null;
            string filePath = null;

            // Save uploaded file (if any)
            if (fuStudent.HasFile)
            {
                // Validate extension & size optionally
                fileName = Path.GetFileName(fuStudent.FileName);
                string unique = DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + Guid.NewGuid().ToString("n").Substring(0, 6);
                string saveName = unique + "_" + fileName;
                string saved = Path.Combine(uploadsFolder, saveName);

                fuStudent.SaveAs(saved);
                filePath = ResolveUrl("~/Uploads/StudentAssignments/" + saveName);
            }

            // Get student info from session
            int studentId = Session["StudentId"] != null ? Convert.ToInt32(Session["StudentId"]) : 0;
            string studentName = Session["Username"] != null ? Session["Username"].ToString() : "Unknown";
            string enrollment = Session["EnrollmentNo"] != null ? Session["EnrollmentNo"].ToString() : "";

            // Insert into DB and return inserted id
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string insert = @"
                    INSERT INTO StudentAssign_tbl
                    (AssignDate, Stream, Course, Subject, SemesterNo, StudentId, StudentName, EnrollmentNo, CreatedOn, FileName, FilePath)
                    VALUES
                    (@AssignDate, @Stream, @Course, @Subject, @Sem, @StudentId, @StudentName, @Enroll, @CreatedOn, @FileName, @FilePath);
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(insert, con))
                {
                    DateTime assignDate;
                    if (!DateTime.TryParse(txtDate.Text, out assignDate))
                        assignDate = DateTime.Now;

                    cmd.Parameters.Add("@AssignDate", SqlDbType.Date).Value = assignDate;
                    cmd.Parameters.Add("@Stream", SqlDbType.NVarChar, 200).Value = string.IsNullOrEmpty(txtStream.Text) ? (object)DBNull.Value : txtStream.Text;
                    cmd.Parameters.Add("@Course", SqlDbType.NVarChar, 200).Value = DBNull.Value; // optional - adjust if you have a course field
                    cmd.Parameters.Add("@Subject", SqlDbType.NVarChar, 200).Value = txtSubject.Text;
                    int semVal = 0;
                    int.TryParse(ddlSem.SelectedValue, out semVal);
                    cmd.Parameters.Add("@Sem", SqlDbType.Int).Value = semVal;
                    cmd.Parameters.Add("@StudentId", SqlDbType.Int).Value = studentId;
                    cmd.Parameters.Add("@StudentName", SqlDbType.NVarChar, 200).Value = studentName;
                    cmd.Parameters.Add("@Enroll", SqlDbType.NVarChar, 100).Value = enrollment;
                    cmd.Parameters.Add("@CreatedOn", SqlDbType.DateTime).Value = DateTime.Now;
                    cmd.Parameters.Add("@FileName", SqlDbType.NVarChar, 500).Value = (object)fileName ?? DBNull.Value;
                    cmd.Parameters.Add("@FilePath", SqlDbType.NVarChar, 1000).Value = (object)filePath ?? DBNull.Value;

                    con.Open();
                    object result = cmd.ExecuteScalar(); // returns SCOPE_IDENTITY()

                    // ---------- Fixed: robust conversion of SCOPE_IDENTITY() ----------
                    if (result != null)
                    {
                        try
                        {
                            int newId = Convert.ToInt32(result);
                            Response.Write("<script>alert('Assignment submitted successfully. ID: " + newId + "');</script>");
                        }
                        catch
                        {
                            // conversion failed (e.g. unexpected type)
                            Response.Write("<script>alert('Assignment submitted, but could not read inserted id.');</script>");
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('Assignment submitted, but no id was returned.');</script>");
                    }
                    // ------------------------------------------------------------------
                }
            }

            // refresh the student's submission list
            BindYourSubmissions();
        }
        catch (Exception ex)
        {
            // For debugging show error; in production log to file or logging system
            Response.Write("<script>alert('Error while submitting: " + Server.HtmlEncode(ex.Message) + "');</script>");
        }
    }

    /// <summary>
    /// Bind assignments published by faculty that are relevant to this student's stream/course
    /// </summary>
    private void BindFacultyAssignments()
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string qry = @"SELECT TOP 200 FacultyAssignId, Course, Subject, SemesterNo, AssignmentType, LastDate, FileName, FilePath, Stream
                               FROM FacultyAssign_tbl
                               WHERE (@CourseOrStream IS NULL OR Course LIKE @CourseOrStream) OR (@Stream IS NULL OR Stream = @Stream)
                               ORDER BY CreatedOn DESC";

                using (SqlCommand cmd = new SqlCommand(qry, con))
                {
                    string courseOrStreamParam = null;
                    if (!string.IsNullOrEmpty(txtStream.Text))
                    {
                        // If stream contains common course code, you might want to match by token
                        courseOrStreamParam = "%" + txtStream.Text + "%";
                    }

                    if (courseOrStreamParam != null)
                        cmd.Parameters.Add("@CourseOrStream", SqlDbType.NVarChar).Value = courseOrStreamParam;
                    else
                        cmd.Parameters.Add("@CourseOrStream", SqlDbType.NVarChar).Value = DBNull.Value;

                    if (!string.IsNullOrEmpty(txtStream.Text))
                        cmd.Parameters.Add("@Stream", SqlDbType.NVarChar, 200).Value = txtStream.Text;
                    else
                        cmd.Parameters.Add("@Stream", SqlDbType.NVarChar, 200).Value = DBNull.Value;

                    con.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write("<script>alert('Error loading assignments: " + Server.HtmlEncode(ex.Message) + "');</script>");
        }

        gvFacultyAssignments.DataSource = dt;
        gvFacultyAssignments.DataBind();
    }

    /// <summary>
    /// Bind logged-in student's submissions
    /// </summary>
    private void BindYourSubmissions()
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string qry = @"SELECT s.StudentAssignId, s.Subject, s.SemesterNo, s.FileName, s.FilePath, s.AssignDate, f.LastDate
                               FROM StudentAssign_tbl s
                               LEFT JOIN FacultyAssign_tbl f ON s.Subject = f.Subject AND s.Stream = f.Stream
                               WHERE s.StudentId = @StudentId
                               ORDER BY s.AssignDate DESC";

                using (SqlCommand cmd = new SqlCommand(qry, con))
                {
                    int sid = Session["StudentId"] != null ? Convert.ToInt32(Session["StudentId"]) : 0;
                    cmd.Parameters.Add("@StudentId", SqlDbType.Int).Value = sid;

                    con.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            // Add status text column for grid if missing
            if (!dt.Columns.Contains("StatusText"))
                dt.Columns.Add("StatusText", typeof(string));

            foreach (DataRow r in dt.Rows)
            {
                DateTime subDate = r["AssignDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(r["AssignDate"]);
                DateTime lastDate = DateTime.MaxValue;
                if (r.Table.Columns.Contains("LastDate") && r["LastDate"] != DBNull.Value)
                {
                    DateTime.TryParse(r["LastDate"].ToString(), out lastDate);
                }

                r["StatusText"] = (subDate > lastDate) ? "Late" : "On Time";
            }
        }
        catch (Exception ex)
        {
            Response.Write("<script>alert('Error loading your submissions: " + Server.HtmlEncode(ex.Message) + "');</script>");
        }

        gvYourSubmissions.DataSource = dt;
        gvYourSubmissions.DataBind();
    }

    // Optional: handle GridView RowCommand if you want to implement download/open server-side
    protected void gvYourSubmissions_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // Example stub: open file or delete - implement if required
    }
}
