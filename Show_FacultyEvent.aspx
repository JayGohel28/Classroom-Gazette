<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Show_FacultyEvent.aspx.cs" Inherits="Show_FacultyEvent" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta charset="utf-8" />
<title>Faculty Events</title>

<style>
    :root {
        --accent: #a770ef;
        --accent2: #66d1ff;
        --dark: #150026;
        --page-bg: #1a0533;
        --panel-bg: #220744;
        --muted-text: #cab6e6;
        --radius: 14px;
    }

    body {
        background: linear-gradient(180deg, var(--page-bg), #12021f);
        font-family: Segoe UI, Roboto, Arial;
        color: var(--muted-text);
        margin: 0;
        padding: 30px;
    }

    .container {
        max-width: 1100px;
        margin: auto;
        background: var(--panel-bg);
        padding: 25px;
        border-radius: var(--radius);
        box-shadow: 0px 0px 25px rgba(0, 0, 0, 0.6);
    }

    h1 {
        color: var(--accent2);
        font-size: 30px;
        margin-bottom: 20px;
        letter-spacing: 1px;
        text-shadow: 0 0 10px rgba(102, 209, 255, 0.4);
    }

    /* Grid Styling */
    .grid-container {
        background: rgba(255, 255, 255, 0.05);
        padding: 15px;
        border-radius: 10px;
    }

    .grid th {
        background: linear-gradient(90deg, var(--accent), var(--accent2));
        color: #12021f;
        padding: 12px;
        font-size: 15px;
    }

    .grid td {
        padding: 12px;
        background: rgba(255, 255, 255, 0.03);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .grid tr:hover td {
        background: rgba(255, 255, 255, 0.08);
    }

    /* Download Button */
    .btn-download {
        background: linear-gradient(90deg, var(--accent2), var(--accent));
        padding: 8px 14px;
        color: #12021f;
        border-radius: 8px;
        text-decoration: none;
        font-weight: bold;
        display: inline-block;
    }

    .btn-download:hover {
        opacity: 0.85;
    }

</style>

</head>

<body>
<form id="form1" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server" />

<div class="container">
    <h1>Faculty Events</h1>

    <div class="grid-container">
        <asp:GridView ID="gvEvents" runat="server" CssClass="grid" AutoGenerateColumns="False"
            OnRowCommand="gvEvents_RowCommand"
            OnPageIndexChanging="gvEvents_PageIndexChanging"
            AllowPaging="true" PageSize="8">

            <Columns>

                <asp:BoundField DataField="Id" HeaderText="ID" />

                <asp:BoundField DataField="EventName" HeaderText="Event Name" />

                <asp:BoundField DataField="StartDate" HeaderText="Start Date" />

                <asp:BoundField DataField="EndDate" HeaderText="End Date" />

                <asp:BoundField DataField="Description" HeaderText="Description" />

                <asp:TemplateField HeaderText="Circular">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkDownload" runat="server"
                            CssClass="btn-download"
                            Text="Download"
                            CommandName="Download"
                            CommandArgument='<%# Eval("Id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>
    </div>

</div>

</form>
</body>
</html>
