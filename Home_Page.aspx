<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Home_Page.aspx.cs" Inherits="Home_Page" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Classroom Gazette — Services</title>

  <style>
    :root{
      --gold: #f7d400;
      --purple: #a770ef;
      --neon: #66d1ff;
      --bg-dark: #07050a;
      --panel: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(0,0,0,0.05));
      --text: #eef6ff;
      --muted: #b8cfe0;
      --glass: rgba(255,255,255,0.03);
      --accent-gradient: linear-gradient(90deg, var(--purple) 0%, var(--neon) 60%, var(--gold) 100%);
      --card-border: rgba(167,117,239,0.08);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    html,body{height:100%}
    body{
      font-family: Arial, sans-serif;
      background:
        radial-gradient(circle at 10% 10%, rgba(103,58,183,0.06), transparent 8%),
        radial-gradient(circle at 90% 80%, rgba(102,209,255,0.03), transparent 12%),
        var(--bg-dark) url('Pictures/Background.jpg') no-repeat center/cover;
      color: var(--text);
      -webkit-font-smoothing:antialiased;
      -moz-osx-font-smoothing:grayscale;
      min-height: 100vh;
      scroll-behavior:smooth;
    }

    /* NAVBAR */
    .navbar{
      width:100%;
      background: rgba(2,2,6,0.85);
      padding:12px 30px;
      display:flex;
      align-items:center;
      justify-content:space-between;
      border-bottom:2px solid rgba(247,212,0,0.06);
      position:fixed;
      top:0;
      z-index:60;
      backdrop-filter: blur(4px);
    }
    .navbar-left{display:flex;align-items:center;gap:14px}
    .navbar-left img{height:52px;width:auto;border-radius:6px;box-shadow:0 6px 20px rgba(103,58,183,0.08)}
    .navbar-title{
      font-size:18px;font-weight:800;
      background:var(--accent-gradient);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;
      letter-spacing:0.2px;
    }
    .nav-links a{
      color:var(--text);text-decoration:none;font-weight:700;margin-left:18px;padding:8px 10px;border-radius:8px;
      transition:all .18s ease;
      border:1px solid transparent;
      font-size:14px;
      cursor:pointer;
    }
    .nav-links a.active, .nav-links a:hover{
      color:#000;background:var(--gold);
      box-shadow: 0 8px 18px rgba(247,212,0,0.06), 0 0 12px rgba(102,209,255,0.03) inset;
    }

    /* Hero */
    .hero-wrap{padding-top:96px;max-width:1200px;margin:28px auto;padding-left:20px;padding-right:20px}
    .hero{display:grid;grid-template-columns:1fr 520px;gap:40px;align-items:center;margin-bottom:28px}
    .hero-illu img{width:100%;max-width:620px;display:block;border-radius:12px;box-shadow:0 18px 40px rgba(0,0,0,0.6)}
    .hero-content .eyebrow{color:var(--muted);font-weight:700;margin-bottom:10px}
    .hero-content .title{
      font-size:44px;line-height:1.02;font-weight:900;margin:0 0 14px;
      background:var(--accent-gradient);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;
      filter: drop-shadow(0 2px 10px rgba(0,0,0,0.6));
    }
    .hero-content .lead{color:var(--muted);font-size:17px;max-width:520px}
    .hero-cta{margin-top:18px}
    .btn{
      display:inline-block;padding:10px 18px;border-radius:999px;border:2px solid transparent;
      background:transparent;color:var(--text);font-weight:800;cursor:pointer;
      transition:transform .12s, box-shadow .18s;
      letter-spacing:0.3px;
    }
    .btn-primary{
      background:var(--accent-gradient);
      color:#05060a;border-color:transparent;
      box-shadow:0 10px 30px rgba(103,58,183,0.12), 0 0 18px rgba(102,209,255,0.08);
    }
    .btn:hover{transform:translateY(-3px)}

    /* Services grid */
    .wrap{max-width:1200px;margin:0 auto;padding:12px 20px}
    .section{margin-top:34px;margin-bottom:34px}
    .section h2{
      font-size:28px;color:var(--gold);text-align:center;margin-bottom:18px;
      text-shadow: 0 2px 0 rgba(0,0,0,0.6);
    }

    .services-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:20px;position:relative}
    .service-card{
      background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(0,0,0,0.04));
      border:1px solid var(--card-border);
      padding:20px;border-radius:12px;min-height:140px;
      transition:transform .25s, box-shadow .25s, border-color .25s;
      box-shadow: 0 8px 28px rgba(0,0,0,0.6);
    }
    .service-card:hover{
      transform:translateY(-8px);
      box-shadow:0 28px 60px rgba(2,2,6,0.7);
      border-color: rgba(102,209,255,0.12);
    }
    .service-card h3{
      margin-bottom:10px;
      background: linear-gradient(90deg, var(--purple), var(--neon));
      -webkit-background-clip:text; -webkit-text-fill-color:transparent;
      font-weight:800;
    }
    .service-card p{color:var(--muted);line-height:1.6}

    /* Features with icons */
    .features{display:grid;grid-template-columns:1fr 1fr;gap:18px}
    .feature{display:flex;gap:12px;align-items:flex-start}
    .feature .dot{
      width:46px;height:46px;border-radius:10px;
      background: linear-gradient(90deg,var(--purple),var(--neon));
      display:flex;align-items:center;justify-content:center;color:#021; font-weight:900;
      box-shadow:0 10px 24px rgba(102,209,255,0.06);
    }
    .feature .desc{color:var(--muted)}

    /* FAQ */
    .faq{max-width:900px;margin:0 auto}
    .faq-item{background:rgba(255,255,255,0.02);padding:14px;border-radius:10px;margin-bottom:10px;border:1px solid rgba(255,255,255,0.02)}
    .faq-item summary{font-weight:700;color:var(--text);cursor:pointer}
    .faq-item p{color:var(--muted);margin-top:8px}

    /* Feedback form */
    .feedback-card{
      background:linear-gradient(180deg, rgba(3,5,10,0.85), rgba(6,4,12,0.6));
      border:1px solid rgba(255,255,255,0.03);
      padding:28px;
      border-radius:16px;
      max-width:900px;
      margin:18px auto;
      box-shadow:0 10px 30px rgba(10,8,20,0.6);
      backdrop-filter: blur(6px);
      transition:0.3s ease;
    }
    .feedback-card:hover{
      transform:translateY(-4px);
      box-shadow:0 24px 52px rgba(25,12,60,0.5);
    }
    .feedback-grid input,
    .feedback-grid textarea{
      background:#06060a;
      border:1px solid rgba(255,255,255,0.03);
      color:var(--text);
      padding:14px;
      border-radius:10px;
      font-size:15px;
      transition:0.25s ease;
    }
    .feedback-grid input:focus,
    .feedback-grid textarea:focus{
      border:1px solid var(--neon);
      box-shadow:0 0 10px rgba(102,209,255,0.08);
      outline:none;
    }
    .feedback-card button{
      padding:12px 24px;
      font-size:15px;
      border-radius:999px;
      font-weight:800;
      border:0;
      background:var(--accent-gradient);
      color:#020207;
      box-shadow:0 12px 30px rgba(103,58,183,0.12);
    }
    .feedback-note{
      color:var(--muted);
      font-size:14px;
      margin-top:8px;
      padding-left:4px;
    }
    .feedback-title{
      font-size:26px;
      text-align:center;
      color:var(--gold);
      margin-bottom:16px;
      font-weight:800;
      letter-spacing:1px;
    }

    /* back to top */
    .to-top{position:fixed;right:18px;bottom:18px;background:var(--gold);color:#000;padding:10px;border-radius:999px;border:none;cursor:pointer;display:none;z-index:80}

    footer{text-align:center;margin-top:60px;color:var(--muted);padding-bottom:28px}

    /* responsive */
    @media(max-width:980px){.hero{grid-template-columns:1fr 360px}}
    @media(max-width:760px){.hero{grid-template-columns:1fr;gap:22px}.hero-illu{order:2}.hero-content{order:1}.features{grid-template-columns:1fr}.feedback-grid{grid-template-columns:1fr}.wrap{padding:12px}}

    /* little visual accents */
    .hero-content .title{transform: rotate(-0.4deg); display:inline-block}
    .services-grid:after{
      content:"";position:absolute;left:-10%;top:10%;width:120%;height:120%;pointer-events:none;
      background:
        radial-gradient(circle at 10% 20%, rgba(167,117,239,0.03), transparent 8%),
        radial-gradient(circle at 80% 80%, rgba(102,209,255,0.02), transparent 10%);
      transform:rotate(-4deg);
    }

    .service-card:nth-child(odd){transform:skewY(-0.6deg)}
    .service-card:nth-child(even){transform:skewY(0.6deg)}

    .nav-links a{position:relative}
    .nav-links a:after{content:"";position:absolute;left:10px;right:10px;bottom:-6px;height:3px;background:transparent;border-radius:3px;transition:all .22s ease}
    .nav-links a:hover:after{background:var(--gold);left:6px;right:6px;bottom:-8px}

    @media(max-width:420px){
      .hero-content .title{font-size:24px;transform:rotate(0.2deg)}
      .service-card{padding:18px}
    }
  </style>
</head>
<body>

  <!-- NAVBAR -->
  <header class="navbar" id="topNav">
    <div class="navbar-left">
      <img src="Pictures/Classroom.jpg" alt="Logo">
      <span class="navbar-title">Classroom Gazette</span>
    </div>
    <nav class="nav-links" id="navLinks">
      <a href="Login.aspx" class="nav-link">Login</a>
      <a href="Registration_Form.aspx" class="nav-link">Registration</a>
      <a href="#services" class="nav-link">Service</a>
      <a href="#features" class="nav-link">Features</a>
      <a href="#faq" class="nav-link">FAQ</a>
      <a href="#feedback" class="nav-link">Feedback</a>
      <a href="AboutAs.aspx" class="nav-link">About As</a>
    </nav>
  </header>

  <!-- HERO -->
  <div class="hero-wrap">
    <section class="hero">
      <div class="hero-illu">
        <img src="Pictures/home_page_picture.jpeg" alt="illustration">
      </div>
      <div class="hero-content">
        <div class="eyebrow">You Think, We Create</div>
        <h1 class="title">Services that simplify classroom administration</h1>
        <p class="lead">From attendance and assignments to timetables and events — Classroom Gazette provides role-based tools designed to make academic workflows simple and transparent.</p>
        <div class="hero-cta"><a href="#services" class="btn btn-primary">Explore Services</a></div>
      </div>
    </section>
  </div>

  <main class="wrap">

    <!-- Services -->
    <section id="services" class="section">
      <h2>Our Services</h2>
      <div class="services-grid" id="servicesGrid">
        <div class="service-card" data-idx="1">
          <h3>Attendance Management</h3>
          <p>Lecture-wise attendance, bulk updates and subject-wise analytics for accurate reporting.</p>
        </div>

        <div class="service-card" data-idx="2">
          <h3>Assignment Handling</h3>
          <p>Upload, submission tracking, grading and feedback — all in one place.</p>
        </div>

        <div class="service-card" data-idx="3">
          <h3>Lecture Timetable</h3>
          <p>Create and manage subject-wise timetables with notifications and calendar export.</p>
        </div>

        <div class="service-card" data-idx="4">
          <h3>Event Notifications</h3>
          <p>Admin and faculty can publish events that appear on student dashboards and email digests.</p>
        </div>

        <div class="service-card" data-idx="5">
          <h3>Performance Reports</h3>
          <p>Generate attendance, assignment and overall performance reports for auditing and parent communication.</p>
        </div>

        <div class="service-card" data-idx="6">
          <h3>Role-Based Access</h3>
          <p>Secure dashboards for Admin, Faculty and Students with appropriate permissions and views.</p>
        </div>

      </div>
    </section>

    <!-- Features -->
    <section id="features" class="section">
      <h2>Why choose Classroom Gazette</h2>
      <div class="features">
        <div class="feature"><div class="dot">01</div><div class="desc"><strong>Easy-to-use</strong><div class="muted">Designed for faculty and students with minimal training.</div></div></div>
        <div class="feature"><div class="dot">02</div><div class="desc"><strong>Fast Reporting</strong><div class="muted">Exportable reports in PDF/CSV for admin review.</div></div></div>
        <div class="feature"><div class="dot">03</div><div class="desc"><strong>Secure</strong><div class="muted">Role-based access and session controls.</div></div></div>
        <div class="feature"><div class="dot">04</div><div class="desc"><strong>Responsive</strong><div class="muted">Works across devices — mobile, tablet and desktop.</div></div></div>
      </div>
    </section>

    <!-- FAQ -->
    <section id="faq" class="section">
      <h2>Frequently Asked Questions</h2>
      <div class="faq">
        <details class="faq-item"><summary>Can students view their attendance?</summary><p>Yes — students can view subject-wise and overall attendance percentages and history.</p></details>
        <details class="faq-item"><summary>How are assignments graded?</summary><p>Faculty can upload marks and feedback which are visible to students once published.</p></details>
        <details class="faq-item"><summary>Can events be approved by admin?</summary><p>Yes — faculty events can be approved or rejected by admin before publishing.</p></details>
      </div>
    </section>

    <!-- Feedback (form at end of page) -->
    <section id="feedback" class="section">
      <h2>Feedback</h2>
      <div class="feedback-card">
        <form id="feedbackForm" onsubmit="return submitFeedback(event)">
          <div class="feedback-grid">
            <div>
              <label for="fbName">Name</label>
              <input id="fbName" name="name" type="text" placeholder="Your name" required />
            </div>
            <div>
              <label for="fbEmail">Email</label>
              <input id="fbEmail" name="email" type="email" placeholder="you@example.com" required />
            </div>
            <div class="full">
              <label for="fbMessage">Message</label>
              <textarea id="fbMessage" name="message" placeholder="Tell us what you think..." required></textarea>
            </div>
            <div class="full" style="display:flex;align-items:center;gap:12px;">
              <button type="submit" class="btn btn-primary">Send Feedback</button>
              <button type="button" class="btn" onclick="document.getElementById('feedbackForm').reset()">Clear</button>
              <div style="flex:1"></div>
            </div>
          </div>
        </form>
        <div id="fbStatus" class="feedback-note" style="display:none;margin-top:12px"></div>
      </div>
    </section>

    <footer>&copy; <span id="year">2025</span> Classroom Gazette — All rights reserved.</footer>

  </main>

  <button id="toTop" class="to-top" aria-label="Back to top">↑</button>

  <script>
      // set year
      document.getElementById('year').textContent = new Date().getFullYear();

      // Smooth scroll + active nav highlighting (scrollspy-lite)
      const navLinks = document.querySelectorAll('.nav-links a');
      const sections = [...document.querySelectorAll('main .section'), document.querySelector('.hero')];

      function onScroll(){
        const y = window.scrollY + 120; // offset for fixed nav
          let active = null;
          sections.forEach(sec => {
              if(!sec) return;
            const top = sec.offsetTop;
            const h = sec.offsetHeight;
          if(y >= top && y < top + h) active = sec;
      });
      navLinks.forEach(a => a.classList.remove('active'));
      if(active){
        const id = active.id || 'services';
        const link = document.querySelector('.nav-links a[href="#'+id+'"]');
          if(link) link.classList.add('active');
      }

      // show/hide back-to-top
        const toTop = document.getElementById('toTop');
      if(window.scrollY > 600) toTop.style.display = 'block'; else toTop.style.display = 'none';
      }

      window.addEventListener('scroll', onScroll);
      // initial call
      onScroll();

      // nav link click: only intercept internal anchor links (#...), allow normal navigation otherwise
      navLinks.forEach(a => {
          a.addEventListener('click', (e) => {
              const href = a.getAttribute('href') || '';

      // If it's an internal section link (starts with '#'), handle smooth scroll
      if (href.startsWith('#')) {
          e.preventDefault();
        const target = document.querySelector(href);
          if (!target) return;
        const top = target.getBoundingClientRect().top + window.scrollY - 90; // offset for nav
          window.scrollTo({ top, behavior: 'smooth' });
      }
      // Otherwise (e.g., "Login.aspx" or "Registration_Form.aspx"), do NOT preventDefault
      // and allow the browser to navigate normally.
      });
      });

      // reveal on scroll using IntersectionObserver
      const cards = document.querySelectorAll('.service-card, .feature, .faq-item, .feedback-card');
      const io = new IntersectionObserver(entries => {
          entries.forEach(e => {
              if(e.isIntersecting){
                e.target.style.transform = 'none';
      e.target.style.opacity = '1';
      } else {
          e.target.style.opacity = '0.02';
          e.target.style.transform = 'translateY(12px)';
      }
      })
      },{threshold:0.12});
      cards.forEach(c=>{c.style.opacity='0.02';c.style.transform='translateY(12px)';io.observe(c)});

      // Back to top
      document.getElementById('toTop').addEventListener('click', ()=>window.scrollTo({top:0,behavior:'smooth'}));

      // feedback submit (design-only)
      function submitFeedback(e){
          e.preventDefault();
          const name = document.getElementById('fbName').value.trim();
          const email = document.getElementById('fbEmail').value.trim();
          const msg = document.getElementById('fbMessage').value.trim();
          const status = document.getElementById('fbStatus');
          if(!name||!email||!msg){
              status.style.display='block';status.style.color='#ff6b6b';status.textContent='Please fill all required fields.';return false;
          }
          // fake sending
          status.style.display='block';status.style.color='var(--muted)';status.textContent='Sending feedback...';
          setTimeout(()=>{status.style.color='var(--gold)';status.textContent='Thank you — your feedback has been recorded (design-only).';document.getElementById('feedbackForm').reset();},900);
      return false;
      }
  </script>
</body>
</html>
