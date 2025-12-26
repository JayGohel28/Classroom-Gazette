<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContectAs.aspx.cs" Inherits="ContectAs" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Contact Form</title>
    <style>
        /* Body and background */
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: url('Pictures/Background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: yellow;
        }

        /* Header */
        header {
            background-color: rgba(0, 0, 0, 0.9);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 40px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.5);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-left img.logo {
            height: 50px;
            width: auto;
            border-radius: 8px;
        }

        .header-left span.title {
            font-size: 28px;
            font-weight: bold;
            color: yellow;
        }

        header a.home-btn {
            padding: 10px 20px;
            background-color: yellow;
            color: #111;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        header a.home-btn:hover {
            background-color: gold;
            box-shadow: 0 0 8px yellow;
        }

        /* Overlay */
        .overlay {
            background-color: rgba(0, 0, 0, 0.85);
            min-height: calc(100vh - 80px);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        /* Form container (increased size) */
        .contact-form {
            display: flex;
            background-color: #111;
            border-radius: 20px;
            box-shadow: 0 0 25px yellow;
            width: 950px;        /* increased width */
            height: 550px;       /* increased height */
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .contact-form:hover {
            box-shadow: 0 0 35px yellow;
        }

        /* Left image (same) */
        .contact-image {
            flex: 0 0 250px; 
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #000;
        }

        .contact-image img {
            height: 100%; 
            width: auto;  
            border-radius: 0;
            border-right: 3px solid yellow;
            box-shadow: 0 0 15px yellow;
        }

        /* Form fields */
        .form-fields {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 40px 40px;
            justify-content: space-around; /* space evenly vertically */
        }

        .form-fields h2 {
            margin-bottom: 10px;
            color: yellow;
            font-size: 34px;
        }

        /* Input fields (width increased, height decreased) */
        .form-fields input[type="text"],
        .form-fields input[type="email"],
        .form-fields textarea {
            width: 100%;            /* full width of form container */
            padding: 12px 15px;     /* reduced height */
            margin: 12px 0;
            border: 2px solid yellow;
            border-radius: 8px;
            background-color: #111;
            color: yellow;
            font-size: 18px;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }

        .form-fields textarea {
            flex-grow: 1; /* stretch textarea to fill vertical space proportionally */
            resize: none;
        }

        .form-fields input[type="text"]:focus,
        .form-fields input[type="email"]:focus,
        .form-fields textarea:focus {
            border-color: gold;
            box-shadow: 0 0 6px yellow;
            outline: none;
        }

        /* Submit button */
        .form-fields input[type="submit"] {
            width: 100%;             
            padding: 18px;           /* slightly smaller than before */
            border: none;
            border-radius: 8px;
            background-color: yellow;
            color: #111;
            font-weight: bold;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .form-fields input[type="submit"]:hover {
            background-color: gold;
            box-shadow: 0 0 12px yellow;
        }

        /* Responsive */
        @media (max-width: 1000px) {
            .contact-form {
                flex-direction: column;
                width: 100%;
                height: auto;
            }

            .contact-image {
                width: 100%;
                height: 300px;
            }

            .contact-image img {
                height: 100%;
                width: auto;
            }

            .form-fields {
                padding: 25px 20px;
                justify-content: flex-start;
            }

            .form-fields h2 {
                text-align: center;
            }

            .form-fields input[type="text"],
            .form-fields input[type="email"],
            .form-fields textarea {
                padding: 10px 12px;
                font-size: 16px;
            }

            .form-fields input[type="submit"] {
                padding: 15px;
                font-size: 18px;
            }
        }
    </style>
</head>
<body>
    <!-- Header with logo and Home button -->
    <header>
        <div class="header-left">
            <img class="logo" src="Pictures/Classroom.jpg" alt="Logo" />
            <span class="title">Classroom Gazette</span>
        </div>
        <a class="home-btn" href="Default.aspx">Go to Home Page</a>
    </header>

    <form id="form1" runat="server">
        <div class="overlay">
            <div class="contact-form">
                <!-- Left image -->
                <div class="contact-image">
                    <img src="Pictures/contectAs.jpg" alt="Side Image" />
                </div>

                <!-- Form fields -->
                <div class="form-fields">
                    <h2>Contact Us</h2>
                    <asp:TextBox ID="txtName" runat="server" placeholder="Your Name"></asp:TextBox>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Your Email"></asp:TextBox>
                    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" placeholder="Your Message"></asp:TextBox>
                    <asp:Button ID="btnSubmit" runat="server" Text="Send Message" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
