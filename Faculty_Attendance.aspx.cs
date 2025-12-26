using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Faculty_Attendance : System.Web.UI.Page
{
    private readonly string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ddlCourse.Items.Clear();
            ddlCourse.Items.Add(new ListItem("-- Select Course --", ""));
            ddlSubject.Items.Clear();
            ddlSubject.Items.Add(new ListItem("-- Select Subject --", ""));
        }
    }

    protected void ddlStream_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlCourse.Items.Clear();
        ddlCourse.Items.Add(new ListItem("-- Select Course --", ""));

        string stream = GetDropdownEffectiveValue(ddlStream);
        List<string> courses = GetCoursesForStream(stream);
        foreach (string c in courses)
            ddlCourse.Items.Add(new ListItem(c, c));

        ddlSubject.Items.Clear();
        ddlSubject.Items.Add(new ListItem("-- Select Subject --", ""));
    }

    private List<string> GetCoursesForStream(string stream)
    {
        if (string.IsNullOrEmpty(stream)) return new List<string>();

        switch (stream.Trim())
        {
            case "Computer & IT Streams":
                return new List<string> {
                    "MCA",
                    "BCA",
                    "B.Sc IT",
                    "B.Sc",
                    "M.Sc",
                    "Artificial Intelligence",
                    "Data Science",
                    "Cyber Security",
                    "Cloud Computing",
                    "Software Engineering"
                };
            case "Engineering & Technology Streams":
                return new List<string> {
                    "B.Tech",
                    "Diploma",
                    "M.Tech"
                };
            case "Management & Commerce Streams":
                return new List<string> {
                    "BBA",
                    "MBA",
                    "B.Com",
                    "M.Com",
                    "Banking & Insurance",
                    "Digital Marketing",
                    "Retail Management",
                    "Logistics & Supply Chain",
                    "Entrepreneurship & Family Business"
                };
            case "Science Streams":
                return new List<string> {
                    "B.Sc",
                    "M.Sc"
                };
            case "Arts & Humanities Streams":
                return new List<string> {
                    "BA",
                    "MA",
                    "Journalism & Mass Communication",
                    "Liberal Arts"
                };
            case "Medical & Health Streams":
                return new List<string> {
                    "MBBS",
                    "BDS",
                    "BAMSAyurveda",
                    "BHMSHomeopathy",
                    "B.ScNursing",
                    "Physiotherapy",
                    "Medical Lab Technology",
                    "Radiology",
                    "PharmacyB.Pharm",
                    "PharmacyD.Pharm"
                };
            case "Law & Education":
                return new List<string> {
                    "LLB",
                    "LLM",
                    "BBA LLBIntegrated",
                    "BA LLBIntegrated",
                    "B.Ed",
                    "M.Ed",
                    "D.El.Ed"
                };
            case "Design, Media & Creative Fields":
                return new List<string> {
                    "Fashion Designing",
                    "Interior Designing",
                    "Graphic Designing",
                    "Animation & VFX",
                    "Film Making",
                    "Photography",
                    "UI/UX Design",
                    "Game Design",
                    "3D Animation",
                    "Visual Communication"
                };
            case "Polytechnic & Skill-Based Streams":
                return new List<string> {
                    "ITIElectrician",
                    "ITIFitter",
                    "ITIWelder",
                    "DiplomaAutomobile Engineering",
                    "DiplomaElectronics",
                    "Hardware & Networking",
                    "Mobile Repairing",
                    "CNC Machine Operation"
                };
            case "School Level Streams":
                return new List<string> {
                    "9th Standard",
                    "10th Standard",
                    "11th Science",
                    "11th Commerce",
                    "11th Arts",
                    "12th Science",
                    "12th Commerce",
                    "12th Arts"
                };
            default:
                return new List<string>();
        }
    }

    protected void btnLoadSubjects_Click(object sender, EventArgs e)
    {
        lblInfo.Text = string.Empty;

        DateTime lectureDate;
        if (!DateTime.TryParse(txtDate.Text, out lectureDate))
        {
            lblInfo.Text = "Invalid date.";
            return;
        }

        string courseName = GetDropdownEffectiveValue(ddlCourse);
        string semesterTerm = GetDropdownEffectiveValue(ddlSem);

        if (string.IsNullOrEmpty(courseName) || string.IsNullOrEmpty(semesterTerm))
        {
            lblInfo.Text = "Please select Course and Semester first.";
            return;
        }

        ddlSubject.Items.Clear();
        ddlSubject.Items.Add(new ListItem("-- Select Subject --", ""));

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                string q1 = @"
                    SELECT DISTINCT SubjectName
                    FROM StudentTimetable_tbl
                    WHERE CAST(LectureDate AS DATE) = @LectureDate
                      AND CourseName = @CourseName
                      AND SemesterTerm = @SemesterTerm
                    ORDER BY SubjectName";

                using (SqlCommand cmd = new SqlCommand(q1, con))
                {
                    cmd.Parameters.AddWithValue("@LectureDate", lectureDate.Date);
                    cmd.Parameters.AddWithValue("@CourseName", courseName);
                    cmd.Parameters.AddWithValue("@SemesterTerm", semesterTerm);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            ddlSubject.Items.Add(new ListItem(Convert.ToString(dr["SubjectName"]), Convert.ToString(dr["SubjectName"])));
                        }
                    }
                }

                if (ddlSubject.Items.Count == 1)
                {
                    // fallback attempt
                    string courseKey = GetCourseKeyFromCourseName(courseName);
                    string q2 = @"
                        SELECT DISTINCT SubjectName
                        FROM StudentTimetable_tbl
                        WHERE CAST(LectureDate AS DATE) = @LectureDate
                          AND (CourseName LIKE '%' + @CourseNameLike + '%' OR CourseKey = @CourseKey)
                          AND SemesterTerm = @SemesterTerm
                        ORDER BY SubjectName";

                    using (SqlCommand cmd2 = new SqlCommand(q2, con))
                    {
                        cmd2.Parameters.AddWithValue("@LectureDate", lectureDate.Date);
                        cmd2.Parameters.AddWithValue("@CourseNameLike", courseName);
                        cmd2.Parameters.AddWithValue("@CourseKey", courseKey);
                        cmd2.Parameters.AddWithValue("@SemesterTerm", semesterTerm);

                        using (SqlDataReader dr2 = cmd2.ExecuteReader())
                        {
                            while (dr2.Read())
                            {
                                ddlSubject.Items.Add(new ListItem(Convert.ToString(dr2["SubjectName"]), Convert.ToString(dr2["SubjectName"])));
                            }
                        }
                    }
                }
            }

            if (ddlSubject.Items.Count == 1)
                lblInfo.Text = "No subjects found. Tried Date=" + lectureDate.ToString("yyyy-MM-dd") + " | CourseName='" + courseName + "' | SemesterTerm='" + semesterTerm + "'.";
            else
                lblInfo.Text = "Subjects loaded (" + (ddlSubject.Items.Count - 1) + ").";
        }
        catch (Exception ex)
        {
            lblInfo.Text = "Error loading subjects: " + ex.Message;
        }
    }

    protected void btnLoadStudents_Click(object sender, EventArgs e)
    {
        lblInfo.Text = string.Empty;

        string courseName = GetDropdownEffectiveValue(ddlCourse);
        string semesterText = GetDropdownEffectiveValue(ddlSem);
        int semesterNumber = GetSemesterNumber(semesterText);
        string division = GetDropdownEffectiveValue(ddlDivision);
        string courseKey = GetCourseKeyFromCourseName(courseName);

        if (string.IsNullOrEmpty(courseName) || string.IsNullOrEmpty(semesterText) || string.IsNullOrEmpty(division))
        {
            lblInfo.Text = "Select Course, Semester and Division before loading students.";
            gvStudents.DataSource = null;
            gvStudents.DataBind();
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                string table = "Students_tbl";
                if (!TableExists(con, table))
                {
                    lblInfo.Text = "Students_tbl not found in database.";
                    return;
                }

                DataTable dt = new DataTable();

                // Try several heuristics to find students
                using (SqlCommand cmd = new SqlCommand(string.Format(@"
                    SELECT StudentId, EnrollmentNumber, ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') AS StudentName, Stream, Course, Semester, Division
                    FROM {0}
                    WHERE Stream = @StreamKey AND Division = @Division AND Semester = @Semester
                    ORDER BY EnrollmentNumber", table), con))
                {
                    cmd.Parameters.AddWithValue("@StreamKey", courseKey);
                    cmd.Parameters.AddWithValue("@Division", division);
                    cmd.Parameters.AddWithValue("@Semester", semesterNumber);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(dt);
                }

                if (dt.Rows.Count == 0)
                {
                    // try Course exact
                    using (SqlCommand cmd2 = new SqlCommand(string.Format(@"
                        SELECT StudentId, EnrollmentNumber, ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') AS StudentName, Stream, Course, Semester, Division
                        FROM {0}
                        WHERE Course = @CourseName AND Division = @Division AND Semester = @Semester
                        ORDER BY EnrollmentNumber", table), con))
                    {
                        cmd2.Parameters.AddWithValue("@CourseName", courseName);
                        cmd2.Parameters.AddWithValue("@Division", division);
                        cmd2.Parameters.AddWithValue("@Semester", semesterNumber);
                        using (SqlDataAdapter da2 = new SqlDataAdapter(cmd2))
                            da2.Fill(dt);
                    }
                }

                if (dt.Rows.Count == 0)
                {
                    // try stream like
                    using (SqlCommand cmd3 = new SqlCommand(string.Format(@"
                        SELECT StudentId, EnrollmentNumber, ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') AS StudentName, Stream, Course, Semester, Division
                        FROM {0}
                        WHERE Stream LIKE @StreamLike AND Division = @Division AND Semester = @Semester
                        ORDER BY EnrollmentNumber", table), con))
                    {
                        cmd3.Parameters.AddWithValue("@StreamLike", courseKey + "%");
                        cmd3.Parameters.AddWithValue("@Division", division);
                        cmd3.Parameters.AddWithValue("@Semester", semesterNumber);
                        using (SqlDataAdapter da3 = new SqlDataAdapter(cmd3))
                            da3.Fill(dt);
                    }
                }

                if (dt.Rows.Count == 0)
                {
                    // try course contains
                    using (SqlCommand cmd4 = new SqlCommand(string.Format(@"
                        SELECT StudentId, EnrollmentNumber, ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') AS StudentName, Stream, Course, Semester, Division
                        FROM {0}
                        WHERE Course LIKE '%' + @CourseNameLike + '%' AND Division = @Division AND Semester = @Semester
                        ORDER BY EnrollmentNumber", table), con))
                    {
                        cmd4.Parameters.AddWithValue("@CourseNameLike", courseName);
                        cmd4.Parameters.AddWithValue("@Division", division);
                        cmd4.Parameters.AddWithValue("@Semester", semesterNumber);
                        using (SqlDataAdapter da4 = new SqlDataAdapter(cmd4))
                            da4.Fill(dt);
                    }
                }

                BindStudents(dt);

                if (dt.Rows.Count == 0)
                    lblInfo.Text = "No students found. Check DB values (Stream/Course/Semester/Division).";
                else
                    lblInfo.Text = "Loaded " + dt.Rows.Count + " students.";
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "Error loading students: " + ex.Message;
            gvStudents.DataSource = null;
            gvStudents.DataBind();
        }
    }

    // -------- SAVE implementation (insert or update) ----------
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblInfo.Text = string.Empty;

        // basic validations
        DateTime date;
        if (!DateTime.TryParse(txtDate.Text, out date))
        {
            lblInfo.Text = "Invalid lecture date.";
            return;
        }

        string courseName = GetDropdownEffectiveValue(ddlCourse);
        string courseKey = GetCourseKeyFromCourseName(courseName);
        string semesterTerm = GetDropdownEffectiveValue(ddlSem);
        int semesterNo = GetSemesterNumber(semesterTerm);
        string division = GetDropdownEffectiveValue(ddlDivision);
        string subject = GetDropdownEffectiveValue(ddlSubject);

        if (string.IsNullOrEmpty(courseName) || semesterNo == 0 || string.IsNullOrEmpty(division) || string.IsNullOrEmpty(subject))
        {
            lblInfo.Text = "Please select Course, Semester, Division and Subject before saving attendance.";
            return;
        }

        if (gvStudents.Rows.Count == 0)
        {
            lblInfo.Text = "No students loaded. Load students before saving attendance.";
            return;
        }

        string facultyName = Session["Username"] != null ? Session["Username"].ToString() : "Faculty";

        int inserted = 0, updated = 0, skipped = 0;

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                using (SqlTransaction trx = con.BeginTransaction())
                {
                    try
                    {
                        foreach (GridViewRow row in gvStudents.Rows)
                        {
                            if (row.RowType != DataControlRowType.DataRow) continue;

                            // StudentId from DataKeys
                            int studentId = 0;
                            if (gvStudents.DataKeys != null && gvStudents.DataKeys.Count > row.RowIndex)
                            {
                                object dk = gvStudents.DataKeys[row.RowIndex].Value;
                                if (dk != null)
                                    int.TryParse(dk.ToString(), out studentId);
                            }

                            // Enrollment number – try Template label then cell fallback
                            string enrollmentNo = string.Empty;
                            var lblEnroll = row.FindControl("lblEnrollment") as Label;
                            if (lblEnroll != null)
                                enrollmentNo = lblEnroll.Text.Trim();
                            else if (row.Cells.Count > 0)
                                enrollmentNo = row.Cells[0].Text.Trim();

                            // Status from dropdown
                            string status = "Present";
                            DropDownList ddlStatus = row.FindControl("ddlStatus") as DropDownList;
                            if (ddlStatus != null)
                                status = ddlStatus.SelectedValue;

                            // If studentId isn't present, try to resolve via EnrollmentNo
                            if (studentId == 0 && !string.IsNullOrEmpty(enrollmentNo))
                            {
                                using (SqlCommand idCmd = new SqlCommand("SELECT TOP 1 StudentId FROM Students_tbl WHERE EnrollmentNumber = @Enroll", con, trx))
                                {
                                    idCmd.Parameters.AddWithValue("@Enroll", enrollmentNo);
                                    object o = idCmd.ExecuteScalar();
                                    if (o != null)
                                        int.TryParse(o.ToString(), out studentId);
                                }
                            }

                            if (studentId == 0)
                            {
                                skipped++;
                                continue; // cannot save without student id
                            }

                            // Check if attendance already exists for this student/date/subject
                            string existsQ = @"
                                SELECT AttendanceId
                                FROM StudentAttendance_tbl
                                WHERE AttendanceDate = @AttendanceDate
                                  AND StudentId = @StudentId
                                  AND SubjectName = @SubjectName
                                  AND CourseKey = @CourseKey
                                  AND Division = @Division
                                  -- optional: SemesterNo check
                                ";

                            int existingAttendanceId = 0;
                            using (SqlCommand existsCmd = new SqlCommand(existsQ, con, trx))
                            {
                                existsCmd.Parameters.AddWithValue("@AttendanceDate", date.Date);
                                existsCmd.Parameters.AddWithValue("@StudentId", studentId);
                                existsCmd.Parameters.AddWithValue("@SubjectName", subject);
                                existsCmd.Parameters.AddWithValue("@CourseKey", courseKey);
                                existsCmd.Parameters.AddWithValue("@Division", division);

                                object exIdObj = existsCmd.ExecuteScalar();
                                if (exIdObj != null)
                                    int.TryParse(exIdObj.ToString(), out existingAttendanceId);
                            }

                            if (existingAttendanceId > 0)
                            {
                                // UPDATE existing row
                                string upd = @"
                                    UPDATE StudentAttendance_tbl
                                    SET AttendanceStatus = @AttendanceStatus,
                                        FacultyName = @FacultyName,
                                        CreatedOn = GETDATE()
                                    WHERE AttendanceId = @AttendanceId";
                                using (SqlCommand updCmd = new SqlCommand(upd, con, trx))
                                {
                                    updCmd.Parameters.AddWithValue("@AttendanceStatus", status);
                                    updCmd.Parameters.AddWithValue("@FacultyName", facultyName);
                                    updCmd.Parameters.AddWithValue("@AttendanceId", existingAttendanceId);
                                    int aff = updCmd.ExecuteNonQuery();
                                    if (aff > 0) updated++;
                                    else skipped++;
                                }
                            }
                            else
                            {
                                // INSERT new row
                                string ins = @"
                                    INSERT INTO StudentAttendance_tbl
                                    (AttendanceDate, CourseKey, CourseName, SemesterNo, SemesterTerm, Division, SubjectName,
                                     StudentId, EnrollmentNo, AttendanceStatus, FacultyName, CreatedOn)
                                    VALUES
                                    (@AttendanceDate, @CourseKey, @CourseName, @SemesterNo, @SemesterTerm, @Division, @SubjectName,
                                     @StudentId, @EnrollmentNo, @AttendanceStatus, @FacultyName, GETDATE())";

                                using (SqlCommand insCmd = new SqlCommand(ins, con, trx))
                                {
                                    insCmd.Parameters.AddWithValue("@AttendanceDate", date.Date);
                                    insCmd.Parameters.AddWithValue("@CourseKey", courseKey);
                                    insCmd.Parameters.AddWithValue("@CourseName", courseName);
                                    insCmd.Parameters.AddWithValue("@SemesterNo", semesterNo);
                                    insCmd.Parameters.AddWithValue("@SemesterTerm", semesterTerm);
                                    insCmd.Parameters.AddWithValue("@Division", division);
                                    insCmd.Parameters.AddWithValue("@SubjectName", subject);
                                    insCmd.Parameters.AddWithValue("@StudentId", studentId);
                                    insCmd.Parameters.AddWithValue("@EnrollmentNo", enrollmentNo);
                                    insCmd.Parameters.AddWithValue("@AttendanceStatus", status);
                                    insCmd.Parameters.AddWithValue("@FacultyName", facultyName);

                                    int aff = insCmd.ExecuteNonQuery();
                                    if (aff > 0) inserted++;
                                    else skipped++;
                                }
                            }
                        } // foreach row

                        trx.Commit();
                    }
                    catch
                    {
                        trx.Rollback();
                        throw;
                    }
                } // using trx
            } // using con

            lblInfo.Text = string.Format("Attendance saved: inserted={0}, updated={1}, skipped={2}.", inserted, updated, skipped);
        }
        catch (Exception ex)
        {
            lblInfo.Text = "Error saving attendance: " + ex.Message;
        }
    }

    private void BindStudents(DataTable dt)
    {
        gvStudents.DataKeyNames = new string[] { "StudentId" };
        gvStudents.DataSource = dt;
        gvStudents.DataBind();
    }

    private bool TableExists(SqlConnection con, string tableName)
    {
        const string q = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @t";
        using (SqlCommand cmd = new SqlCommand(q, con))
        {
            cmd.Parameters.AddWithValue("@t", tableName);
            object o = cmd.ExecuteScalar();
            if (o == null) return false;
            int c;
            int.TryParse(o.ToString(), out c);
            return c > 0;
        }
    }

    private string GetCourseKeyFromCourseName(string courseName)
    {
        if (string.IsNullOrWhiteSpace(courseName)) return string.Empty;
        char[] separators = new char[] { '–', '-', '—', ' ' };
        string[] parts = courseName.Split(separators, StringSplitOptions.RemoveEmptyEntries);
        return (parts.Length > 0) ? parts[0].Trim() : courseName.Trim();
    }

    private int GetSemesterNumber(string semText)
    {
        if (string.IsNullOrEmpty(semText)) return 0;
        semText = semText.ToLower();
        semText = semText.Replace("semester", "");
        semText = semText.Replace("sem", "");
        semText = semText.Replace(":", "");
        semText = semText.Trim();
        int n;
        return int.TryParse(semText, out n) ? n : 0;
    }

    private string GetDropdownEffectiveValue(DropDownList ddl)
    {
        if (ddl == null) return string.Empty;
        string val = (ddl.SelectedValue ?? string.Empty).Trim();
        if (!string.IsNullOrEmpty(val) &&
            val != "-- Select Course --" &&
            val != "-- Select Stream --" &&
            val != "-- Select Sem --" &&
            val != "-- Select Division --" &&
            val != "-- Select Subject --")
            return val;

        if (ddl.SelectedItem != null)
            return ddl.SelectedItem.Text.Trim();

        return string.Empty;
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        if (ddlStream.Items.Count > 0) ddlStream.SelectedIndex = 0;

        ddlCourse.Items.Clear();
        ddlCourse.Items.Add(new ListItem("-- Select Course --", ""));

        if (ddlSem.Items.Count > 0) ddlSem.SelectedIndex = 0;
        if (ddlDivision.Items.Count > 0) ddlDivision.SelectedIndex = 0;

        ddlSubject.Items.Clear();
        ddlSubject.Items.Add(new ListItem("-- Select Subject --", ""));

        gvStudents.DataSource = null;
        gvStudents.DataBind();

        lblInfo.Text = "";
    }
}
