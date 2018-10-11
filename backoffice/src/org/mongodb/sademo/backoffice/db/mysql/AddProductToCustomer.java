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
public class AddProductToCustomer extends HttpServlet {
	
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
		java.sql.Date product_opened_date = null;
		
		
		
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO products_held (cust_id, prod_cat_ref, active, opened, acc_status, acc_limit,"+
				" prod_acc_id, total_balance, available_balance) VALUES (?,?,?,?,?,?,?,?,?);");
		
		preparedStatement.setInt(1, Integer.parseInt(request.getParameter("cust_id")));
		preparedStatement.setInt(2, Integer.parseInt(request.getParameter("prd_cat_id")));
		Boolean active_product = false;
		if (request.getParameter("new_prod_active").equals("1")) {
			active_product = true;
		}
		else {
			active_product = false;
		}
		preparedStatement.setBoolean(3, active_product);
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		if (request.getParameter("new_date_opened") != null && request.getParameter("new_date_opened").length() > 0) {
			Date parsed = format.parse(request.getParameter("new_date_opened"));
			product_opened_date = new java.sql.Date(parsed.getTime());
		}
		preparedStatement.setDate(4, product_opened_date);
		preparedStatement.setString(5, request.getParameter("new_prod_status"));
		preparedStatement.setFloat(6, Float.parseFloat(request.getParameter("new_prod_limit")));
		preparedStatement.setString(7, request.getParameter("new_prod_acc_id"));
		preparedStatement.setFloat(8, 0);
		Float available_balance = 0 + Float.parseFloat(request.getParameter("new_prod_limit"));
		System.out.println(available_balance);
		preparedStatement.setFloat(9, available_balance);
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
