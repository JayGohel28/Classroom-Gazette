<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminMainForm.aspx.cs" Inherits="AdminMainForm" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
  <meta charset="utf-8" />
  <title>Admin — Classroom Gazette</title>

  <style>
    :root{
      --accent: #f1c40f; /* yellow */
      --dark: #0b0b0f;   /* near-black */
      --page-bg: #111;
      --panel-bg: #222;
      --muted-text: #9a9a9a;
      --tab-bg: #101214;
      --tab-active-bg: #1e1e1e;
      font-family: "Segoe UI", Roboto, Arial, sans-serif;
    }

    html, body { height:100%; margin:0; background:var(--page-bg); color:var(--accent); }

    .header{
      display:flex; align-items:center; padding:12px 18px;
      background:linear-gradient(180deg,var(--dark),#0e0e12);
      color:var(--accent); border-bottom:1px solid rgba(241,196,15,0.09);
      box-shadow:0 6px 18px rgba(0,0,0,0.5); z-index:20;
    }

    .logo { width:56px; height:56px; border-radius:50%; display:flex; align-items:center; justify-content:center;
            background:var(--accent); color:var(--dark); font-weight:800; font-size:20px; margin-right:12px; flex:0 0 56px; }

    .title-wrap { display:flex; flex-direction:column; }
    .title { font-size:18px; font-weight:700; color:#fff; line-height:1; }
    .subtitle { font-size:12px; color:rgba(255,255,255,0.75); margin-top:3px; }

    .header-right { margin-left:auto; display:flex; align-items:center; gap:10px; color:#fff; }

    .user { text-align:right; font-size:13px; color:var(--muted-text); }

    /* MOVE toggle here so it's always visible */
    .toggle-wrapper { display:flex; align-items:center; gap:8px; margin-right:6px; }

    .toggle-btn {
      width:44px; height:40px; border-radius:10px; display:inline-flex; align-items:center; justify-content:center;
      background:var(--tab-bg); border:1px solid rgba(255,255,255,0.02); cursor:pointer; color:var(--muted-text); font-size:18px;
    }
    .toggle-btn:hover { background:var(--tab-active-bg); color:#fff; }

    .btn-accent { background:var(--accent); padding:8px 12px;border-radius:8px;border:none;color:var(--dark); font-weight:700; cursor:pointer; }

    .tabs-row { background:var(--page-bg); padding:14px 18px; border-bottom:1px solid rgba(255,255,255,0.02);
                display:flex; align-items:center; gap:12px; position: relative; }

    .tabs { display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
    .tab { padding:9px 16px; border-radius:999px; background:var(--tab-bg); color:var(--muted-text); cursor:pointer;
           font-size:14px; font-weight:600; border:1px solid rgba(255,255,255,0.02); display:flex; gap:8px; align-items:center;
           transition: transform .12s, box-shadow .12s, background .12s; }
    .tab:hover { transform: translateY(-2px); box-shadow: 0 8px 18px rgba(0,0,0,0.45); }
    .tab.active { background:var(--tab-active-bg); color:#fff; box-shadow:0 12px 30px rgba(11,11,11,0.5), 0 0 12px rgba(241,196,15,0.06) inset;
                  border-color: rgba(241,196,15,0.12); }

    .tabs-controls { margin-left:auto; display:flex; gap:8px; align-items:center; }

    .content { padding:14px 18px; height: calc(100vh - 56px - 68px); box-sizing:border-box; transition: height .12s; }
    .iframe-box { height:100%; background:var(--panel-bg); border:1px solid rgba(241,196,15,0.06); border-radius:8px; overflow:hidden; position:relative; display:flex; flex-direction:column; }
    iframe#pageFrame { width:100%; height:100%; border:0; display:block; background:#fff; flex:1 1 auto; }

    .tabs-row.hidden { display:none; }
    .content.full { height: calc(100vh - 56px); }

    .loader { position:absolute; top:10px; right:10px; background: rgba(0,0,0,0.5); color:#fff; padding:6px 10px; border-radius:6px; font-size:13px; display:none; align-items:center; gap:8px; }
    .loader.visible { display:flex; }

    @media (max-width:900px) {
      .tabs { flex-wrap:wrap; }
      .content { height:55vh; }
    }
  </style>
</head>
<body>
  <form id="form1" runat="server">

    <div class="header">
      <asp:Image ID="imgLogo" runat="server" CssClass="logo" ImageUrl="~/Pictures/Classroom.jpg" AlternateText="Logo" />
      <div class="title-wrap">
        <div class="title">Classroom Gazette</div>
        <div class="subtitle">Admin Portal</div>
      </div>

      <div class="header-right">
        <div class="toggle-wrapper">
          <!-- Always visible toggle button -->
          <button type="button" id="btnToggleTabs" class="toggle-btn" title="Show / Hide Tabs" onclick="toggleTabs()">☰</button>
        </div>

        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-accent" OnClick="btnLogout_Click" />
      </div>
    </div>

    <div class="tabs-row" id="tabsRow">
      <div class="tabs" role="tablist" id="topTabs">
        <button type="button" class="tab active" data-url="ViewStudents_admin.aspx" onclick="loadPage(this)"><span class="icon"></span> View Student & Faculty</button>
        <button type="button" class="tab" data-url="ManageReport_admin.aspx" onclick="loadPage(this)"><span class="icon"></span> Manage Report</button>
        <button type="button" class="tab" data-url="ManageFacultyEvents_admin.aspx" onclick="loadPage(this)"><span class="icon"></span> Manage Faculty Events</button>
        <button type="button" class="tab" data-url="ManageStudentEvents_admin.aspx" onclick="loadPage(this)"><span class="icon"></span> Manage Student Events</button>
      </div>

      <div class="tabs-controls">
        <!-- helper area kept empty; toggle is in header -->
      </div>
    </div>

    <div class="content" id="contentArea">
      <div class="iframe-box">
        <div class="loader" id="loader"><span>Loading…</span></div>
        <iframe id="pageFrame" src="ViewStudents_admin.aspx" title="Admin content frame"></iframe>
      </div>
    </div>

  </form>

  <script>
      (function () {
          function $(id) { return document.getElementById(id); }

          function adjustContentHeight() {
              var header = document.querySelector('.header');
              var tabsRow = $('tabsRow');
              var content = $('contentArea');

              var headerRect = header.getBoundingClientRect();
              var tabsRect = (tabsRow && tabsRow.style.display !== 'none') ? tabsRow.getBoundingClientRect() : { height: 0 };
              var totalUsed = headerRect.height + ((tabsRow && tabsRow.classList.contains('hidden')) ? 0 : tabsRect.height);
              var newHeight = window.innerHeight - totalUsed - 8;
              if (newHeight < 200) newHeight = 200;
              content.style.height = newHeight + 'px';
          }

          window.addEventListener('load', function () { adjustContentHeight(); /* set correct initial icon */ updateToggleIcon(); });
          window.addEventListener('resize', adjustContentHeight);

          window.loadPage = function (tabEl) {
              var url = tabEl.getAttribute('data-url');
              if (!url) return;
              var tabs = document.querySelectorAll('.tab');
              tabs.forEach(function (t) { t.classList.remove('active'); });
              tabEl.classList.add('active');

              $('loader').classList.add('visible');
              var frame = $('pageFrame');
              frame.src = url;

              frame.onload = function () {
                  $('loader').classList.remove('visible');
                  adjustContentHeight();
              };
          };

          // toggle: hide/show tabsRow — toggle button sits in header so always available
          window.toggleTabs = function () {
              var row = $('tabsRow');
              var btn = $('btnToggleTabs');

              if (row.classList.contains('hidden')) {
                  row.classList.remove('hidden');
                  $('contentArea').classList.remove('full');
              } else {
                  row.classList.add('hidden');
                  $('contentArea').classList.add('full');
              }
              updateToggleIcon();
              adjustContentHeight();
          };

          // update icon for toggle button
          function updateToggleIcon() {
              var row = $('tabsRow');
              var btn = $('btnToggleTabs');
              if (row.classList.contains('hidden')) {
                  btn.textContent = '▤'; // show icon when tabs hidden
                  btn.title = 'Show Tabs';
              } else {
                  btn.textContent = '☰'; // hide icon when tabs visible
                  btn.title = 'Hide Tabs';
              }
          }

          // allow child frames to ask parent to open a page
          window.addEventListener('message', function (ev) {
              try {
                  var d = ev.data;
                  if (!d || typeof d !== 'object') return;
                  if (d.action === 'open' && d.url) {
                      var tabs = document.querySelectorAll('.tab');
                      tabs.forEach(function (t) {
                          if (t.getAttribute('data-url') === d.url) {
                              t.classList.add('active');
                          } else if (!d.keepActive) {
                              t.classList.remove('active');
                          }
                      });
                      $('loader').classList.add('visible');
                      $('pageFrame').src = d.url;
                      $('pageFrame').onload = function () { $('loader').classList.remove('visible'); adjustContentHeight(); };
                      if (d.hideTabs) { $('tabsRow').classList.add('hidden'); $('contentArea').classList.add('full'); adjustContentHeight(); updateToggleIcon(); }
                  }
              } catch (e) { console.warn(e); }
          }, false);

          document.addEventListener('DOMContentLoaded', function () {
              var first = document.querySelector('.tab.active') || document.querySelector('.tab');
              if (first) first.classList.add('active');
              adjustContentHeight();
          });

      })();
  </script>
</body>
</html>

