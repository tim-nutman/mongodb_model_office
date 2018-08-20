package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class CreateProduct extends HttpServlet {
	
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
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO product_catalog"+
				" (prod_name, prod_desc, prod_type_id, prod_sub_type_id, cr_int_rate, db_int_rate, fee, fee_type, active) VALUES"+
				" (?,?,?,?,?,?,?,?,?);");
		preparedStatement.setString(1, request.getParameter("product_name"));
		preparedStatement.setString(2, request.getParameter("product_desc"));
		preparedStatement.setInt(3, Integer.parseInt(request.getParameter("parent_prod_ref")));
		preparedStatement.setInt(4, Integer.parseInt(request.getParameter("product_sub_type")));
		preparedStatement.setFloat(5, Float.parseFloat(request.getParameter("product_cr_int")));
		System.out.println(Float.parseFloat(request.getParameter("product_cr_int")));
		preparedStatement.setFloat(6, Float.parseFloat(request.getParameter("product_db_int")));
		preparedStatement.setFloat(7, Float.parseFloat(request.getParameter("product_fee_amount")));
		preparedStatement.setString(8, request.getParameter("product_fee_type"));
		preparedStatement.setInt(9, Integer.parseInt(request.getParameter("active")));
		preparedStatement.executeUpdate();
		
		//clean up
    		preparedStatement.close();
    		preparedStatement = null;
    		dbUtil.db_close();
    		dbUtil = null;
		
		String redirectString = "pages/products";
		response.sendRedirect(redirectString);
	}

}


