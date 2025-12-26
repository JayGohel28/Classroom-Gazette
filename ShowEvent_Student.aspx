<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowEvent_Student.aspx.cs" Inherits="ShowEvent_Student" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
  <meta charset="utf-8" />
  <title>Event Notifications</title>

  <style>
    :root{
      --accent: #4fc3f7;
      --accent-glow: rgba(79,195,247,0.32);
      --page-bg: #0a2735;
      --panel-bg: #103445;
      --border: rgba(255,255,255,0.06);
      --text-light: #e9faff;
      --muted: #b6d9e6;
    }

    body{
      margin:0; background:var(--page-bg); font-family:'Segoe UI',sans-serif;
      color:var(--text-light);
    }

    .container{
      max-width:1100px; margin:28px auto; padding:18px;
    }

    .panel{
      background:var(--panel-bg);
      border:1px solid var(--border);
      padding:22px;
      border-radius:12px;
      box-shadow:0 8px 30px rgba(0,0,0,0.45), 0 0 14px var(--accent-glow);
    }

    .panel h2{
      margin:0 0 10px 0; font-size:20px; font-weight:700; color:var(--text-light);
    }

    /* GRIDVIEW */
    .events-grid{
      width:100%; border-collapse:collapse; margin-top:10px;
      background:#0d2c3a;
      border-radius:10px; overflow:hidden;
    }
    .events-grid th{
      background:var(--accent);
      color:#03313f;
      padding:12px; text-align:left;
      font-size:14px; font-weight:700;
    }
    .events-grid td{
      padding:12px;
      color:var(--muted);
      border-bottom:1px solid rgba(255,255,255,0.05);
      font-size:14px;
    }
    .events-grid tr:hover td{ background:#10394a; }

    .link-download {
      color: var(--accent);
      font-weight:700;
      text-decoration:none;
      background: transparent;
      border: none;
      cursor: pointer;
    }
    .link-download:hover { text-decoration: underline; }
  </style>

</head>
<body>
<form id="form1" runat="server">

  <div class="container">
    <div class="panel">
      <h2>Event Notifications</h2>

      <!-- GRIDVIEW -->
      <asp:GridView 
           ID="gvEvents" 
           runat="server" 
           CssClass="events-grid"
           AutoGenerateColumns="False"
           DataKeyNames="Id"
           OnRowCommand="gvEvents_RowCommand"
           OnPageIndexChanging="gvEvents_PageIndexChanging"
           AllowPaging="true"
           PageSize="10">

        <Columns>
          <asp:BoundField HeaderText="Event Name" DataField="EventName" />
          <asp:BoundField HeaderText="Start Date" DataField="StartDate" DataFormatString="{0:dd-MM-yyyy}" />
          <asp:BoundField HeaderText="End Date" DataField="EndDate" DataFormatString="{0:dd-MM-yyyy}" />
          <asp:BoundField HeaderText="Description" DataField="Description" />

          <asp:TemplateField HeaderText="Circular">
            <ItemTemplate>
              <asp:LinkButton ID="lnkDownload" runat="server"
                 CssClass="link-download"
                 CommandName="Download"
                 CommandArgument='<%# Eval("Id") %>'>Download</asp:LinkButton>
            </ItemTemplate>
          </asp:TemplateField>

        </Columns>
      </asp:GridView>

    </div>
  </div>

</form>
</body>
</html>
