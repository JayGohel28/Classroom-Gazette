using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class CreateTimetableForm_Faculty : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CGConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

            ddlCourse.Items.Clear();
            ddlCourse.Items.Add(new ListItem("-- Select Course --", ""));

            ddlRoom.Items.Clear();
            ddlRoom.Items.Add(new ListItem("-- Select Classroom / Lab --", ""));

            BindGrid();
        }
    }

    /* ---------------- DROPDOWNS ---------------- */

    protected void ddlStream_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlCourse.Items.Clear();
        ddlCourse.Items.Add(new ListItem("-- Select Course --", ""));

        string stream = ddlStream.SelectedValue;
        if (!string.IsNullOrEmpty(stream))
        {
            foreach (string course in GetCoursesForStream(stream))
            {
                ddlCourse.Items.Add(new ListItem(course, course));
            }
        }

        BindGrid();
    }

    protected void ddlCourse_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }

    protected void ddlBuilding_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlRoom.Items.Clear();
        ddlRoom.Items.Add(new ListItem("-- Select Classroom / Lab --", ""));

        string building = ddlBuilding.SelectedValue;
        if (!string.IsNullOrEmpty(building))
        {
            foreach (string room in GetRoomsForBuilding(building))
            {
                ddlRoom.Items.Add(new ListItem(room, room));
            }
        }
    }

    /* ---------------- BIND GRID ---------------- */

    private void BindGrid()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"SELECT Id, LectureDate, StreamName, CourseName, SubjectName,
                                    FacultyName, BuildingName, RoomNo, SemesterTerm,
                                    StartTime, EndTime
                             FROM StudentTimetable_tbl";

            bool filterByCourse = !string.IsNullOrEmpty(ddlCourse.SelectedValue);
            if (filterByCourse)
            {
                query += " WHERE CourseName = @CourseName";
            }

            query += " ORDER BY LectureDate, StartTime";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (filterByCourse)
                {
                    cmd.Parameters.AddWithValue("@CourseName", ddlCourse.SelectedValue);
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvTimetable.DataSource = dt;
                    gvTimetable.DataBind();
                }
            }
        }

        if (!string.IsNullOrEmpty(ddlCourse.SelectedValue))
        {
            lblGridHeading.Text = ddlCourse.SelectedItem.Text + " Timetable";
        }
        else
        {
            lblGridHeading.Text = "All Timetables";
        }
    }

    /* ---------------- CLASH CHECK ---------------- */

    private bool IsSlotOccupied(DateTime lectureDate, string building, string room,
                                TimeSpan startTime, TimeSpan endTime, int? excludeId = null)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT COUNT(*) 
                FROM StudentTimetable_tbl
                WHERE LectureDate = @LectureDate
                  AND BuildingName = @BuildingName
                  AND RoomNo = @RoomNo
                  AND NOT (@EndTime <= StartTime OR @StartTime >= EndTime)";

            if (excludeId.HasValue)
            {
                query += " AND Id <> @Id";
            }

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@LectureDate", lectureDate);
                cmd.Parameters.AddWithValue("@BuildingName", building);
                cmd.Parameters.AddWithValue("@RoomNo", room);

                var pStart = cmd.Parameters.Add("@StartTime", SqlDbType.Time);
                pStart.Value = startTime;

                var pEnd = cmd.Parameters.Add("@EndTime", SqlDbType.Time);
                pEnd.Value = endTime;

                if (excludeId.HasValue)
                    cmd.Parameters.AddWithValue("@Id", excludeId.Value);

                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
    }

    /* ---------------- CREATE (INSERT) ---------------- */

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";

        if (!Page.IsValid)
            return;

        DateTime lectureDate = DateTime.Parse(txtDate.Text);
        string building = ddlBuilding.SelectedValue;
        string room = ddlRoom.SelectedValue;
        TimeSpan startTime = TimeSpan.Parse(txtStartTime.Text);
        TimeSpan endTime = TimeSpan.Parse(txtEndTime.Text);

        if (IsSlotOccupied(lectureDate, building, room, startTime, endTime))
        {
            lblMessage.Text = "❌ This classroom is already booked for the selected time.";
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string insertQuery = @"
                    INSERT INTO StudentTimetable_tbl
                    (
                        LectureDate,
                        StreamName,
                        CourseName,
                        SubjectName,
                        FacultyName,
                        BuildingName,
                        RoomNo,
                        SemesterTerm,
                        StartTime,
                        EndTime
                    )
                    VALUES
                    (
                        @LectureDate,
                        @StreamName,
                        @CourseName,
                        @SubjectName,
                        @FacultyName,
                        @BuildingName,
                        @RoomNo,
                        @SemesterTerm,
                        @StartTime,
                        @EndTime
                    );";

                using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                {
                    cmd.Parameters.AddWithValue("@LectureDate", lectureDate);
                    cmd.Parameters.AddWithValue("@StreamName", ddlStream.SelectedValue);
                    cmd.Parameters.AddWithValue("@CourseName", ddlCourse.SelectedValue);
                    cmd.Parameters.AddWithValue("@SubjectName", txtSubject.Text.Trim());
                    cmd.Parameters.AddWithValue("@FacultyName", txtFaculty.Text.Trim());
                    cmd.Parameters.AddWithValue("@BuildingName", building);
                    cmd.Parameters.AddWithValue("@RoomNo", room);
                    cmd.Parameters.AddWithValue("@SemesterTerm", ddlSem.SelectedValue);
                    cmd.Parameters.AddWithValue("@StartTime", startTime);
                    cmd.Parameters.AddWithValue("@EndTime", endTime);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "✅ Timetable created successfully.";
            ClearForm();
            BindGrid();
        }
        catch (Exception)
        {
            lblMessage.Text = "❌ Error while saving timetable.";
        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        ClearForm();
        BindGrid();
    }

    private void ClearForm()
    {
        txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

        ddlStream.SelectedIndex = 0;

        ddlCourse.Items.Clear();
        ddlCourse.Items.Add(new ListItem("-- Select Course --", ""));

        txtSubject.Text = string.Empty;
        txtFaculty.Text = string.Empty;

        ddlBuilding.SelectedIndex = 0;

        ddlRoom.Items.Clear();
        ddlRoom.Items.Add(new ListItem("-- Select Classroom / Lab --", ""));

        ddlSem.SelectedIndex = 0;

        txtStartTime.Text = string.Empty;
        txtEndTime.Text = string.Empty;
    }

    /* ---------------- GRIDVIEW EVENTS ---------------- */

    protected void gvTimetable_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvTimetable.EditIndex = e.NewEditIndex;
        BindGrid();
    }

    protected void gvTimetable_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvTimetable.EditIndex = -1;
        BindGrid();
    }

    protected void gvTimetable_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        lblMessage.Text = "";

        int id = Convert.ToInt32(gvTimetable.DataKeys[e.RowIndex].Value);
        GridViewRow row = gvTimetable.Rows[e.RowIndex];

        DateTime lectureDate = DateTime.Parse(((TextBox)row.Cells[1].Controls[0]).Text);
        string stream = ((TextBox)row.Cells[2].Controls[0]).Text;
        string course = ((TextBox)row.Cells[3].Controls[0]).Text;
        string subject = ((TextBox)row.Cells[4].Controls[0]).Text;
        string faculty = ((TextBox)row.Cells[5].Controls[0]).Text;
        string building = ((TextBox)row.Cells[6].Controls[0]).Text;
        string room = ((TextBox)row.Cells[7].Controls[0]).Text;
        string sem = ((TextBox)row.Cells[8].Controls[0]).Text;
        TimeSpan startTime = TimeSpan.Parse(((TextBox)row.Cells[9].Controls[0]).Text);
        TimeSpan endTime = TimeSpan.Parse(((TextBox)row.Cells[10].Controls[0]).Text);

        if (IsSlotOccupied(lectureDate, building, room, startTime, endTime, id))
        {
            lblMessage.Text = "❌ Cannot update: this classroom is already booked for that time.";
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string updateQuery = @"
                    UPDATE StudentTimetable_tbl
                    SET LectureDate = @LectureDate,
                        StreamName = @StreamName,
                        CourseName = @CourseName,
                        SubjectName = @SubjectName,
                        FacultyName = @FacultyName,
                        BuildingName = @BuildingName,
                        RoomNo = @RoomNo,
                        SemesterTerm = @SemesterTerm,
                        StartTime = @StartTime,
                        EndTime = @EndTime
                    WHERE Id = @Id";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue("@LectureDate", lectureDate);
                    cmd.Parameters.AddWithValue("@StreamName", stream);
                    cmd.Parameters.AddWithValue("@CourseName", course);
                    cmd.Parameters.AddWithValue("@SubjectName", subject);
                    cmd.Parameters.AddWithValue("@FacultyName", faculty);
                    cmd.Parameters.AddWithValue("@BuildingName", building);
                    cmd.Parameters.AddWithValue("@RoomNo", room);
                    cmd.Parameters.AddWithValue("@SemesterTerm", sem);
                    cmd.Parameters.AddWithValue("@StartTime", startTime);
                    cmd.Parameters.AddWithValue("@EndTime", endTime);
                    cmd.Parameters.AddWithValue("@Id", id);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvTimetable.EditIndex = -1;
            BindGrid();
            lblMessage.Text = "✅ Timetable updated successfully.";
        }
        catch (Exception)
        {
            lblMessage.Text = "❌ Error while updating timetable.";
        }
    }

    protected void gvTimetable_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        lblMessage.Text = "";

        int id = Convert.ToInt32(gvTimetable.DataKeys[e.RowIndex].Value);

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string deleteQuery = "DELETE FROM StudentTimetable_tbl WHERE Id = @Id";

                using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            BindGrid();
            lblMessage.Text = "✅ Timetable deleted. Slot is now free for booking.";
        }
        catch (Exception)
        {
            lblMessage.Text = "❌ Error while deleting timetable.";
        }
    }

    /* ---------- MAPPING HELPERS ---------- */

    private List<string> GetCoursesForStream(string stream)
    {
        switch (stream)
        {
            case "Computer & IT Streams":
                return new List<string>
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
                };

            case "Engineering & Technology Streams":
                return new List<string>
                {
                    "B.Tech",
                    "Diploma",
                    "M.Tech"
                };

            case "Management & Commerce Streams":
                return new List<string>
                {
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
                return new List<string>
                {
                    "B.Sc",
                    "M.Sc"
                };

            case "Arts & Humanities Streams":
                return new List<string>
                {
                    "BA",
                    "MA",
                    "Journalism & Mass Communication",
                    "Liberal Arts"
                };

            case "Medical & Health Streams":
                return new List<string>
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
                };

            case "Law & Education":
                return new List<string>
                {
                    "LLB",
                    "LLM",
                    "BBA LLBIntegrated",
                    "BA LLBIntegrated",
                    "B.Ed",
                    "M.Ed",
                    "D.El.Ed"
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

    private List<string> GetRoomsForBuilding(string building)
    {
        switch (building)
        {
            case "MCA Building":
                return new List<string>
                {
                    "CR-101", "CR-102", "CR-103", "CR-104", "CR-201",
                    "CR-202", "CR-203", "CR-301", "CR-401", "CR-501",
                    "LAB-101", "LAB-204", "LAB-305", "LAB-502", "LAB-908"
                };

            case "MBA Building":
                return new List<string>
                {
                    "CR-1", "CR-2", "CR-3", "CR-4", "CR-5",
                    "CR-201", "CR-202", "CR-203", "CR-301", "CR-401",
                    "LAB-11", "LAB-22", "LAB-33", "LAB-44", "LAB-55"
                };

            case "BCA Building":
                return new List<string>
                {
                    "CR-101", "CR-102", "CR-103", "CR-104", "CR-105",
                    "CR-201", "CR-202", "CR-301", "CR-302", "CR-401",
                    "LAB-1", "LAB-2", "LAB-3", "LAB-4", "LAB-5"
                };

            case "B.Tech Building":
                return new List<string>
                {
                    "CR-100", "CR-101", "CR-102", "CR-201", "CR-202",
                    "CR-203", "CR-301", "CR-302", "CR-401", "CR-501",
                    "LAB-Mechanical", "LAB-Electrical", "LAB-CS", "LAB-Civil", "LAB-Physics"
                };

            case "Polytechnic Building":
                return new List<string>
                {
                    "CR-A1", "CR-A2", "CR-A3", "CR-B1", "CR-B2",
                    "CR-B3", "CR-C1", "CR-C2", "CR-C3", "CR-D1",
                    "LAB-Welding", "LAB-AutoCAD", "LAB-Electronics", "LAB-Workshop", "LAB-Testing"
                };

            case "Science Block":
                return new List<string>
                {
                    "CR-S1", "CR-S2", "CR-S3", "CR-S4", "CR-S5",
                    "CR-S6", "CR-S7", "CR-S8", "CR-S9", "CR-S10",
                    "LAB-Physics", "LAB-Chemistry", "LAB-Biology", "LAB-Microbiology", "LAB-Research"
                };

            case "Commerce Block":
                return new List<string>
                {
                    "CR-C1", "CR-C2", "CR-C3", "CR-C4", "CR-C5",
                    "CR-C6", "CR-C7", "CR-C8", "CR-C9", "CR-C10",
                    "LAB-Accounts", "LAB-Statistics", "LAB-Excel", "LAB-Tally", "LAB-Finance"
                };

            case "Arts Block":
                return new List<string>
                {
                    "CR-A1", "CR-A2", "CR-A3", "CR-A4", "CR-A5",
                    "CR-A6", "CR-A7", "CR-A8", "CR-A9", "CR-A10",
                    "LAB-Music", "LAB-Drawing", "LAB-Dance", "LAB-Theatre", "LAB-Language"
                };

            case "Auditorium Block":
                return new List<string>
                {
                    "CR-Guest1", "CR-Guest2", "CR-Meeting1", "CR-Meeting2",
                    "CR-Training1", "CR-Training2", "CR-Training3",
                    "CR-VIP1", "CR-VIP2", "CR-Conference",
                    "LAB-Sound", "LAB-Light", "LAB-Recording", "LAB-Editing", "LAB-Control"
                };

            case "Research & Lab Complex":
                return new List<string>
                {
                    "CR-R1", "CR-R2", "CR-R3", "CR-R4", "CR-R5",
                    "CR-R6", "CR-R7", "CR-R8", "CR-R9", "CR-R10",
                    "LAB-AI", "LAB-DataScience", "LAB-Cyber", "LAB-Robotics", "LAB-IoT"
                };

            default:
                return new List<string>();
        }
    }
}
