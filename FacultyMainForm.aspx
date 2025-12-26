<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FacultyMainForm.aspx.cs" Inherits="FacultyMainForm" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
  <meta charset="utf-8" />
  <title>Faculty — Classroom Gazette</title>

  <style>
    :root{
      --accent: #a770ef;              /* Purple */
      --accent2: #66d1ff;             /* Neon Blue */
      --dark: #150026;                /* Dark Purple */
      --page-bg: #1a0533;
      --panel-bg: #220744;
      --muted-text: #cab6e6;
      --tab-bg: #2a0a55;
      --tab-active-bg: #3c0f76;
      font-family: "Segoe UI", Roboto, Arial, sans-serif;
    }

    html, body { height:100%; margin:0; background:var(--page-bg); color:var(--accent); }

    /* HEADER */
    .header{
      display:flex; align-items:center; padding:12px 18px;
      background:linear-gradient(135deg, #3f0071, #0e0038);
      color:var(--accent2); border-bottom:1px solid rgba(255,255,255,0.08);
      box-shadow:0 6px 20px rgba(0,0,0,0.7);
    }

    .logo {
      width:56px; height:56px; border-radius:12px;
      background:linear-gradient(135deg, var(--accent), var(--accent2));
      display:flex; justify-content:center; align-items:center;
      color:#fff; font-weight:800; font-size:20px; margin-right:12px;
      box-shadow:0 0 14px rgba(164,112,239,0.45);
    }

    .title { font-size:20px; font-weight:700; color:#eaddff; }
    .subtitle { font-size:12px; color:#d3baff; }

    /* RIGHT SIDE */
    .header-right{ margin-left:auto; display:flex; align-items:center; gap:10px; }
    .user{ text-align:right; font-size:13px; color:var(--muted-text); }

    /* TOGGLE BUTTON */
    .toggle-btn{
      width:44px; height:40px; border-radius:10px;
      background:var(--tab-bg); border:1px solid rgba(255,255,255,0.06);
      cursor:pointer; color:var(--accent2); font-size:18px;
      display:flex; justify-content:center; align-items:center;
    }
    .toggle-btn:hover { background:var(--tab-active-bg); }

    /* LOGOUT */
    .btn-accent{
      background:linear-gradient(135deg,var(--accent),var(--accent2));
      padding:8px 12px; border:none; border-radius:8px;
      color:#fff; font-weight:700; cursor:pointer;
      box-shadow:0 0 12px rgba(166,112,239,0.4);
    }

    /* TABS */
    .tabs-row{
      background:var(--page-bg); padding:14px 18px;
      border-bottom:1px solid rgba(255,255,255,0.04);
      display:flex; gap:12px;
    }

    .tabs{ display:flex; gap:10px; flex-wrap:wrap; }

    .tab{
      padding:9px 16px; border-radius:30px;
      background:var(--tab-bg); color:#c7b0f2; cursor:pointer;
      font-size:14px; font-weight:600;
      border:1px solid rgba(255,255,255,0.05);
      transition:all .12s ease-in-out;
    }
    .tab:hover{
      transform:translateY(-2px);
      box-shadow:0 0 14px rgba(102,209,255,0.3);
    }
    .tab.active{
      background:var(--tab-active-bg); color:#fff;
      box-shadow:0 0 20px rgba(164,112,239,0.45);
      border-color:var(--accent);
    }

    /* CONTENT */
    .content{ padding:14px 18px; height: calc(100vh - 140px); }
    .iframe-box{
      height:100%; background:var(--panel-bg);
      border:1px solid rgba(255,255,255,0.05);
      border-radius:12px; overflow:hidden;
      box-shadow:0 0 20px rgba(0,0,0,0.5);
    }

    iframe#pageFrame{ width:100%; height:100%; border:0; background:#fff; }

    .tabs-row.hidden{ display:none; }
    .content.full{ height: calc(100vh - 56px); }

    /* LOADER */
    .loader{
      position:absolute; top:10px; right:10px;
      background:rgba(0,0,0,0.6); color:white;
      padding:6px 10px; border-radius:6px; display:none;
    }
    .loader.visible{ display:flex; }

  </style>
</head>

<body>
<form id="form1" runat="server">

  <!-- HEADER -->
  <div class="header">
    <asp:Image ID="imgLogo" runat="server" CssClass="logo" ImageUrl="~/Pictures/Classroom.jpg" />

    <div>
      <div class="title">Classroom Gazette</div>
      <div class="subtitle">Faculty Dashboard</div>
    </div>

    <div class="header-right">
      <button type="button" id="btnToggleTabs" class="toggle-btn" onclick="toggleTabs()">☰</button>


      <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-accent" OnClick="btnLogout_Click" />
    </div>
  </div>

  <!-- TABS -->
  <div class="tabs-row" id="tabsRow">
    <div class="tabs">
      <!-- NOTE: type="button" prevents form submit/postback -->
      <button type="button" class="tab active" data-url="CreateTimetableForm_Faculty.aspx" onclick="loadPage(this)">Lecture Timetable</button>
      <button type="button" class="tab" data-url="Faculty_Attendance.aspx" onclick="loadPage(this)">Attendance</button>
      <button type="button" class="tab" data-url="FacultyAssign.aspx" onclick="loadPage(this)">Upload Assignment</button>
      <button type="button" class="tab" data-url="FacultyReport.aspx" onclick="loadPage(this)">FacultyReport</button>
      <button type="button" class="tab" data-url="Show_FacultyEvent.aspx" onclick="loadPage(this)">Faculty Events</button>
    </div>
  </div>

  <!-- CONTENT -->
  <div class="content" id="contentArea">
    <div class="iframe-box">
      <div class="loader" id="loader">Loading…</div>
      <iframe id="pageFrame" src="CreateTimetableForm_Faculty.aspx"></iframe>
    </div>
  </div>

</form>

<script>
    function $(id){ return document.getElementById(id); }

    window.loadPage = function(tab){
        document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
        tab.classList.add('active');

        $('loader').classList.add('visible');
        $('pageFrame').src = tab.getAttribute('data-url');
        $('pageFrame').onload = () => $('loader').classList.remove('visible');
    }

    window.toggleTabs = function(){
        let row = $('tabsRow');
        let cont = $('contentArea');
        row.classList.toggle('hidden');
        cont.classList.toggle('full');
    }
</script>

</body>
</html>
