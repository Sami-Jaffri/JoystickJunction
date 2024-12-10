<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <!-- Google Fonts -->
    <link href='https://fonts.googleapis.com/css?family=Lato:300,400,700' rel='stylesheet' type='text/css'>
    <style>
        body {
            font-family: 'Lato', sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            overflow: hidden; 
        }

        .main-container {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 50px;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .title-container {
            text-align: right;
        }

        .title-container h1 {
            font-size: 3em;
            margin: 0;
            color: #ffffff;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.7);
        }

        .title-container p {
            font-size: 1.2em;
            color: #cccccc;
            text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.7);
        }

        .login-container {
            background-color: #2a2a2a;
            padding: 30px;
            border-radius: 10px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.5);
            text-align: center;
        }

        .login-container h3 {
            font-size: 1.8em;
            margin-bottom: 20px;
            color: #ffffff;
        }

        .form-group {
            margin: 15px 0;
            text-align: left;
        }

        .form-group label {
            font-size: 1em;
            margin-bottom: 5px;
            display: block;
            color: #f5f5f5;
        }

        .form-group input {
            width: 95%;
            padding: 10px;
            font-size: 1em;
            border-radius: 5px;
            border: 1px solid #ddd;
            background-color: rgba(255, 255, 255, 0.9);
        }

        .submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #6c757d, #343a40);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1.2em;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .submit:hover {
            background: linear-gradient(135deg, #343a40, #212529);
            transform: scale(1.05);
        }

        .error-message {
            color: red;
            margin-top: 10px;
            font-size: 1em;
        }
    </style>
</head>
<body>
    <%@ include file="background.html" %>
    <div class="main-container">
        <div class="title-container">
            <h1>Welcome to Joystick Junction</h1>
            <p>Your gaming experience starts here.</p>
        </div>
        <div class="login-container">
            <h3>Please Login to System</h3>
            <% 
            // Print prior error login message if present
            if (session.getAttribute("loginMessage") != null) {
                out.println("<p class='error-message'>" + session.getAttribute("loginMessage").toString() + "</p>");
            }
            %>
            <form name="MyForm" method="post" action="validateLogin.jsp">
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" maxlength="10" placeholder="Enter your username">
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" maxlength="10" placeholder="Enter your password">
                </div>
                <input type="submit" name="Submit2" value="Log In" class="submit">
            </form>
        </div>
    </div>
</body>
</html>
