<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewStudents_admin.aspx.cs" Inherits="ViewStudents_admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Students & Faculty</title>

    <style>
        body {
            margin: 0;
            background: #111;
            font-family: Arial, sans-serif;
            color: #f1c40f;
        }

        /* Simple yellow buttons */
        .switch-buttons {
            margin: 20px;
            text-align: center;
        }

        .btn-switch {
            background: #000;
            border: 2px solid #f1c40f;
            padding: 12px 25px;
            margin-right: 15px;
            color: #f1c40f;
            cursor: pointer;
            font-size: 16px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .btn-switch:hover {
            background: #f1c40f;
            color: #000;
        }

        /* GridView Style */
        .gridview-style {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            color: #f1c40f;
        }

        .gridview-style th {
            background: #f1c40f;
            color: #000;
            padding: 10px;
            border: 1px solid #f1c40f;
            text-align: center;
        }

        .gridview-style td {
            padding: 10px;
            border: 1px solid #f1c40f;
            text-align: center;
        }

        .update-btn, .delete-btn {
            padding: 6px 12px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            border: none;
        }

        .update-btn {
            background: #27ae60;
            color: white;
        }

        .delete-btn {
            background: #e74c3c;
            color: white;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- SIMPLE BUTTONS (NO ONCLICK) -->
    <div class="switch-buttons">
        <asp:Button ID="btnStudent" runat="server" Text="Students" CssClass="btn-switch" OnClick="btnStudent_Click" />
        <asp:Button ID="btnFaculty" runat="server" Text="Faculty" CssClass="btn-switch" OnClick="btnFaculty_Click" />
    </div>

    <!-- STUDENTS GRIDVIEW -->
    <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="False" CssClass="gridview-style"> 
        <Columns>
            <asp:BoundField DataField="EnrollmentNo" HeaderText="Enrollment No" />
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="Subject" HeaderText="Subject" />

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <button type="button" class="update-btn">Update</button>
                    <button type="button" class="delete-btn">Delete</button>

                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <!-- FACULTY GRIDVIEW -->
    <asp:GridView ID="gvFaculty" runat="server" AutoGenerateColumns="False" CssClass="gridview-style">
        <Columns>
            <asp:BoundField DataField="FacultyID" HeaderText="Faculty ID" />
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="Department" HeaderText="Department" />

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <button type="button" class="update-btn">Update</button>
                    <button type="button" class="delete-btn">Delete</button>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</form>
</body>
</html>
