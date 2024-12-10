<!DOCTYPE html>
<html>
<head>
<title>Sami and Ryan's Grocery Checkout Line</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        color: #000000;
    }

    h1 {
        color: white;
        font-size: 2.5em;
        text-align: center;
        margin-bottom: 20px;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
    }

    form {
        width: 100%;
        max-width: 500px;
        margin: 0 auto;
        padding: 20px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    form div {
        margin-bottom: 15px;
    }

    label {
        display: block;
        font-weight: bold;
        margin-bottom: 5px;
        color: black; 
    }

    input[type="text"], input[type="number"], textarea, select {
        width: 100%;
        padding: 10px;
        font-size: 1em;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

    textarea {
        resize: none;
        height: 80px;
    }

    input[type="submit"], input[type="reset"] {
        padding: 10px 20px;
        font-size: 1.1em;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    input[type="submit"] {
        background-color: #4CAF50;
        color: white;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }

    input[type="reset"] {
        background-color: #f44336;
        color: white;
    }

    input[type="reset"]:hover {
        background-color: #d32f2f;
    }

    a {
        display: block;
        margin-top: 20px;
        text-align: center;
        color: #007bff;
        text-decoration: none;
        font-weight: bold;
    }

    a:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>
    <%@ include file="background.html" %>
    <%@ include file="header.jsp" %>
    <h1>Checkout Information</h1>

    <form method="get" action="order.jsp">
        <div>
            <label for="customerId">Customer ID:</label>
            <input type="text" name="customerId" id="customerId" placeholder="Enter your customer ID" required>
        </div>
        
        <div>
            <label for="paymentMethod">Payment Method:</label>
            <select name="paymentMethod" id="paymentMethod" required>
                <option value="credit">Credit Card</option>
                <option value="debit">Debit Card</option>
            </select>
        </div>
        
        <div>
            <label for="cardNumber">Card Number (if applicable):</label>
            <input type="number" name="cardNumber" id="cardNumber" placeholder="Enter your card number" maxlength="16" 
            minlength="16" pattern="\d{16}" 
            title="Please enter exactly 16 digits" required>
        </div>
        
        <div>
            <label for="shippingAddress">Shipping Address:</label>
            <textarea name="shippingAddress" id="shippingAddress" placeholder="Enter your shipping address" required></textarea>
        </div>
        
        <div style="text-align: center;">
            <input type="submit" value="Complete Checkout">
            <input type="reset" value="Reset Form">
        </div>
    </form>
</body>
</html>
