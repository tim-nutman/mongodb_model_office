package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class UpdateAddress extends HttpServlet {
	
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
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("UPDATE addresses SET addressline_1 = ?, addressline_2 = ?, city = ?, state = ?, postcode = ?," +
				" address_type = ? WHERE address_id = ?;");

		preparedStatement.setString(1, request.getParameter("cust_addr1"));
		preparedStatement.setString(2, request.getParameter("cust_addr2"));
		preparedStatement.setString(3, request.getParameter("cust_city"));
		preparedStatement.setString(4, request.getParameter("cust_state"));
		preparedStatement.setString(5, request.getParameter("cust_zip"));
		preparedStatement.setString(6, request.getParameter("cust_address_type"));
		preparedStatement.setInt(7, Integer.parseInt(request.getParameter("address_id")));
		preparedStatement.executeUpdate();
		
		//clean up
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
