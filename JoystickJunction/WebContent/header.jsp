<!DOCTYPE html>
<html>
<head>
    <title>Sami and Ryan's Grocery Main Page</title>
    <style>
        header {
            display: flex;
            justify-content: space-between; 
            align-items: center; 
            background-color: rgba(0, 0, 0, 0);
            color: white;
            padding: 10px 20px;
            border-bottom: 3px solid #5d635e;
        }

        .header-title h1 {
            font-size: 24px;
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .header-title h1 a {
            color: white;
            text-decoration: none;
            align-items: center; 
        }

        .header-title h1 a:hover {
            text-shadow: 0 2px 8px rgba(59, 78, 105, 0.8);
        }

        .dropdown {
            position: relative;
        }

        .dropbtn {
            background-color: #333;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            cursor: pointer;
            text-transform: uppercase;
        }

        .dropbtn:hover {
            background-color: #444;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #333;
            min-width: 160px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1;
            text-align: left;
        }

        .dropdown-content a {
            color: white;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: 14px;
        }

        .dropdown-content a:hover {
            background-color: #575757;
        }

        .dropdown:hover .dropdown-content {
            display: block; 
        }

        .user-info {
            font-size: 14px;
            color: #ccc;
            text-align: right;
            padding: 8px 12px;
            border: 1px solid #5d635e;
            background-color: rgba(93, 99, 94, 0.2);
        }

    </style>
</head>
<body>
    <header>
        <div class="header-title">
            <h1><a href="listprod.jsp">Joystick Junction</a></h1>
        </div>

        <div class="user-info">
            <% 
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName != null && !userName.isEmpty()) {
            %>
                Logged in as: <strong><%= userName %></strong>
            <% } else { %>
                Logged in as: <strong>Guest</strong>
            <% } %>
        </div>

        <nav class="dropdown">
            <button class="dropbtn">Menu</button>
            <div class="dropdown-content">
                <a href="login.jsp">Login</a>
                <a href="listprod.jsp">Begin Shopping</a>
                <a href="listorder.jsp">List All Orders</a>
                <a href="customer.jsp">Customer Info</a>
                <a href="admin.jsp">Administrators</a>
                <a href="logout.jsp">Log Out</a>
                <a href="showcart.jsp">Show Cart</a>
                <a href="createuser.jsp">Sign Up</a>
            </div>
        </nav>
    </header>
</body>
</html>
