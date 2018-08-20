package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class CreateCustomer extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        }
        catch (Exception ex) {
            int errorCode = 500;
            if (ex instanceof FileNotFoundException) {
                errorCode = 404;
            }
            response.sendError(errorCode, ex.getMessage());
        }
    }
	
	private void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		
		mySQLDBUtil dbUtil = new mySQLDBUtil();
		Integer customer_id = 0;
		
		// Insert Customer Details - obtain the ID, then insert address details into the database.
		java.sql.Date dobDate = null;
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO customer_details (title, first_name, last_name, middle_names, date_of_birth," +
				" customer_number, active, primary_contact, primary_contact_type, secondary_contact, secondary_contact_type, email) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);");
		preparedStatement.setString(1, request.getParameter("cust_title"));
		preparedStatement.setString(2, request.getParameter("cust_fname"));
		preparedStatement.setString(3, request.getParameter("cust_lname"));
		preparedStatement.setString(4, request.getParameter("cust_mnames"));
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		if (request.getParameter("cust_dob") != null && request.getParameter("cust_dob").length() > 0) {
			Date parsed = format.parse(request.getParameter("cust_dob"));
			dobDate = new java.sql.Date(parsed.getTime());
		}
		preparedStatement.setDate(5, dobDate);
		preparedStatement.setString(6, request.getParameter("cust_number"));
		preparedStatement.setBoolean(7, Boolean.parseBoolean(request.getParameter("cust_active")));
		preparedStatement.setString(8, request.getParameter("cust_primary_contact"));
		preparedStatement.setString(9, request.getParameter("cust_primary_contact_type"));
		preparedStatement.setString(10, request.getParameter("cust_secondary_contact"));
		preparedStatement.setString(11, request.getParameter("cust_secondary_contact_type"));
		preparedStatement.setString(12, request.getParameter("cust_email"));
		preparedStatement.executeUpdate();
		ResultSet resultset = preparedStatement.getGeneratedKeys();
		if (resultset.next()) {
			customer_id = resultset.getInt(1);
		}
		
		// Insert Address Data linking to the customer ID returned above
		
		preparedStatement = dbUtil.getPreparedStatement("INSERT INTO addresses (cust_id, addressline_1, addressline_2, city, state, postcode, address_type" +
		") VALUES (?,?,?,?,?,?,?);");
		preparedStatement.setInt(1, customer_id);
		preparedStatement.setString(2, request.getParameter("cust_addr1"));
		preparedStatement.setString(3, request.getParameter("cust_addr2"));
		preparedStatement.setString(4, request.getParameter("cust_city"));
		preparedStatement.setString(5, request.getParameter("cust_state"));
		preparedStatement.setString(6, request.getParameter("cust_zip"));
		preparedStatement.setString(7, request.getParameter("cust_address_type"));
		preparedStatement.executeUpdate();
		
		//clean up
		resultset.close();
    		resultset = null;
    		preparedStatement.close();
    		preparedStatement = null;
    		dbUtil.db_close();
    		dbUtil = null;
		
		String redirectString = "pages/dashboard";
		response.sendRedirect(redirectString);
	}

}
