<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AboutAs.aspx.cs" Inherits="AboutAs" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>About Us</title>

    <style>
        /* ---------- Base & BG ---------- */
        :root {
            --bg-dark: rgba(0,0,0,0.85);
            --accent: #ffd400; /* yellow */
            --accent-2: #ffea7a;
            --glass: rgba(255,255,255,0.03);
            --max-width: 1100px;
        }

        html, body {
            height: 100%;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            background: linear-gradient(120deg, rgba(0,0,0,0.55), rgba(0,0,0,0.7)), url('Pictures/Background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #fff;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        /* ---------- Header ---------- */
        header {
            background: linear-gradient(90deg, rgba(0,0,0,0.85), rgba(0,0,0,0.6));
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 14px 30px;
            border-bottom: 2px solid rgba(255,212,0,0.06);
            position: sticky;
            top: 0;
            z-index: 40;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .logo {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 10px;
            border: 2px solid var(--accent);
            box-shadow: 0 4px 12px rgba(0,0,0,0.6);
            background: var(--glass);
        }

        .title {
            font-size: 22px;
            color: var(--accent);
            font-weight: 700;
            letter-spacing: 0.2px;
        }

        .home-btn {
            text-decoration: none;
            padding: 9px 16px;
            background: linear-gradient(180deg,var(--accent),var(--accent-2));
            color: #111;
            border-radius: 10px;
            font-weight: 700;
            box-shadow: 0 6px 18px rgba(0,0,0,0.45);
            transition: transform .14s ease, box-shadow .14s ease;
        }

            .home-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 22px rgba(0,0,0,0.55);
            }

        /* ---------- Content wrapper ----------*/
        .page {
            max-width: var(--max-width);
            margin: 28px auto;
            padding: 26px;
            display: grid;
            gap: 18px;
        }

        /* ---------- Main content ---------- */
        .main {
            background: linear-gradient(180deg, rgba(0,0,0,0.72), rgba(0,0,0,0.8));
            border-radius: 18px;
            padding: 28px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.6), 0 0 18px rgba(255,212,0,0.06) inset;
            border: 1px solid rgba(255,255,255,0.03);
        }

            .main h1 {
                margin: 0 0 12px 0;
                color: var(--accent);
                font-size: 34px;
                text-align: center;
                letter-spacing: 0.4px;
            }

            .main p {
                margin: 10px 0;
                font-size: 17px;
                color: #e9e6e6;
                line-height: 1.7;
                text-align: justify;
            }

        /* ---------- Team section ---------- */
        .team-wrap {
            margin-top: 6px;
            text-align: center;
        }

        .team-title {
            font-size: 26px;
            color: var(--accent);
            margin: 6px 0 14px;
            font-weight: 700;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            align-items: start;
        }

        .member {
            background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(0,0,0,0.12));
            border-radius: 14px;
            padding: 16px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.5);
            transition: transform .18s ease, box-shadow .18s ease;
            text-align: center;
            border: 1px solid rgba(255,212,0,0.06);
        }

            .member:hover {
                transform: translateY(-6px);
                box-shadow: 0 18px 50px rgba(0,0,0,0.65);
            }

        .avatar {
            width: 180px; /* increased from 130px */
            height: 180px; /* increased from 130px */
            display: block;
            margin: 0 auto;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid var(--accent);
            box-shadow: 0 8px 22px rgba(0,0,0,0.55);
            background: linear-gradient(180deg, rgba(0,0,0,0.18), rgba(0,0,0,0.35));
        }

        

        .member h3 {
            margin: 10px 0 4px;
            color: var(--accent);
            font-size: 18px;
        }

        .member p.role {
            margin: 0;
            color: #ddd;
            font-size: 14px;
            opacity: 0.9;
        }

        /* ---------- small screens ---------- */
        @media (max-width: 900px) {
            .team-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 14px;
            }

            .main h1 {
                font-size: 28px;
            }

            .title {
                font-size: 18px;
            }
        }

        @media (max-width: 560px) {
            header {
                padding: 12px 14px;
            }

            .team-grid {
                grid-template-columns: 1fr;
            }

            .logo {
                width: 48px;
                height: 48px;
            }

            .page {
                padding: 14px;
            }

            .main {
                padding: 18px;
            }
        }

        /* ---------- Utilities ---------- */
        .muted {
            color: #cfcfcf;
            font-size: 14px;
        }

        .center {
            text-align: center;
        }
    </style>
</head>
<body>
    <header>
        <div class="header-left">
            <!-- Use a smaller logo, if missing the fallback will be handled by onerror -->
            <img class="logo" src="Pictures/Classroom.jpg" alt="Classroom Gazette Logo"
                onerror="this.src='Pictures/placeholder-logo.png';" />
            <div>
                <div class="title">Classroom Gazette</div>
                <div class="muted" style="font-size: 12px;">Connect • Inform • Simplify</div>
            </div>
        </div>
        <a class="home-btn" href="Home_Page.aspx">Go to Home Page</a>
    </header>

    <div class="page">
        <section class="main">
            <h1>About Us</h1>
            <p>
                Welcome to the Classroom Gazette!
                This platform is designed to keep students, faculty, and administration connected and informed.
                Here, you can find updates on events, assignments, and other important college-related information.
                Our mission is to provide a streamlined communication system within the classroom environment while keeping the interface simple and visually appealing.
            </p>

            <p>
                Use this section to add more details about your college, the project objectives, or team members.
                The design follows a consistent black & yellow theme for a professional, high-contrast look.
            </p>
        </section>

        <section class="team-wrap">
            <div class="team-title">Our Developers</div>

            <div class="team-grid">
                <!-- Member 1 -->
                <div class="member">
                    <img class="avatar" src="Pictures/Jay.jpeg" alt="Jay Gohel"
                        loading="lazy"
                        onerror="this.onerror=null;this.src='Pictures/placeholder-avatar.png';" />
                    <h3>Jay Gohel</h3>
                    <p class="role">Full Stack Developer</p>
                </div>

                <!-- Member 2 -->
                <div class="member">
                    <img class="avatar" src="Pictures/DhruvParmar.jpeg" alt="Dhruv Parmar"
                        loading="lazy"
                        onerror="this.onerror=null;this.src='Pictures/placeholder-avatar.png';" />
                    <h3>Dhruv Parmar</h3>
                    <p class="role">C# ASP.NET Developer</p>
                </div>

                <!-- Member 3 -->
                <div class="member">
                    <img class="avatar" src="Pictures/Rajesh.jpeg" alt="Rajesh Shiyani"
                        loading="lazy"
                        onerror="this.onerror=null;this.src='Pictures/placeholder-avatar.png';" />
                    <h3>Rajesh Shiyani</h3>
                    <p class="role">SQL Developer</p>
                </div>
            </div>
        </section>
    </div>

    <!-- Small inline script to help in dev if images missing -->
    <script>
        // Optional: quickly log missing image filenames during development
        (function(){
            const imgs = document.querySelectorAll('img');
            imgs.forEach(i => i.addEventListener('error', e => {
                console.warn('Missing image:', e.target.src);
        }));
        })();
    </script>
</body>
</html>
