<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Sami Jaffri Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
    String orderIdParam = request.getParameter("orderId");
    if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
        out.println("Order ID is required.");
        return;
    }

    int orderId = Integer.parseInt(orderIdParam);

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        con.setAutoCommit(false);

        String validateOrderQuery = "SELECT COUNT(*) AS count FROM ordersummary WHERE orderId = ?";
        try (PreparedStatement validateOrderStmt = con.prepareStatement(validateOrderQuery)) {
            validateOrderStmt.setInt(1, orderId);
            ResultSet validateOrderRs = validateOrderStmt.executeQuery();
            validateOrderRs.next();
            if (validateOrderRs.getInt("count") == 0) {
                out.println("Invalid Order ID.");
                return;
            }
        }

        String retrieveItemsQuery = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
        try (PreparedStatement retrieveItemsStmt = con.prepareStatement(retrieveItemsQuery)) {
            retrieveItemsStmt.setInt(1, orderId);
            ResultSet itemsRs = retrieveItemsStmt.executeQuery();

            String createShipmentQuery = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
            try (PreparedStatement createShipmentStmt = con.prepareStatement(createShipmentQuery, Statement.RETURN_GENERATED_KEYS)) {
                createShipmentStmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                createShipmentStmt.setString(2, "Shipment for Order ID " + orderId);
                createShipmentStmt.setInt(3, 1);
                createShipmentStmt.executeUpdate();
                ResultSet shipmentKeys = createShipmentStmt.getGeneratedKeys();
                shipmentKeys.next();
                int shipmentId = shipmentKeys.getInt(1);

                boolean inventoryAvailable = true;

                while (itemsRs.next()) {
                    int productId = itemsRs.getInt("productId");
                    int quantity = itemsRs.getInt("quantity");

                    String checkInventoryQuery = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = ?";
                    try (PreparedStatement checkInventoryStmt = con.prepareStatement(checkInventoryQuery)) {
                        checkInventoryStmt.setInt(1, productId);
                        checkInventoryStmt.setInt(2, 1);
                        ResultSet inventoryRs = checkInventoryStmt.executeQuery();

                        if (inventoryRs.next()) {
                            int availableQty = inventoryRs.getInt("quantity");
                            if (availableQty < quantity) {
                                inventoryAvailable = false;
                                break;
                            } else {
                                out.println("Ordered product: " + productId + " Qty: " + quantity + 
                                            " Previous inventory: " + availableQty);

                                String updateInventoryQuery = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = ?";
                                try (PreparedStatement updateInventoryStmt = con.prepareStatement(updateInventoryQuery)) {
                                    updateInventoryStmt.setInt(1, quantity);
                                    updateInventoryStmt.setInt(2, productId);
                                    updateInventoryStmt.setInt(3, 1);
                                    updateInventoryStmt.executeUpdate();
                                }

                                int newInventory = availableQty - quantity;
                                out.println(" New inventory: " + newInventory + "<br>");
                            }
                        } else {
                            inventoryAvailable = false;
                            break;
                        }
                    }
                }

                if (!inventoryAvailable) {
                    con.rollback();
                    out.println("Insufficient inventory for one or more items.");
                } else {
                    con.commit();
                    out.println("<h3>Shipment successfully processed.</h3>");
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("An error occurred: " + e.getMessage());
    }
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>
