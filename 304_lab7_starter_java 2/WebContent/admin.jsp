<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            color: #f5f5f5;
        }

        h6 {
            font-size: 2.5em;
            text-align: center;
            margin: 20px 0;
            color: #f5f5f5;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }

        h3 {
            text-align: center;
            margin-bottom: 30px;
            color: #f5f5f5;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
        }

        table {
            width: 80%;
            margin: 0 auto 30px;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            overflow: hidden;
            backdrop-filter: blur(8px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
        }

        th, td {
            padding: 15px;
            text-align: center;
            color: #f5f5f5;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        th {
            background: rgba(255, 255, 255, 0.2);
            font-weight: bold;
            text-transform: uppercase;
        }

        td {
            background: rgba(255, 255, 255, 0.1);
        }

        tr:nth-child(even) td {
            background: rgba(255, 255, 255, 0.05);
        }

        tr:hover td {
            background: rgba(255, 255, 255, 0.2);
            transition: background-color 0.3s ease;
        }

        .total-day-row {
            font-weight: bold;
            background: rgba(255, 255, 255, 0.3);
        }

        .error {
            color: #e57373;
            text-align: center;
            font-size: 1.2em;
            margin-top: 20px;
        }

    .updatebutton {
        background: linear-gradient(135deg, #6c757d, #343a40);
        color: #fff;
        font-size: 1em;
        padding: 8px 15px;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .updatebutton:hover {
        background: linear-gradient(135deg, #343a40, #212529);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        transform: translateY(-2px);
    }

    .updatebutton:active {
        transform: translateY(0);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    input[type="number"] {
        border: 1px solid rgba(255, 255, 255, 0.5);
        border-radius: 10px;
        padding: 5px;
        font-size: 1em;
        text-align: center;
        background: rgba(255, 255, 255, 0.2);
        color: #fff;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    input[type="number"]:focus {
        outline: none;
        border-color: #00c6ff;
        box-shadow: 0 0 5px #00c6ff;
    }

    form {
        display: inline-block;
    }
    </style>
</head>
<body>
    <%@ include file="auth.jsp" %>
    <%@ include file="header.jsp" %>
    <%@ include file="background.html" %>
    <%@ include file="jdbc.jsp" %>

    <title>Administrator Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>

        #salesChartContainer {
            width: 80%;
            margin: 30px auto;
        }
        canvas {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
        }
    </style>
    <h3>Sales Report by Day and Product</h3>

    <%
    // Initialize StringBuilder variables outside the try-catch block
    StringBuilder day5Products = new StringBuilder("[");
    StringBuilder day5Sales = new StringBuilder("[");
    %>
    
    <table>
        <tr>
            <th>Day</th>
            <th>Product Name</th>
            <th>Total Sales (USD)</th>
        </tr>
        <%
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection con = DriverManager.getConnection(url, uid, pw);
    
                String sql = "SELECT " +
                             "DAY(os.orderDate) AS OrderDay, " +
                             "p.productName, " +
                             "SUM(op.quantity * op.price) AS TotalSales " +
                             "FROM ordersummary os " +
                             "JOIN orderproduct op ON os.orderId = op.orderId " +
                             "JOIN product p ON op.productId = p.productId " +
                             "GROUP BY DAY(os.orderDate), p.productName " +
                             "ORDER BY OrderDay, TotalSales DESC";
    
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
    
                int currentDay = -1;
                double dayTotal = 0.0;
    
                while (rs.next()) {
                    int day = rs.getInt("OrderDay");
                    String productName = rs.getString("productName");
                    double totalSales = rs.getDouble("TotalSales");
    
                    if (day == 5) {
                        // Add data to the Day 5 chart arrays
                        day5Products.append("'").append(productName).append("',");
                        day5Sales.append(totalSales).append(",");
                    }
    
                    if (day != currentDay && currentDay != -1) {
        %>
        <tr class="total-day-row">
            <td colspan="2">Total Sales for Day <%= currentDay %>:</td>
            <td>$<%= String.format("%.2f", dayTotal) %></td>
        </tr>
        <%
                        dayTotal = 0.0;
                    }
        %>
        <tr>
            <td><%= day %></td>
            <td><%= productName %></td>
            <td>$<%= String.format("%.2f", totalSales) %></td>
        </tr>
        <%
                    dayTotal += totalSales;
                    currentDay = day;
                }
                if (currentDay != -1) {
        %>
        <tr class="total-day-row">
            <td colspan="2">Total Sales for Day <%= currentDay %>:</td>
            <td>$<%= String.format("%.2f", dayTotal) %></td>
        </tr>
        <%
                }
    
                // Close the arrays
                day5Products.append("]");
                day5Sales.append("]");
    
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
        %>
        <tr>
            <td colspan="3" class="error">Error: <%= e.getMessage() %></td>
        </tr>
        <%
            }
        %>
    </table>
    
    <!-- Graph Representation -->
    <div id="salesChartContainer">
        <canvas id="salesChart"></canvas>
    </div>
    
    <!-- Pass Data to JavaScript -->
    <script>
        // Only Day 5 data
        day5Products = <%= day5Products.toString() %>;
        day5Sales = <%= day5Sales.toString() %>;
    
        const ctx = document.getElementById('salesChart').getContext('2d');
        const salesChart = new Chart(ctx, {
            type: 'bar', // Chart type
            data: {
                labels: day5Products, // Product names
                datasets: [{
                    label: 'Total Sales (USD) for Day 5',
                    data: day5Sales, // Sales data
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        beginAtZero: true
                    },
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
    

    <h3>Warehouse and Inventory Levels</h3>

    <table>
        <tr>
            <th>Warehouse Name</th>
            <th>Product ID</th>
            <th>Quantity</th>
            <th>Price (USD)</th>
            <th>Actions</th>
        </tr>
    
        <%
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection con = DriverManager.getConnection(url, uid, pw);
    
                String warehouseInventoryQuery = 
                    "SELECT w.warehouseId, w.warehouseName, pi.productId, pi.quantity, pi.price " +
                    "FROM warehouse w " +
                    "JOIN productinventory pi ON w.warehouseId = pi.warehouseId " +
                    "ORDER BY w.warehouseName, pi.productId";
    
                PreparedStatement ps = con.prepareStatement(warehouseInventoryQuery);
                ResultSet rs = ps.executeQuery();
    
                while (rs.next()) {
                    int warehouseId = rs.getInt("warehouseId");
                    String warehouseName = rs.getString("warehouseName");
                    int productId = rs.getInt("productId");
                    int quantity = rs.getInt("quantity");
                    double price = rs.getDouble("price");
        %>
        <tr>
            <td><%= warehouseName %></td>
            <td><%= productId %></td>
            <td>
                <form method="post" action="updateInventory.jsp" style="display: inline;">
                    <input type="number" name="quantity" value="<%= quantity %>" min="0" required style="width: 70px; text-align: center;">
                    <input type="hidden" name="warehouseId" value="<%= warehouseId %>">
                    <input type="hidden" name="productId" value="<%= productId %>">
            </td>
            <td>$<%= String.format("%.2f", price) %></td>
            <td>
                    <button type="submit" class = "updatebutton">Update</button>
                </form>
            </td>
        </tr>
        <%
                }
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
        %>
        <tr>
            <td colspan="5" class="error">Error: <%= e.getMessage() %></td>
        </tr>
        <%
            }
        %>
    </table>
    
    <h3>Customer List</h3>

<table>
    <tr>
        <th>Customer ID</th>
        <th>First Name</th>
        <th>Last Name</th>
    </tr>
    <%
        try {
            // Database connection
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection con = DriverManager.getConnection(url, uid, pw);

            // Query to retrieve customer information
            String customerQuery = "SELECT customerId, firstName, lastName FROM customer ORDER BY lastName, firstName";
            PreparedStatement ps = con.prepareStatement(customerQuery);
            ResultSet rs = ps.executeQuery();

            // Iterate through the results and display them in the table
            while (rs.next()) {
                int customerId = rs.getInt("customerId");
                String firstName = rs.getString("firstName");
                String lastName = rs.getString("lastName");
    %>
    <tr>
        <td><%= customerId %></td>
        <td><%= firstName %></td>
        <td><%= lastName %></td>
    </tr>
    <%
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
    %>
    <tr>
        <td colspan="3" class="error">Error: <%= e.getMessage() %></td>
    </tr>
    <%
        }
    %>
</table>

<h3>Update Product Details</h3>

<table>
    <tr>
        <th>Product ID</th>
        <th>Product Name</th>
        <th>Price (USD)</th>
        <th>Description</th>
        <th>Image</th>
        <th>Actions</th>
    </tr>
    <%
        try {
            // Database connection
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection con = DriverManager.getConnection(url, uid, pw);

            // Query to retrieve product details
            String productQuery = "SELECT productId, productName, productPrice, productDesc FROM product";
            PreparedStatement ps = con.prepareStatement(productQuery);
            ResultSet rs = ps.executeQuery();

            // Iterate through results and create editable rows
            while (rs.next()) {
                int productId = rs.getInt("productId");
                String productName = rs.getString("productName");
                double productPrice = rs.getDouble("productPrice");
                String productDesc = rs.getString("productDesc");
                
                // Construct the image path
                String productImagePath = "img/" + productId + "a.jpg";
    %>
    <tr>
        <td><%= productId %></td>
        <td><%= productName %></td>
        <td>
            <form method="post" action="updateProduct.jsp" style="display: inline;">
                <input type="number" name="price" value="<%= productPrice %>" step="0.01" min="0" required>
        </td>
        <td>
                <textarea name="productDesc" rows="3" style="width: 100%;"><%= productDesc %></textarea>
                <input type="hidden" name="productId" value="<%= productId %>">
        </td>
        <td>
            <img src="<%= productImagePath %>" alt="Product Image" style="width: 80px; height: 80px; object-fit: cover;">
        </td>
        <td>
            <!-- Update button -->
            <button type="submit" class="updatebutton">Update</button>
            </form>

            <!-- Delete button -->
            <form method="post" action="deleteProduct.jsp" style="display: inline;">
                <input type="hidden" name="productId" value="<%= productId %>">
                <button type="button" class="updatebutton" onclick="confirmDelete(<%= productId %>)">Delete</button>
            </form>
        </td>
    </tr>
    <%
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
    %>
    <tr>
        <td colspan="6" class="error">Error: <%= e.getMessage() %></td>
    </tr>
    <%
        }
    %>
</table>

<!-- JavaScript for delete confirmation -->
<script>
    function confirmDelete(productId) {
        if (confirm("Are you sure you want to delete this product?")) {
            // Redirect to deleteProduct.jsp to handle the deletion
            window.location.href = "deleteProduct.jsp?productId=" + productId;
        }
    }
</script>


</body>
</html>
