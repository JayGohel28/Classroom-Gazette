using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;

public partial class Registration_Form : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (ddlUserType != null && ddlUserType.Items.Count > 0) ddlUserType.SelectedIndex = 0;
            if (ddlStream != null && ddlStream.Items.Count > 0) ddlStream.SelectedIndex = 0;

            
        }
    }

    private static Dictionary<string, string[]> GetStreamMap()
    {
        var map = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        map.Add("Computer & IT Streams", new string[]
        {
            "BCA",
            "MCA",
            "B.Sc IT",
            "B.Sc",
            "M.Sc",
            "Artificial Intelligence",
            "Data Science",
            "Cyber Security",
            "Cloud Computing",
            "Software Engineering"
        });

        map.Add("Engineering & Technology Streams", new string[]
        {
            "B.Tech",
            "Diploma",
            "M.Tech"
        });

        map.Add("Management & Commerce Streams", new string[]
        {
            "BBA",
            "MBA",
            "B.Com",
            "B.Com",
            "M.Com",
            "Banking & Insurance",
            "Digital Marketing",
            "Retail Management",
            "Logistics & Supply Chain",
            "Entrepreneurship & Family Business"
        });

        map.Add("Science Streams", new string[]
        {
            "B.Sc",
            "M.Sc"
        });

        map.Add("Arts & Humanities Streams", new string[]
        {
            "BA",
            "MA",
            "Journalism & Mass Communication",
            "Liberal Arts"
        });

        map.Add("Medical & Health Streams", new string[]
        {
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
        });

        map.Add("Law & Education", new string[]
        {
            "LLB",
            "LLM",
            "BBA LLBIntegrated",
            "BA LLBIntegrated",
            "B.Ed",
            "M.Ed",
            "D.El.Ed"
        });

        map.Add("Design, Media & Creative Fields", new string[]
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
        });

        map.Add("Polytechnic & Skill-Based Streams", new string[]
        {
            "ITIElectrician",
            "ITIFitter",
            "ITIWelder",
            "DiplomaAutomobile Engineering",
            "DiplomaElectronics",
            "Hardware & Networking",
            "Mobile Repairing",
            "CNC Machine Operation"
        });

        map.Add("School Level Streams", new string[]
        {
            "9th Standard",
            "10th Standard",
            "11th Science",
            "11th Commerce",
            "11th Arts",
            "12th Science",
            "12th Commerce",
            "12th Arts"
        });

        return map;
    }

    [WebMethod]
    public static string[] GetCourses(string stream)
    {
        if (stream == null || stream.Trim() == "")
            return new string[0];

        Dictionary<string, string[]> map = GetStreamMap();

        string[] courses;
        if (map.TryGetValue(stream.Trim(), out courses))
            return courses;

        return new string[0];
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        string userType = ddlUserType != null ? ddlUserType.SelectedValue : "";
        string fn = txtFirstName != null ? txtFirstName.Text : "";
        string ln = txtLastName != null ? txtLastName.Text : "";
        string dob = txtDateOfBirth != null ? txtDateOfBirth.Text : "";
        string mobile = txtMobileNumber != null ? txtMobileNumber.Text : "";
        string email = txtEmailAddress != null ? txtEmailAddress.Text : "";
        string uname = txtUsername != null ? txtUsername.Text : "";
        string pass = txtPassword != null ? txtPassword.Text : "";
        string enroll = txtEnrollmentNumber != null ? txtEnrollmentNumber.Text : "";
        string stream = ddlStream != null ? ddlStream.SelectedValue : "";
        string course = hdnCourse != null ? hdnCourse.Value : "";
        string division = txtDivision != null ? txtDivision.Text : "";
        string semester = ddlSemester != null ? ddlSemester.SelectedValue : "";
        string dept = ddlDepartment != null ? ddlDepartment.SelectedValue : "";

        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // ===== ONLY NEW CHANGE: Username duplicate check =====
                bool usernameExists = false;

                if (!string.IsNullOrWhiteSpace(uname))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(1) FROM Students_tbl WHERE Username = @Uname", con))
                    {
                        cmd.Parameters.AddWithValue("@Uname", uname.Trim());
                        if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                            usernameExists = true;
                    }

                    if (!usernameExists)
                    {
                        using (SqlCommand cmd = new SqlCommand(
                            "SELECT COUNT(1) FROM Faculty_tbl WHERE Username = @Uname", con))
                        {
                            cmd.Parameters.AddWithValue("@Uname", uname.Trim());
                            if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                                usernameExists = true;
                        }
                    }
                }

                if (usernameExists)
                {
                    Response.Write("<script>alert('Username already exists. Please choose another username.');</script>");
                    return;
                }
                // ===== END OF CHANGE =====

                // ---------- EXISTING CODE BELOW (UNCHANGED) ----------

                bool emailExists = false;
                bool mobileExists = false;
                bool enrollmentExists = false;

                if (!string.IsNullOrWhiteSpace(email))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Students_tbl WHERE Email = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email.Trim());
                        if (Convert.ToInt32(cmd.ExecuteScalar()) > 0) emailExists = true;
                    }
                    if (!emailExists)
                    {
                        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Faculty_tbl WHERE Email = @Email", con))
                        {
                            cmd.Parameters.AddWithValue("@Email", email.Trim());
                            if (Convert.ToInt32(cmd.ExecuteScalar()) > 0) emailExists = true;
                        }
                    }
                }

                if (!string.IsNullOrWhiteSpace(mobile))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Students_tbl WHERE Mobile = @Mobile", con))
                    {
                        cmd.Parameters.AddWithValue("@Mobile", mobile.Trim());
                        if (Convert.ToInt32(cmd.ExecuteScalar()) > 0) mobileExists = true;
                    }
                    if (!mobileExists)
                    {
                        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Faculty_tbl WHERE Mobile = @Mobile", con))
                        {
                            cmd.Parameters.AddWithValue("@Mobile", mobile.Trim());
                            if (Convert.ToInt32(cmd.ExecuteScalar()) > 0) mobileExists = true;
                        }
                    }
                }

                if (!string.IsNullOrWhiteSpace(enroll) && !string.Equals(userType, "Faculty", StringComparison.OrdinalIgnoreCase))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Students_tbl WHERE EnrollmentNumber = @Enroll", con))
                    {
                        cmd.Parameters.AddWithValue("@Enroll", enroll.Trim());
                        if (Convert.ToInt32(cmd.ExecuteScalar()) > 0) enrollmentExists = true;
                    }
                }

                if (emailExists || mobileExists || enrollmentExists)
                {
                    string msg = "";
                    if (enrollmentExists) msg += "Enrollment number already exists. ";
                    if (emailExists) msg += "Email address already exists. ";
                    if (mobileExists) msg += "Mobile number already exists.";
                    Response.Write("<script>alert('" + HttpUtility.JavaScriptStringEncode(msg.Trim()) + "');</script>");
                    return;
                }

                if (string.Equals(userType, "Faculty", StringComparison.OrdinalIgnoreCase))
                {
                    string q = @"INSERT INTO Faculty_tbl (UserType, FirstName, LastName, DOB, Department, Mobile, Email, Username, Password)
                                 VALUES (@UserType, @FN, @LN, @DOB, @Dept, @Mobile, @Email, @Uname, @Pass)";
                    using (SqlCommand cmd = new SqlCommand(q, con))
                    {
                        cmd.Parameters.AddWithValue("@UserType", userType);
                        cmd.Parameters.AddWithValue("@FN", fn);
                        cmd.Parameters.AddWithValue("@LN", ln);
                        cmd.Parameters.AddWithValue("@DOB", string.IsNullOrWhiteSpace(dob) ? (object)DBNull.Value : dob);
                        cmd.Parameters.AddWithValue("@Dept", string.IsNullOrWhiteSpace(dept) ? (object)DBNull.Value : dept);
                        cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrWhiteSpace(mobile) ? (object)DBNull.Value : mobile);
                        cmd.Parameters.AddWithValue("@Email", string.IsNullOrWhiteSpace(email) ? (object)DBNull.Value : email);
                        cmd.Parameters.AddWithValue("@Uname", uname);
                        cmd.Parameters.AddWithValue("@Pass", pass ?? "");
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    string q = @"INSERT INTO Students_tbl (UserType, FirstName, LastName, DOB, EnrollmentNumber, Stream, Course, Division, Semester, Mobile, Email, Username, Password)
                                 VALUES (@UserType, @FN, @LN, @DOB, @Enroll, @Stream, @Course, @Division, @Sem, @Mobile, @Email, @Uname, @Pass)";
                    using (SqlCommand cmd = new SqlCommand(q, con))
                    {
                        cmd.Parameters.AddWithValue("@UserType", userType);
                        cmd.Parameters.AddWithValue("@FN", fn);
                        cmd.Parameters.AddWithValue("@LN", ln);
                        cmd.Parameters.AddWithValue("@DOB", string.IsNullOrWhiteSpace(dob) ? (object)DBNull.Value : dob);
                        cmd.Parameters.AddWithValue("@Enroll", string.IsNullOrWhiteSpace(enroll) ? (object)DBNull.Value : enroll);
                        cmd.Parameters.AddWithValue("@Stream", string.IsNullOrWhiteSpace(stream) ? (object)DBNull.Value : stream);
                        cmd.Parameters.AddWithValue("@Course", string.IsNullOrWhiteSpace(course) ? (object)DBNull.Value : course);
                        cmd.Parameters.AddWithValue("@Division", string.IsNullOrWhiteSpace(division) ? (object)DBNull.Value : division);
                        int semInt = 0;
                        int.TryParse(semester, out semInt);
                        cmd.Parameters.AddWithValue("@Sem", semInt);
                        cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrWhiteSpace(mobile) ? (object)DBNull.Value : mobile);
                        cmd.Parameters.AddWithValue("@Email", string.IsNullOrWhiteSpace(email) ? (object)DBNull.Value : email);
                        cmd.Parameters.AddWithValue("@Uname", uname);
                        cmd.Parameters.AddWithValue("@Pass", pass ?? "");
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            Response.Write("<script>alert('Saved successfully.');</script>");
            ClearForm();
        }
        catch (Exception ex)
        {
            Response.Write("<script>alert('Error: " + HttpUtility.JavaScriptStringEncode(ex.Message) + "');</script>");
        }
    }

    private void ClearForm()
    {
        try
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtDateOfBirth.Text = "";
            txtMobileNumber.Text = "";
            txtEmailAddress.Text = "";
            txtUsername.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            txtEnrollmentNumber.Text = "";
            if (ddlStream != null && ddlStream.Items.Count > 0) ddlStream.SelectedIndex = 0;
            if (hdnCourse != null) hdnCourse.Value = "";
            txtDivision.Text = "";
            if (ddlSemester != null && ddlSemester.Items.Count > 0) ddlSemester.SelectedIndex = 0;
            if (ddlDepartment != null && ddlDepartment.Items.Count > 0) ddlDepartment.SelectedIndex = 0;
        }
        catch { }
    }
}
