<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StudentMainForm.aspx.cs" Inherits="StudentMainForm" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
  <meta charset="utf-8" />
  <title>Student — Classroom Gazette</title>

  <style>

   

    :root{
      --accent: #4fc3f7;          /* Aqua Blue */
      --accent-glow: rgba(79,195,247,0.35);
      --dark: #071e2b;            /* Deep Navy */
      --page-bg: #0a2735;         /* Dark Blue BG */
      --panel-bg: #103445;        /* Card BG */
      --muted-text: #b6d9e6;      /* Soft bluish text */
      --tab-bg: #0d2c3a;
      --tab-active-bg: #164b61;
      font-family: "Segoe UI", Roboto, Arial, sans-serif;
    }

    html, body { height:100%; margin:0; background:var(--page-bg); color:var(--accent); }

    /* HEADER */
    .header{
      display:flex; align-items:center; padding:12px 18px;
      background:linear-gradient(180deg,var(--dark),#0b3042);
      color:var(--accent); border-bottom:1px solid rgba(255,255,255,0.05);
      box-shadow:0 6px 18px rgba(0,0,0,0.55); z-index:20;
    }

    .logo {
      width:56px; height:56px; border-radius:50%;
      display:flex; justify-content:center; align-items:center;
      background:var(--accent); color:var(--dark);
      font-weight:800; font-size:20px; margin-right:12px;
      box-shadow:0 0 14px var(--accent-glow);
    }

    .title-wrap { display:flex; flex-direction:column; }
    .title { font-size:19px; font-weight:700; color:#e9faff; }
    .subtitle { font-size:12px; color:rgba(213,243,255,0.7); margin-top:3px; }

    .header-right { margin-left:auto; display:flex; align-items:center; gap:10px; color:#fff; }

    .user { text-align:right; font-size:13px; color:var(--muted-text); }

    /* TOGGLE BUTTON */
    .toggle-wrapper { display:flex; align-items:center; gap:8px; margin-right:6px; }
    .toggle-btn{
      width:44px; height:40px; border-radius:10px;
      display:inline-flex; justify-content:center; align-items:center;
      background:var(--tab-bg); border:1px solid rgba(255,255,255,0.05);
      cursor:pointer; color:var(--muted-text); font-size:18px;
    }
    .toggle-btn:hover { background:var(--tab-active-bg); color:#fff; }

    /* LOGOUT BUTTON */
    .btn-accent{
      background:var(--accent); color:var(--dark);
      padding:8px 12px; border-radius:8px; border:none; font-weight:700;
      cursor:pointer; box-shadow:0 0 12px var(--accent-glow);
    }

    /* TABS */
    .tabs-row{
      background:var(--page-bg); padding:14px 18px;
      border-bottom:1px solid rgba(255,255,255,0.04);
      display:flex; align-items:center; gap:12px;
    }

    .tabs { display:flex; gap:10px; flex-wrap:wrap; }

    .tab{
      padding:9px 16px; border-radius:999px;
      background:var(--tab-bg); color:var(--muted-text); cursor:pointer;
      font-size:14px; font-weight:600; border:1px solid rgba(255,255,255,0.05);
      display:flex; gap:8px; align-items:center;
      transition:0.15s ease;
    }
    .tab:hover{
      transform:translateY(-2px);
      box-shadow:0 8px 18px rgba(0,0,0,0.45), 0 0 6px var(--accent-glow);
    }
    .tab.active{
      background:var(--tab-active-bg); color:#e9faff;
      box-shadow:0 12px 30px rgba(11,11,11,0.6), 0 0 14px var(--accent-glow);
      border-color:var(--accent);
    }

    /* CONTENT */
    .content { padding:14px 18px; height: calc(100vh - 56px - 68px); }
    .iframe-box{
      height:100%; background:var(--panel-bg);
      border:1px solid rgba(255,255,255,0.04);
      border-radius:8px; overflow:hidden; position:relative;
      box-shadow:0 0 16px rgba(0,0,0,0.4);
    }
    iframe#pageFrame{ width:100%; height:100%; border:0; background:#fff; }

    .tabs-row.hidden { display:none; }
    .content.full { height: calc(100vh - 56px); }

    /* LOADER */
    .loader{
      position:absolute; top:10px; right:10px;
      background:rgba(0,0,0,0.5); color:#fff;
      padding:6px 10px; border-radius:6px; font-size:13px; display:none;
    }
    .loader.visible{ display:flex; }

    @media (max-width:900px){
      .tabs{ flex-wrap:wrap; }
      .content{ height:55vh; }
    }
  </style>
</head>

<body>
<form id="form1" runat="server">

  <!-- HEADER -->
  <div class="header">
    <asp:Image ID="imgLogo" runat="server" CssClass="logo" ImageUrl="~/Pictures/Classroom.jpg" AlternateText="Logo" />
    <div class="title-wrap">
      <div class="title">Classroom Gazette</div>
      <div class="subtitle">Student Portal</div>
    </div>

    <div class="header-right">
      <div class="toggle-wrapper">
        <button type="button" id="btnToggleTabs" class="toggle-btn" onclick="toggleTabs()">☰</button>
      </div>

      

      <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-accent" OnClick="btnLogout_Click" />
    </div>
  </div>

  <!-- TABS -->
  <div class="tabs-row" id="tabsRow">
    <div class="tabs">
      <button type="button" class="tab active" data-url="Student_Timetable.aspx" onclick="loadPage(this)"> Lecture Timetable</button>
      <button type="button" class="tab" data-url="Attendance_Report.aspx" onclick="loadPage(this)">Attendance</button>
      <button type="button" class="tab" data-url="StudentAssign.aspx" onclick="loadPage(this)">Upload Assignment</button>
      <button type="button" class="tab" data-url="ShowEvent_Student.aspx" onclick="loadPage(this)">Event Notifications</button>
    </div>
  </div>

  
  <div class="content" id="contentArea">
    <div class="iframe-box">
      <div class="loader" id="loader"><span>Loading…</span></div>
      <iframe id="pageFrame" src="Student_Timetable.aspx"></iframe>
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
    };

    window.toggleTabs = function(){
        let row = $('tabsRow');
        let content = $('contentArea');
        let btn = $('btnToggleTabs');

        row.classList.toggle('hidden');
        content.classList.toggle('full');

        btn.textContent = row.classList.contains('hidden') ? '▤' : '☰';
    };
</script>

</body>
</html>

