using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;

public partial class Login : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ClearForm();
        }
    }

    protected void btnLogin_Click1(object sender, EventArgs e)
    {
        string userType = ddlUserType.SelectedValue;
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            Response.Write("<script>alert('Please enter username and password.');</script>");
            return;
        }

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // ---------------- ADMIN LOGIN ----------------
            if (userType == "Admin")
            {
                string query = "SELECT Username FROM Admin_tbl WHERE Username=@Uname AND Password=@Pass";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Uname", username);
                    cmd.Parameters.AddWithValue("@Pass", password);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            Session["UserType"] = "Admin";
                            Session["Username"] = dr["Username"].ToString();
                            Response.Redirect("AdminMainForm.aspx");
                        }
                        else
                        {
                            Response.Write("<script>alert('Invalid Admin Login');</script>");
                        }
                    }
                }
                return;
            }

            // ---------------- FACULTY LOGIN ----------------
            if (userType == "Faculty")
            {
                string query = "SELECT Username FROM Faculty_tbl WHERE Username=@Uname AND Password=@Pass";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Uname", username);
                    cmd.Parameters.AddWithValue("@Pass", password);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            Session["UserType"] = "Faculty";
                            Session["Username"] = dr["Username"].ToString();
                            Response.Redirect("FacultyMainForm.aspx");
                        }
                        else
                        {
                            Response.Write("<script>alert('Invalid Faculty Login');</script>");
                        }
                    }
                }
                return;
            }

            // ---------------- STUDENT LOGIN ----------------
            if (userType == "Student")
            {
                string query = @"
                    SELECT StudentId, Username, Course, Semester, Division, EnrollmentNumber
                    FROM Students_tbl
                    WHERE Username = @Uname AND Password = @Pass";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Uname", username);
                    cmd.Parameters.AddWithValue("@Pass", password);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            Session["UserType"] = "Student";
                            Session["Username"] = dr["Username"].ToString();
                            Session["StudentId"] = Convert.ToInt32(dr["StudentId"]);

                            Session["StudentCourse"] = dr["Course"].ToString();
                            Session["StudentSemester"] = dr["Semester"].ToString();
                            Session["StudentDivision"] = dr["Division"].ToString();
                            Session["EnrollmentNumber"] = dr["EnrollmentNumber"].ToString();

                            Response.Redirect("StudentMainForm.aspx");
                        }
                        else
                        {
                            Response.Write("<script>alert('Invalid Student Login');</script>");
                        }
                    }
                }
                return;
            }

            // ---------------- INVALID USER TYPE ----------------
            Response.Write("<script>alert('Please select a valid user type.');</script>");
        }
    }

    private void ClearForm()
    {
        txtUsername.Text = "";
        txtPassword.Text = "";
        ddlUserType.SelectedIndex = 0;
    }
}
