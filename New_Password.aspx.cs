using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

public partial class New_Password : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;
    }

    protected void btnChange_Click(object sender, EventArgs e)
    {

        string email = txtEmail.Text.Trim();
        string newPassword = txtPassword.Text.Trim();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // Update in Faculty table (no validation, no counting)
            string updateFaculty = @"UPDATE Faculty_tbl SET Password = @Pass WHERE Email = @Email";
            SqlCommand cmdFaculty = new SqlCommand(updateFaculty, con);
            cmdFaculty.Parameters.AddWithValue("@Pass", newPassword);
            cmdFaculty.Parameters.AddWithValue("@Email", email);
            int facultyUpdated = cmdFaculty.ExecuteNonQuery();


            // Update in Students table (no validation)
            string updateStudent = @"UPDATE Students_tbl SET Password = @Pass WHERE Email = @Email";
            SqlCommand cmdStudent = new SqlCommand(updateStudent, con);
            cmdStudent.Parameters.AddWithValue("@Pass", newPassword);
            cmdStudent.Parameters.AddWithValue("@Email", email);
            int studentUpdated = cmdStudent.ExecuteNonQuery();


            // If at least one table updated → success
            if (facultyUpdated > 0 || studentUpdated > 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "success",
                    "alert('Password updated successfully!'); window.location='Login.aspx';", true);
                return;
            }

            // If nothing updated (optional)
            ValidationSummary1.HeaderText = "Password updated, if the email was found.";
        }
    }
}
