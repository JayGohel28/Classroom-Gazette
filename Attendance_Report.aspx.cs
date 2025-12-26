using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Attendance_Report : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Default dates
            txtFromDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
            txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

            BindCourseDropdown();
            BindSemesterDropdown();
            BindDivisionDropdown();

            if (Session["UserType"] != null && Session["UserType"].ToString() == "Student")
            {
                // COURSE
                if (Session["StudentCourse"] != null)
                {
                    ListItem courseItem =
                        ddlCourseKey.Items.FindByValue(Session["StudentCourse"].ToString());

                    if (courseItem != null)
                    {
                        ddlCourseKey.ClearSelection();
                        courseItem.Selected = true;
                    }
                    ddlCourseKey.Enabled = false;
                }

                // SEMESTER
                if (Session["StudentSemester"] != null)
                {
                    ddlSemester.SelectedValue = Session["StudentSemester"].ToString();
                    ddlSemester.Enabled = false;
                }

                // DIVISION
                if (Session["StudentDivision"] != null)
                {
                    ddlDivision.SelectedValue = Session["StudentDivision"].ToString();
                    ddlDivision.Enabled = false;
                }
            }
        }
    }
    

    protected void btnLoad_Click(object sender, EventArgs e)
    {
        lblMessage.CssClass = "msg msg-info";
        lblMessage.Text = "";

        if (!Page.IsValid)
        {
            lblMessage.CssClass = "msg msg-error";
            lblMessage.Text = "Please fix the highlighted errors.";
            return;
        }

        string courseKey = ddlCourseKey.SelectedValue;    // e.g. "MCA"
        string division = ddlDivision.SelectedValue;     // e.g. "A"
        int semesterNo;
        if (!int.TryParse(ddlSemester.SelectedValue, out semesterNo))
        {
            lblMessage.CssClass = "msg msg-error";
            lblMessage.Text = "Invalid semester.";
            return;
        }

        DateTime fromDate, toDate;
        bool hasFrom = DateTime.TryParse(txtFromDate.Text, out fromDate);
        bool hasTo = DateTime.TryParse(txtToDate.Text, out toDate);

        string subjectFilter = txtSubject.Text.Trim();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT
                    s.StudentId,
                    (ISNULL(s.FirstName,'') + ' ' + ISNULL(s.LastName,'')) AS StudentName,
                    a.SubjectName,
                    COUNT(*) AS TotalLectures,
                    SUM(CASE WHEN a.AttendanceStatus = 'Present' THEN 1 ELSE 0 END) AS Presents,
                    CAST(
                        CASE WHEN COUNT(*) = 0 
                             THEN 0 
                             ELSE (SUM(CASE WHEN a.AttendanceStatus = 'Present' THEN 1 ELSE 0 END) * 100.0
                                  / COUNT(*))
                        END
                        AS DECIMAL(5,2)
                    ) AS AttendancePercent
                FROM StudentAttendance_tbl a
                INNER JOIN Students_tbl s
                    ON a.StudentId = s.StudentId
                WHERE a.CourseKey = @CourseKey
                  AND a.SemesterNo = @SemesterNo
                  AND a.Division = @Division
            ";

            if (!string.IsNullOrEmpty(subjectFilter))
            {
                query += " AND a.SubjectName LIKE @SubjectFilter";
            }

            if (hasFrom)
            {
                query += " AND a.AttendanceDate >= @FromDate";
            }

            if (hasTo)
            {
                query += " AND a.AttendanceDate <= @ToDate";
            }

            query += @"
                GROUP BY s.StudentId,
                         s.FirstName,
                         s.LastName,
                         a.SubjectName
                ORDER BY StudentName, a.SubjectName;";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@CourseKey", courseKey);
                cmd.Parameters.AddWithValue("@SemesterNo", semesterNo);
                cmd.Parameters.AddWithValue("@Division", division);

                if (!string.IsNullOrEmpty(subjectFilter))
                {
                    cmd.Parameters.AddWithValue("@SubjectFilter", "%" + subjectFilter + "%");
                }

                if (hasFrom)
                {
                    cmd.Parameters.AddWithValue("@FromDate", fromDate.Date);
                }

                if (hasTo)
                {
                    cmd.Parameters.AddWithValue("@ToDate", toDate.Date);
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvAttendance.DataSource = dt;
                    gvAttendance.DataBind();

                    if (dt.Rows.Count == 0)
                    {
                        lblMessage.Text = "No attendance records found for the selected filters.";
                    }
                    else
                    {
                        lblMessage.Text = "Showing " + dt.Rows.Count +
                            " subject-wise attendance rows for selected filters.";
                    }
                }
            }
        }
    }

    private void BindCourseDropdown()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlDataAdapter da = new SqlDataAdapter(
                "SELECT DISTINCT Course FROM Students_tbl ORDER BY Course", con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            ddlCourseKey.DataSource = dt;
            ddlCourseKey.DataTextField = "Course";
            ddlCourseKey.DataValueField = "Course";
            ddlCourseKey.DataBind();

            ddlCourseKey.Items.Insert(0, new ListItem("-- Select Course --", ""));
        }
    }

    private void BindSemesterDropdown()
    {
        ddlSemester.Items.Clear();
        ddlSemester.Items.Add(new ListItem("-- Select Semester --", ""));
        ddlSemester.Items.Add(new ListItem("1", "1"));
        ddlSemester.Items.Add(new ListItem("2", "2"));
        ddlSemester.Items.Add(new ListItem("3", "3"));
        ddlSemester.Items.Add(new ListItem("4", "4"));
        ddlSemester.Items.Add(new ListItem("5", "5"));
        ddlSemester.Items.Add(new ListItem("6", "6"));
        ddlSemester.Items.Add(new ListItem("7", "7"));
        ddlSemester.Items.Add(new ListItem("8", "8"));
    }

    private void BindDivisionDropdown()
    {
        ddlDivision.Items.Clear();
        ddlDivision.Items.Add(new ListItem("-- Select Division --", ""));
        ddlDivision.Items.Add(new ListItem("A", "A"));
        ddlDivision.Items.Add(new ListItem("B", "B"));
        ddlDivision.Items.Add(new ListItem("C", "C"));
        ddlDivision.Items.Add(new ListItem("D", "D"));
        ddlDivision.Items.Add(new ListItem("E", "E"));
        ddlDivision.Items.Add(new ListItem("F", "F"));
        ddlDivision.Items.Add(new ListItem("G", "G"));
        ddlDivision.Items.Add(new ListItem("H", "H"));
        ddlDivision.Items.Add(new ListItem("I", "I"));
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        ddlCourseKey.SelectedIndex = 0;
        ddlSemester.SelectedIndex = 0;
        ddlDivision.SelectedIndex = 0;

        txtSubject.Text = "";
        txtFromDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
        txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

        gvAttendance.DataSource = null;
        gvAttendance.DataBind();

        lblMessage.CssClass = "msg msg-info";
        lblMessage.Text = "Filters cleared.";
    }
}
