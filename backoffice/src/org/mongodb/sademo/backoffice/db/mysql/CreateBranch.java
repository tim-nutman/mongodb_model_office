package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class CreateBranch extends HttpServlet {
	
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
		
		// Insert Branch Details
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO branches (name, addressline_1, addressline_2, city, state, postcode, primary_contact" +
				") VALUES (?,?,?,?,?,?,?);");
		preparedStatement.setString(1, request.getParameter("branch_name"));
		preparedStatement.setString(2, request.getParameter("branch_addr1"));
		preparedStatement.setString(3, request.getParameter("branch_addr2"));
		preparedStatement.setString(4, request.getParameter("branch_city"));
		preparedStatement.setString(5, request.getParameter("branch_state"));
		preparedStatement.setString(6, request.getParameter("branch_zip"));
		preparedStatement.setString(7, request.getParameter("branch_primary_contact"));
		preparedStatement.executeUpdate();
		
		//clean up
    		preparedStatement.close();
    		preparedStatement = null;
    		dbUtil.db_close();
    		dbUtil = null;
		
		String redirectString = "v1/pages/branches";
		response.sendRedirect(redirectString);
	}

}

