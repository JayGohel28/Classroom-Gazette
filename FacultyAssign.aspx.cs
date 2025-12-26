using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

public partial class FacultyAssign : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtLastDate.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"); // default due in 7 days
            PopulateCoursesForStream(ddlStream.SelectedValue);
            BindSubmissionsGrid();
        }
    }

    protected void ddlStream_SelectedIndexChanged(object sender, EventArgs e)
    {
        PopulateCoursesForStream(ddlStream.SelectedValue);
    }

    // Populates ddlCourse based on Stream string (use your lists)
    private void PopulateCoursesForStream(string stream)
    {
        ddlCourse.Items.Clear();
        if (string.IsNullOrEmpty(stream))
        {
            ddlCourse.Items.Add("-- Select Course --");
            return;
        }

        List<string> courses = GetCoursesForStream(stream);
        foreach (var c in courses)
            ddlCourse.Items.Add(c);
    }

    private List<string> GetCoursesForStream(string stream)
    {
        switch (stream)
        {
            case "Computer & IT Streams":
                return new List<string>
                {
                    "BCA – Bachelor of Computer Applications",
                    "MCA – Master of Computer Applications",
                    "B.Sc IT – Information Technology",
                    "B.Sc Computer Science",
                    "M.Sc Computer Science",
                    "Artificial Intelligence (AI)",
                    "Data Science",
                    "Cyber Security",
                    "Cloud Computing",
                    "Software Engineering"
                };

            case "Engineering & Technology Streams":
                return new List<string>
                {
                    "B.Tech – Computer Engineering",
                    "B.Tech – Information Technology",
                    "B.Tech – Mechanical Engineering",
                    "B.Tech – Civil Engineering",
                    "B.Tech – Electrical Engineering",
                    "B.Tech – Electronics Engineering",
                    "Diploma – Computer Engineering",
                    "Diploma – Mechanical Engineering",
                    "Diploma – Civil Engineering",
                    "M.Tech – Any Specialization"
                };

            case "Management & Commerce Streams":
                return new List<string>
                {
                    "BBA – Bachelor of Business Administration",
                    "MBA – Master of Business Administration",
                    "B.Com – General",
                    "B.Com – Accounting & Finance",
                    "M.Com – Commerce",
                    "Banking & Insurance",
                    "Digital Marketing",
                    "Retail Management",
                    "Logistics & Supply Chain",
                    "Entrepreneurship & Family Business"
                };

            case "Science Streams":
                return new List<string>
                {
                    "B.Sc – Physics, Chemistry, Maths",
                    "B.Sc – Biotechnology",
                    "B.Sc – Microbiology",
                    "B.Sc – Chemistry",
                    "B.Sc – Physics",
                    "B.Sc – Mathematics",
                    "M.Sc – Physics",
                    "M.Sc – Chemistry",
                    "M.Sc – Mathematics",
                    "B.Sc – Nursing"
                };

            case "Arts & Humanities Streams":
                return new List<string>
                {
                    "BA – English Literature",
                    "BA – Psychology",
                    "BA – Sociology",
                    "BA – History",
                    "BA – Political Science",
                    "BA – Economics",
                    "MA – English",
                    "MA – Psychology",
                    "Journalism & Mass Communication",
                    "Liberal Arts – Interdisciplinary"
                };

            case "Medical & Health Streams":
                return new List<string>
                {
                    "MBBS",
                    "BDS – Dental",
                    "BAMS – Ayurveda",
                    "BHMS – Homeopathy",
                    "B.Sc – Nursing",
                    "Physiotherapy",
                    "Medical Lab Technology",
                    "Radiology",
                    "Pharmacy – B.Pharm",
                    "Pharmacy – D.Pharm"
                };

            case "Law & Education":
                return new List<string>
                {
                    "LLB – Bachelor of Law",
                    "LLM – Master of Law",
                    "BBA LLB – Integrated",
                    "BA LLB – Integrated",
                    "B.Ed – Bachelor of Education",
                    "M.Ed – Master of Education",
                    "D.El.Ed – Diploma in Elementary Education"
                };

            case "Design, Media & Creative Fields":
                return new List<string>
                {
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
                return new List<string>
                {
                    "ITI – Electrician",
                    "ITI – Fitter",
                    "ITI – Welder",
                    "Diploma – Automobile Engineering",
                    "Diploma – Electronics",
                    "Hardware & Networking",
                    "Mobile Repairing",
                    "CNC Machine Operation"
                };

            case "School Level Streams":
                return new List<string>
                {
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        // Basic validation
        if (string.IsNullOrEmpty(ddlStream.SelectedValue) || ddlCourse.SelectedIndex < 0 || string.IsNullOrWhiteSpace(txtSubject.Text))
        {
            valSummary.HeaderText = "Please fill required fields.";
            return;
        }

        string uploadsFolder = Server.MapPath("~/Uploads/FacultyAssignments/");
        if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);

        string fileName = null;
        string filePath = null;
        if (fuAssignment.HasFile)
        {
            fileName = Path.GetFileName(fuAssignment.FileName);
            string unique = DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + Guid.NewGuid().ToString("n").Substring(0, 6);
            string saveName = unique + "_" + fileName;
            filePath = Path.Combine(uploadsFolder, saveName);
            fuAssignment.SaveAs(filePath);
            // store relative path for link
            filePath = ResolveUrl("~/Uploads/FacultyAssignments/" + saveName);
        }

        using (SqlConnection con = new SqlConnection(conStr))
        {
            string insert = @"INSERT INTO FacultyAssign_tbl
                (AssignDate, Stream, Course, Subject, SemesterNo, AssignmentDesc, LastDate, AssignmentType, FacultyName, CreatedOn, FileName, FilePath)
                VALUES (@AssignDate,@Stream,@Course,@Subject,@Sem,@Desc,@LastDate,@Type,@Faculty,@CreatedOn,@FileName,@FilePath)";

            using (SqlCommand cmd = new SqlCommand(insert, con))
            {
                cmd.Parameters.AddWithValue("@AssignDate", DateTime.Parse(txtDate.Text));
                cmd.Parameters.AddWithValue("@Stream", ddlStream.SelectedValue);
                cmd.Parameters.AddWithValue("@Course", ddlCourse.SelectedValue ?? "");
                cmd.Parameters.AddWithValue("@Subject", txtSubject.Text);
                cmd.Parameters.AddWithValue("@Sem", Convert.ToInt32(ddlSem.SelectedValue));
                cmd.Parameters.AddWithValue("@Desc", txtDesc.Text);
                if (!string.IsNullOrWhiteSpace(txtLastDate.Text))
                    cmd.Parameters.AddWithValue("@LastDate", DateTime.Parse(txtLastDate.Text));
                else
                    cmd.Parameters.AddWithValue("@LastDate", DBNull.Value);
                cmd.Parameters.AddWithValue("@Type", ddlAssignType.SelectedValue);
                cmd.Parameters.AddWithValue("@Faculty", txtFacultyName.Text);
                cmd.Parameters.AddWithValue("@CreatedOn", DateTime.Now);
                cmd.Parameters.AddWithValue("@FileName", (object)fileName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@FilePath", (object)filePath ?? DBNull.Value);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // clear & rebind
        txtSubject.Text = txtDesc.Text = string.Empty;
        fuAssignment.Dispose();
        BindSubmissionsGrid();
    }

    // Binds student submissions: join StudentAssign_tbl to FacultyAssign_tbl by subject+course (simple approach)
    private void BindSubmissionsGrid()
    {
        DataTable dt = new DataTable();
        using (SqlConnection con = new SqlConnection(conStr))
        {
            // get submissions for the selected course/subject (if any). If none selected, show recent submissions.
            string qry = @"
                SELECT s.StudentName, s.EnrollmentNo, s.SemesterNo, s.FileName, s.FilePath, s.AssignDate,
                       f.LastDate
                FROM StudentAssign_tbl s
                LEFT JOIN FacultyAssign_tbl f
                    ON s.Subject = f.Subject AND s.Course = f.Course
                ORDER BY s.AssignDate DESC";

            using (SqlCommand cmd = new SqlCommand(qry, con))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
        }

        // Add StatusText & StatusClass columns for visual
        dt.Columns.Add("StatusText", typeof(string));
        dt.Columns.Add("StatusClass", typeof(string));

        foreach (DataRow r in dt.Rows)
        {
            DateTime subDate = r["AssignDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(r["AssignDate"]);
            DateTime lastDate = r["LastDate"] == DBNull.Value ? DateTime.MaxValue : Convert.ToDateTime(r["LastDate"]);

            if (subDate > lastDate)
            {
                r["StatusText"] = "Late";
                r["StatusClass"] = "late";
            }
            else
            {
                r["StatusText"] = "On Time";
                r["StatusClass"] = "";
            }
        }

        gvSubmissions.DataSource = dt;
        gvSubmissions.DataBind();
    }
}
