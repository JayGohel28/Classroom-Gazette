using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;

public partial class Forget_Password : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnSendOtp_Click(object sender, EventArgs e)
    {
        string email = txtEmail.Text.Trim();

        if (email == "")
        {
            lblMsg.Text = "Enter email first.";
            return;
        }

        // Generate 6-digit OTP
        string otp = new Random().Next(100000, 999999).ToString();
        Session["otp"] = otp;

        try
        {
            // Send email
            MailMessage msg = new MailMessage("yourEmail@gmail.com", email);
            msg.Subject = "Your OTP Code";
            msg.Body =
                    "Hello,\n\n" +
                    "We received a request to reset the password for your Classroom Gazette account. " +
                    "To ensure the security of your profile and personal data, we use a One-Time Password (OTP) to verify that this request truly came from you.\n\n" +

                    "=====================================================\n" +
                    "   YOUR ONE-TIME PASSWORD (OTP): " + otp + "\n" +
                    "=====================================================\n\n" +

                    "Please enter this OTP in the password Update form to continue. This code is valid for the next 10 minutes. " +
                    "If the code expires, you will need to request a new OTP.\n\n" +

                    "For your security:\n" +
                    "• Do NOT share this OTP with anyone, even if they claim to be from Classroom Gazette.\n" +
                    "• Our team will NEVER ask for your password or OTP via phone, email, or message.\n" +
                    "• If you did NOT request a password reset, please ignore this email. " +
                    "Your account remains safe and no changes will be made without your verification.\n\n" +

                    "If you continue facing issues or did not initiate this request, you may contact our support team for assistance.\n\n" +

                    "Thank you for being a part of Classroom Gazette.\n" +
                    "Stay organized. Stay informed.\n\n" +
                    "Warm Regards,\n" +
                    "Classroom Gazette Support Team\n" +
                    "---------------------------------------------\n" +
                    "This is an automated email. Please do not reply to this message.";


            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.Credentials = new NetworkCredential("classroomgazette01@gmail.com", "zkdo erab ozjq klls");

            smtp.Send(msg);

            lblMsg.ForeColor = System.Drawing.Color.Green;
            lblMsg.Text = "OTP sent to your email!";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Failed to send email: " + ex.Message;
        }
    }
protected void btnVerify_Click(object sender, System.EventArgs e)
{
     if (Session["otp"] == null)
        {
            lblMsg.Text = "OTP not generated yet.";
            return;
        }

        if (txtOtp.Text.Trim() == Session["otp"].ToString())
        {
            lblMsg.ForeColor = System.Drawing.Color.Green;
            lblMsg.Text = "OTP Verified!";
            Response.Redirect("New_Password.aspx");
        }
        else
        {
            lblMsg.Text = "Incorrect OTP!";
        }
}
protected void txtOtp_TextChanged(object sender, System.EventArgs e)
{

}
}