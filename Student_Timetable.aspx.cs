using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

public partial class Student_Timetable : System.Web.UI.Page
{
    private readonly string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    private string StudentCourse
    {
        get { return ViewState["StudentCourse"] as string; }
        set { ViewState["StudentCourse"] = value; }
    }

    private string StudentSemesterTerm
    {
        get { return ViewState["StudentSemesterTerm"] as string; }
        set { ViewState["StudentSemesterTerm"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            try
            {
                LoadStudentProfile();
                txtFilterDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
                BindTimetable(filterBySpecificDate: true, specificDate: DateTime.Today);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Page_Load error: " + ex);
                lblMessage.Text = "Error loading page.";
            }
        }
    }

    private void LoadStudentProfile()
    {
        if (Session["Username"] == null)
        {
            lblMessage.Text = "Please login to view your timetable.";
            gvTimetable.DataSource = null;
            gvTimetable.DataBind();
            return;
        }

        string username = Session["Username"].ToString();

        string query = @"
            SELECT TOP 1 StudentId, FirstName, LastName, Stream, Division, Semester
            FROM Students_tbl
            WHERE Username = @Username";

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
            cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 200).Value = username;
            con.Open();

            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                if (dr.Read())
                {
                    string firstName = dr["FirstName"] != DBNull.Value ? dr["FirstName"].ToString() : "";
                    string lastName = dr["LastName"] != DBNull.Value ? dr["LastName"].ToString() : "";
                    string stream = dr["Stream"] != DBNull.Value ? dr["Stream"].ToString() : "";
                    string division = dr["Division"] != DBNull.Value ? dr["Division"].ToString() : "";
                    string semText = dr["Semester"] != DBNull.Value ? dr["Semester"].ToString() : "";

                    lblStudentName.Text = (firstName + " " + lastName).Trim();
                    lblCourse.Text = !string.IsNullOrEmpty(stream) ? stream : "-";
                    lblDivision.Text = !string.IsNullOrEmpty(division) ? division : "-";
                    lblSemester.Text = !string.IsNullOrEmpty(semText) ? ("Semester " + semText) : "-";

                    StudentCourse = stream; // e.g. "Management & Commerce Streams"
                    StudentSemesterTerm = !string.IsNullOrEmpty(semText) ? ("Semester " + semText) : null;

                    if (!string.IsNullOrEmpty(StudentCourse))
                        lblMessage.Text = "Showing timetable for: " + StudentCourse +
                                          (StudentSemesterTerm != null ? " • " + StudentSemesterTerm : "");
                }
                else
                {
                    lblMessage.Text = "Student profile not found.";
                    StudentCourse = null;
                    StudentSemesterTerm = null;
                }
            }
        }
    }

    /// <summary>
    /// Bind timetable. Try multiple pattern matches: CourseName OR StreamName, raw and cleaned course text.
    /// </summary>
    private void BindTimetable(bool filterBySpecificDate, DateTime? specificDate = null)
    {
        lblMessage.Text = ""; // clear
        if (string.IsNullOrEmpty(StudentCourse))
        {
            gvTimetable.DataSource = null;
            gvTimetable.DataBind();
            lblMessage.Text = "StudentCourse is empty. Check Students_tbl Stream value.";
            return;
        }

        // Prepare candidate patterns
        // rawPattern: exact StudentCourse (wrapped in % for LIKE)
        // cleanPattern: remove the word "Streams" and replace '&' with 'and', trim.
        string rawPattern = "%" + StudentCourse + "%";
        string cleanCourse = Regex.Replace(StudentCourse ?? "", @"\bStreams\b", "", RegexOptions.IgnoreCase)
                                    .Replace("&", "and")
                                    .Replace("/", " ")
                                    .Trim();
        // if cleaning removed everything, ensure fallback to StudentCourse
        if (string.IsNullOrWhiteSpace(cleanCourse))
            cleanCourse = StudentCourse;

        string cleanPattern = "%" + cleanCourse + "%";

        // Main query: match CourseName OR StreamName using either pattern
        string query = @"
            SELECT
                CONVERT(varchar(10), LectureDate, 120) AS LectureDate,
                DATENAME(weekday, LectureDate) AS LectureDay,
                StreamName,
                CourseName,
                SubjectName,
                FacultyName,
                BuildingName,
                RoomNo,
                SemesterTerm,
                CONVERT(varchar(5), StartTime, 108) AS StartTime,
                CONVERT(varchar(5), EndTime, 108) AS EndTime
            FROM StudentTimetable_tbl
            WHERE
                (
                    CourseName LIKE @RawPattern
                    OR CourseName LIKE @CleanPattern
                    OR StreamName LIKE @RawPattern
                    OR StreamName LIKE @CleanPattern
                )";

        // Semester filtering same as before (flexible)
        if (!string.IsNullOrEmpty(StudentSemesterTerm))
        {
            query += " AND (SemesterTerm = @SemesterTerm OR SemesterTerm = @SemesterTermNumeric)";
        }

        // Date filter: date-only comparison
        if (filterBySpecificDate && specificDate.HasValue)
        {
            query += " AND CONVERT(date, LectureDate) = @LectureDate";
        }
        else
        {
            query += " AND CONVERT(date, LectureDate) >= @Today";
        }

        query += " ORDER BY LectureDate, StartTime";

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
            cmd.Parameters.Add("@RawPattern", SqlDbType.NVarChar, 300).Value = rawPattern;
            cmd.Parameters.Add("@CleanPattern", SqlDbType.NVarChar, 300).Value = cleanPattern;

            if (!string.IsNullOrEmpty(StudentSemesterTerm))
            {
                string numericPart = Regex.Match(StudentSemesterTerm ?? "", @"\d+").Value;
                cmd.Parameters.Add("@SemesterTerm", SqlDbType.NVarChar, 50).Value = StudentSemesterTerm;
                if (!string.IsNullOrEmpty(numericPart))
                    cmd.Parameters.Add("@SemesterTermNumeric", SqlDbType.NVarChar, 50).Value = numericPart;
                else
                    cmd.Parameters.Add("@SemesterTermNumeric", SqlDbType.NVarChar, 50).Value = DBNull.Value;
            }

            if (filterBySpecificDate && specificDate.HasValue)
                cmd.Parameters.Add("@LectureDate", SqlDbType.Date).Value = specificDate.Value.Date;
            else
                cmd.Parameters.Add("@Today", SqlDbType.Date).Value = DateTime.Today;

            try
            {
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvTimetable.DataSource = dt;
                    gvTimetable.DataBind();

                    if (dt.Rows.Count == 0)
                    {
                        string diag = RunDiagnosticsForPatterns(StudentCourse, rawPattern, cleanPattern, StudentSemesterTerm, specificDate);
                        lblMessage.Text = "No lectures found for the selected criteria.<br/><br/>Diagnostics:<br/>" + diag;
                    }
                    else
                    {
                        lblMessage.Text = "Showing " + dt.Rows.Count + " lecture(s) for "
                                          + StudentCourse
                                          + (StudentSemesterTerm != null ? " • " + StudentSemesterTerm : "");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindTimetable error: " + ex);
                lblMessage.Text = "An error occurred while loading the timetable.";
            }
        }
    }

    /// <summary>
    /// Diagnostics that include counts for both raw and cleaned patterns and sample rows.
    /// </summary>
    private string RunDiagnosticsForPatterns(string course, string rawPattern, string cleanPattern, string semesterTerm, DateTime? specificDate)
    {
        var sb = new System.Text.StringBuilder();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // total rows
            using (SqlCommand cAll = new SqlCommand("SELECT COUNT(*) FROM StudentTimetable_tbl", con))
            {
                int total = Convert.ToInt32(cAll.ExecuteScalar());
                sb.AppendFormat("- Total rows in StudentTimetable_tbl: {0}<br/>", total);
            }

            // counts for raw pattern
            using (SqlCommand cCourse = new SqlCommand(
                "SELECT COUNT(*) FROM StudentTimetable_tbl WHERE (CourseName LIKE @Pattern OR StreamName LIKE @Pattern)", con))
            {
                cCourse.Parameters.Add("@Pattern", SqlDbType.NVarChar, 300).Value = rawPattern;
                int matchRaw = Convert.ToInt32(cCourse.ExecuteScalar());
                sb.AppendFormat("- Rows matching raw pattern '{0}': {1}<br/>", rawPattern, matchRaw);
            }

            // counts for clean pattern
            using (SqlCommand cCourseClean = new SqlCommand(
                "SELECT COUNT(*) FROM StudentTimetable_tbl WHERE (CourseName LIKE @Pattern OR StreamName LIKE @Pattern)", con))
            {
                cCourseClean.Parameters.Add("@Pattern", SqlDbType.NVarChar, 300).Value = cleanPattern;
                int matchClean = Convert.ToInt32(cCourseClean.ExecuteScalar());
                sb.AppendFormat("- Rows matching cleaned pattern '{0}': {1}<br/>", cleanPattern, matchClean);
            }

            // semester check
            if (!string.IsNullOrEmpty(semesterTerm))
            {
                string numericPart = Regex.Match(semesterTerm ?? "", @"\d+").Value;
                using (SqlCommand cSem = new SqlCommand(
                    "SELECT COUNT(*) FROM StudentTimetable_tbl WHERE (CourseName LIKE @Pattern OR StreamName LIKE @Pattern) AND (SemesterTerm = @SemesterTerm OR SemesterTerm = @SemesterTermNumeric)", con))
                {
                    cSem.Parameters.Add("@Pattern", SqlDbType.NVarChar, 300).Value = rawPattern;
                    cSem.Parameters.Add("@SemesterTerm", SqlDbType.NVarChar, 50).Value = semesterTerm;
                    if (!string.IsNullOrEmpty(numericPart))
                        cSem.Parameters.Add("@SemesterTermNumeric", SqlDbType.NVarChar, 50).Value = numericPart;
                    else
                        cSem.Parameters.Add("@SemesterTermNumeric", SqlDbType.NVarChar, 50).Value = DBNull.Value;

                    int matchCourseSem = Convert.ToInt32(cSem.ExecuteScalar());
                    sb.AppendFormat("- Rows matching pattern + SemesterTerm: {0}<br/>", matchCourseSem);
                }
            }
            else
            {
                sb.AppendFormat("- No StudentSemesterTerm available to check SemesterTerm filter.<br/>");
            }

            // date checks if provided
            if (specificDate.HasValue)
            {
                using (SqlCommand cDate = new SqlCommand("SELECT COUNT(*) FROM StudentTimetable_tbl WHERE CONVERT(date, LectureDate) = @LectureDate", con))
                {
                    cDate.Parameters.Add("@LectureDate", SqlDbType.Date).Value = specificDate.Value.Date;
                    int matchDate = Convert.ToInt32(cDate.ExecuteScalar());
                    sb.AppendFormat("- Rows with LectureDate = {0}: {1}<br/>", specificDate.Value.ToString("yyyy-MM-dd"), matchDate);
                }

                using (SqlCommand cCourseDate = new SqlCommand(
                    "SELECT COUNT(*) FROM StudentTimetable_tbl WHERE (CourseName LIKE @Pattern OR StreamName LIKE @Pattern) AND CONVERT(date, LectureDate) = @LectureDate", con))
                {
                    cCourseDate.Parameters.Add("@Pattern", SqlDbType.NVarChar, 300).Value = rawPattern;
                    cCourseDate.Parameters.Add("@LectureDate", SqlDbType.Date).Value = specificDate.Value.Date;
                    int matchCourseDate = Convert.ToInt32(cCourseDate.ExecuteScalar());
                    sb.AppendFormat("- Rows matching pattern + LectureDate: {0}<br/>", matchCourseDate);
                }
            }

            // sample rows for patterns (if any)
            using (SqlCommand cSample = new SqlCommand(
                "SELECT TOP 10 LectureDate, CourseName, SemesterTerm, StreamName, StartTime, EndTime FROM StudentTimetable_tbl WHERE (CourseName LIKE @Pattern OR StreamName LIKE @Pattern) ORDER BY LectureDate DESC", con))
            {
                cSample.Parameters.Add("@Pattern", SqlDbType.NVarChar, 300).Value = rawPattern;
                using (SqlDataAdapter da = new SqlDataAdapter(cSample))
                {
                    DataTable dtSample = new DataTable();
                    da.Fill(dtSample);

                    if (dtSample.Rows.Count == 0)
                    {
                        sb.Append("- No sample rows found for raw pattern. Try clean pattern sample below.<br/>");
                    }
                    else
                    {
                        sb.AppendFormat("- Sample rows for raw pattern '{0}':<br/>", rawPattern);
                        sb.Append("<table border='1' cellpadding='4' cellspacing='0'><tr><th>LectureDate</th><th>CourseName</th><th>SemesterTerm</th><th>StreamName</th><th>StartTime</th><th>EndTime</th></tr>");
                        foreach (DataRow r in dtSample.Rows)
                        {
                            sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>{5}</td></tr>",
                                r["LectureDate"], r["CourseName"], r["SemesterTerm"], r["StreamName"], r["StartTime"], r["EndTime"]);
                        }
                        sb.Append("</table>");
                    }
                }
            }

            // sample rows for clean pattern
            using (SqlCommand cSampleClean = new SqlCommand(
                "SELECT TOP 10 LectureDate, CourseName, SemesterTerm, StreamName, StartTime, EndTime FROM StudentTimetable_tbl WHERE (CourseName LIKE @Pattern OR StreamName LIKE @Pattern) ORDER BY LectureDate DESC", con))
            {
                cSampleClean.Parameters.Add("@Pattern", SqlDbType.NVarChar, 300).Value = cleanPattern;
                using (SqlDataAdapter da = new SqlDataAdapter(cSampleClean))
                {
                    DataTable dtSample = new DataTable();
                    da.Fill(dtSample);

                    if (dtSample.Rows.Count > 0)
                    {
                        sb.AppendFormat("- Sample rows for cleaned pattern '{0}':<br/>", cleanPattern);
                        sb.Append("<table border='1' cellpadding='4' cellspacing='0'><tr><th>LectureDate</th><th>CourseName</th><th>SemesterTerm</th><th>StreamName</th><th>StartTime</th><th>EndTime</th></tr>");
                        foreach (DataRow r in dtSample.Rows)
                        {
                            sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>{5}</td></tr>",
                                r["LectureDate"], r["CourseName"], r["SemesterTerm"], r["StreamName"], r["StartTime"], r["EndTime"]);
                        }
                        sb.Append("</table>");
                    }
                }
            }
        } // using con

        return sb.ToString();
    }

    protected void btnFilterToday_Click(object sender, EventArgs e)
    {
        DateTime date;
        if (DateTime.TryParseExact(txtFilterDate.Text, "yyyy-MM-dd",
            System.Globalization.CultureInfo.InvariantCulture,
            System.Globalization.DateTimeStyles.None, out date))
        {
            BindTimetable(filterBySpecificDate: true, specificDate: date);
        }
        else
        {
            lblMessage.Text = "Invalid date format. Use yyyy-MM-dd. Showing today's timetable.";
            BindTimetable(filterBySpecificDate: true, specificDate: DateTime.Today);
        }
    }

    protected void btnFilterAll_Click(object sender, EventArgs e)
    {
        BindTimetable(filterBySpecificDate: false);
    }
}
