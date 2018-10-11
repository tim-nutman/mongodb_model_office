package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class UpdateCustomer extends HttpServlet {
	
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
		
		// Insert Customer Details - obtain the ID, then insert address details into the database.
		java.sql.Date dobDate = null;
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("UPDATE customer_details SET title = ?, first_name = ?, last_name = ?, middle_names = ?," +
				" date_of_birth = ?, primary_contact = ?, primary_contact_type = ?, secondary_contact = ?, secondary_contact_type = ?, customer_number = ?, active = ?, email = ?, branch_id = ? WHERE cust_id=?;");
		
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
		preparedStatement.setString(6, request.getParameter("cust_primary_contact"));
		preparedStatement.setString(7, request.getParameter("cust_primary_contact_type"));
		preparedStatement.setString(8, request.getParameter("cust_secondary_contact"));
		preparedStatement.setString(9, request.getParameter("cust_secondary_contact_type"));
		preparedStatement.setString(10, request.getParameter("cust_number"));
		
		Boolean active_customer = false;
		
		if (request.getParameter("cust_active").equals("true")) {
			active_customer = true;
		}
		else {
			active_customer = false;
		}
		preparedStatement.setBoolean(11, active_customer);
		
		preparedStatement.setString(12, request.getParameter("cust_email"));
		preparedStatement.setInt(13, Integer.parseInt(request.getParameter("cust_branch_id")));
		preparedStatement.setInt(14, Integer.parseInt(request.getParameter("cust_id")));
		preparedStatement.executeUpdate();
		
    		preparedStatement.close();
    		preparedStatement = null;
    		dbUtil.db_close();
    		dbUtil = null;
		
    		HttpSession session = request.getSession();
        session.setAttribute("cust_id", request.getParameter("cust_id"));
    		
		String redirectString = "v1/pages/viewCustomer";
		response.sendRedirect(redirectString);
	}

}
