package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class AddTransaction extends HttpServlet {
	
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

		Calendar calendar = Calendar.getInstance();
	    java.sql.Timestamp receivedTimestampObject = new java.sql.Timestamp(calendar.getTime().getTime());

		PreparedStatement preparedStatement = dbUtil.getPreparedStatementWithSchema("bullwork_trx",
				"INSERT INTO transactions (acc_id, trx_date_rec, trx_date_pro, payee, description, trx_value, trx_type, cr_db) "+
				"VALUES (?,?,?,?,?,?,?,?);");
		
		preparedStatement.setString(1, request.getParameter("acc_id"));
		preparedStatement.setTimestamp(2, receivedTimestampObject);
		preparedStatement.setString(4, request.getParameter("payee"));
		preparedStatement.setString(5, request.getParameter("description"));
		preparedStatement.setFloat(6, Float.parseFloat(request.getParameter("trx_value")));
		preparedStatement.setString(7, request.getParameter("trx_type"));
		preparedStatement.setString(8, request.getParameter("cr_db"));
		
		java.sql.Timestamp processedTimestampObject = new java.sql.Timestamp(calendar.getTime().getTime());
		preparedStatement.setTimestamp(3, processedTimestampObject);
		preparedStatement.executeUpdate();
		
		//clean up
    		preparedStatement.close();
    		
    		//Now to calculate balance information
    		
    		preparedStatement = dbUtil.getPreparedStatement("UPDATE products_held SET total_balance = total_balance + ? WHERE prod_acc_id = ?;");
    		preparedStatement.setFloat(1, Float.parseFloat(request.getParameter("trx_value")));
    		preparedStatement.setString(2, request.getParameter("acc_id"));
    		preparedStatement.executeUpdate();
    		
    		preparedStatement = dbUtil.getPreparedStatement("UPDATE products_held SET available_balance = acc_limit + total_balance WHERE prod_acc_id = ?;");
    		preparedStatement.setString(1, request.getParameter("acc_id"));
    		preparedStatement.executeUpdate();
    		
    		preparedStatement.close();
    		preparedStatement = null;
    		dbUtil.db_close();
    		dbUtil = null;
		
    		HttpSession session = request.getSession();
        session.setAttribute("acc_id", request.getParameter("acc_id"));
            		
        String redirectString = "pages/transactions";
        	response.sendRedirect(redirectString);
	}

}
