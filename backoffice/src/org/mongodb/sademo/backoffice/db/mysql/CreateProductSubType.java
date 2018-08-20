package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class CreateProductSubType extends HttpServlet {
	
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
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO prod_sub_type (product_sub_type, active, parent_type_ref) VALUES (?,?,?);");
		preparedStatement.setString(1, request.getParameter("product_sub_type"));
		preparedStatement.setInt(2, Integer.parseInt(request.getParameter("active")));
		preparedStatement.setInt(3, Integer.parseInt(request.getParameter("parent_prod_ref")));
		preparedStatement.executeUpdate();
		
		//clean up
    		preparedStatement.close();
    		preparedStatement = null;
    		dbUtil.db_close();
    		dbUtil = null;
		
		String redirectString = "pages/productSubTypes";
		response.sendRedirect(redirectString);
	}

}



