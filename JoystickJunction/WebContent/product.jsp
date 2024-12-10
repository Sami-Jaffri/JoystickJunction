<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            color: #f1f1f1;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .product-details {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin: 40px 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            background: rgba(0, 0, 0, 0.3)
        }
        .product-image {
            flex: 1 1 50%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .product-image img {
            max-width: 100%;
            max-height: 400px;
            width: auto;
            height: auto;
            object-fit: contain;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }
        .product-info {
            flex: 1 1 50%;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center; 
        }
        .product-info h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            color: #f8f9fa;
        }
        .product-info p {
            font-size: 1.2em;
            line-height: 1.5;
            margin: 10px 0;
        }
        .product-info .price {
            font-size: 1.5em;
            font-weight: bold;
            color: #28a745;
            margin: 20px 0;
        }
        .product-actions {
            display: flex;
            gap: 15px;
        }
        .btn {
            padding: 12px 20px;
            font-size: 1em;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            color: #fff;
            background: linear-gradient(135deg, #007bff, #0056b3);
            transition: transform 0.3s ease, background-color 0.3s ease;
        }
        .btn:hover {
            background: linear-gradient(135deg, #0056b3, #003b80);
            transform: scale(1.05);
        }
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #343a40);
        }
        .btn-secondary:hover {
            background: linear-gradient(135deg, #343a40, #212529);
        }
        .review-form {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }
    
    .reviews-section {
        margin-top: 40px;
        padding: 20px;
        background: rgba(255, 255, 255, 0.1); /* Semi-transparent white */
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        backdrop-filter: blur(10px); /* Frosted glass effect */
        -webkit-backdrop-filter: blur(10px); /* For Safari */
        border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .review-form textarea {
        width: 100%;
        height: 100px;
        margin-bottom: 10px;
        border-radius: 6px;
        padding: 10px;
        font-size: 1em;
        border: 1px solid #ccc;
        background: #fff;
        color: #333;
    }

    .review-form select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 1em;
        background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        color: #333;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    .review-form select:focus {
        border-color: #007bff;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        outline: none;
    }

    .review-form .submitbtn {
        padding: 12px 20px;
        font-size: 1em;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        color: #fff;
        background: linear-gradient(135deg, #007bff, #0056b3);
        transition: transform 0.3s ease, background-color 0.3s ease;
    }

    .review-form .submitbtn:hover {
        background: linear-gradient(135deg, #0056b3, #003b80);
        transform: scale(1.05);
    }
    .star-rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: center;
        gap: 5px;
        margin: 10px 0;
    }

    .star-rating input {
        display: none; /* Hide the radio buttons */
    }

    .star-rating label {
        font-size: 2em;
        color: #ddd;
        cursor: pointer;
        transition: color 0.2s ease-in-out;
    }

    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: #ffc107; /* Highlight stars on hover */
    }

    .star-rating input:checked ~ label {
        color: #ffc107; /* Highlight stars when selected */
    }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="background.html" %>
    <div class="container">
        <%
            String productId = request.getParameter("id");
            if (productId == null || productId.isEmpty()) {
                out.println("<p style='text-align:center; color:red;'>Product ID is missing!</p>");
            } else {
                Connection connection = null;
                try {
                    connection = DriverManager.getConnection(url, uid, pw);

                    // Fetch product details
                    String productQuery = "SELECT productName, productPrice, productDesc, maturity FROM product WHERE productId = ?";
                    String productName = "";
                    double productPrice = 0.0;
                    String productDesc = "";
                    String maturity = "";
                    String productImage = "img/" + productId + "a.jpg";

                    try (PreparedStatement productStmt = connection.prepareStatement(productQuery)) {
                        productStmt.setString(1, productId);
                        ResultSet rs = productStmt.executeQuery();
                        if (rs.next()) {
                            productName = rs.getString("productName");
                            productPrice = rs.getDouble("productPrice");
                            productDesc = rs.getString("productDesc");
                            maturity = rs.getString("maturity"); // Fetch maturity rating
                        } else {
                            out.println("<p style='text-align:center; color:orange;'>Product not found.</p>");
                        }
                    }

                    // Display product details
                    if (!productName.isEmpty()) {
        %>
        <div class="product-details">
            <div class="product-image">
                <img src="<%= productImage %>" alt="<%= productName %>">
            </div>
            <div class="product-info">
                <h1><%= productName %></h1>
                <p><%= productDesc %></p>
                <p><strong>Maturity Rating:</strong> <%= maturity %></p> <!-- Add maturity here -->
                <p class="price">Price: <%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
                <div class="product-actions">
                    <a class="btn" href="<%= "addcart.jsp?id=" + URLEncoder.encode(productId, "UTF-8") + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + URLEncoder.encode(String.valueOf(productPrice), "UTF-8") %>">Add to Cart</a>
                    <a class="btn btn-secondary" href="listprod.jsp">Back to Products</a>
                </div>
            </div>
            

        <div class="reviews-section">
            <h2>Reviews</h2>
            <%
                        String reviewQuery = "SELECT r.reviewComment, r.reviewRating, r.reviewDate, c.firstName "
                                           + "FROM review r "
                                           + "JOIN customer c ON r.customerId = c.customerId "
                                           + "WHERE r.productId = ? ORDER BY r.reviewDate DESC";

                        try (PreparedStatement reviewStmt = connection.prepareStatement(reviewQuery)) {
                            reviewStmt.setInt(1, Integer.parseInt(productId));
                            ResultSet reviewRs = reviewStmt.executeQuery();

                            if (!reviewRs.isBeforeFirst()) {
                                out.println("<p>No reviews yet for this product. Be the first to review!</p>");
                            }

                            while (reviewRs.next()) {
                                String firstName = reviewRs.getString("firstName");
                                String reviewComment = reviewRs.getString("reviewComment");
                                int reviewRating = reviewRs.getInt("reviewRating");
                                Timestamp reviewDate = reviewRs.getTimestamp("reviewDate");
            %>
            <div class="review-item">
                <p><strong><%= firstName %></strong> <em>(<%= reviewDate %>)</em></p>
                <p>Rating: <%= reviewRating %> / 5</p>
                <p><%= reviewComment %></p>
            </div>
            <%
                            }
                        } catch (SQLException e) {
                            out.println("<p>Error fetching reviews: " + e.getMessage() + "</p>");
                        }
            %>

            <% if (session.getAttribute("authenticatedUser") != null) { %>
            <form class="review-form" method="post" action="submitReview.jsp">
                <textarea name="reviewComment" placeholder="Write your review here..." required></textarea>
                <label for="reviewRating">Rating:</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="reviewRating" value="5" required>
                    <label for="star5" title="5 stars">&#9733;</label>
                    <input type="radio" id="star4" name="reviewRating" value="4">
                    <label for="star4" title="4 stars">&#9733;</label>
                    <input type="radio" id="star3" name="reviewRating" value="3">
                    <label for="star3" title="3 stars">&#9733;</label>
                    <input type="radio" id="star2" name="reviewRating" value="2">
                    <label for="star2" title="2 stars">&#9733;</label>
                    <input type="radio" id="star1" name="reviewRating" value="1">
                    <label for="star1" title="1 star">&#9733;</label>
                </div>
                <input type="hidden" name="productId" value="<%= productId %>">
                <button type="submit" class = "submitbtn">Submit Review</button>
            </form>
            <% } else { %>
            <p>You must be logged in to leave a review.</p>
            <% } %>
        </div>
        <% 
                    }
                } catch (SQLException e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (connection != null) {
                        connection.close();
                    }
                }
            }
        %>
    </div>
</body>
</html>