package org.mongodb.sademo.backoffice.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
		
		Integer prod_inst_id;
		Integer active;
		String acc_status;
		Float available_balance = (float) 0;
		Float total_balance = (float) 0;
		Float acc_limit = (float) 0;
		String prod_acc_id;
		
		
		mySQLDBUtil dbUtil = new mySQLDBUtil();
		
		Calendar calendar = Calendar.getInstance();
	    java.sql.Timestamp receivedTimestampObject = new java.sql.Timestamp(calendar.getTime().getTime());
		
		PreparedStatement preparedStatement = dbUtil.getPreparedStatement("SELECT prod_inst_id, active, acc_status, available_balance, " +
		"total_balance, acc_limit, prod_acc_id FROM products_held where prod_acc_id = ?;");
		preparedStatement.setString(1, request.getParameter("acc_id"));
		preparedStatement.execute();
		ResultSet resultSet = preparedStatement.getResultSet();
		// read values into local variables:
		if (resultSet.next()) {
			prod_inst_id = resultSet.getInt("prod_inst_id");
			active = resultSet.getInt("active");
			acc_status = resultSet.getString("acc_status");
			available_balance = resultSet.getFloat("available_balance");
			total_balance = resultSet.getFloat("total_balance");
			acc_limit = resultSet.getFloat("acc_limit");
			prod_acc_id = resultSet.getString("prod_acc_id");
		}
		else {
			System.out.println("ERROR: Attempting to process transaction for invalid account reference (NULL/UNDEFINED or NOT FOUND): Value received: " + request.getParameter("acc_id"));
		}
		
		
		System.out.println("cr_db value = " + request.getParameter("cr_db") + ", available balance = " + available_balance + ", trx_value = " + request.getParameter("trx_value"));
		
		if ((request.getParameter("cr_db").equalsIgnoreCase("DB")) &&  (available_balance - Float.parseFloat(request.getParameter("trx_value")) < 0)){
			// Not enough funds available - send an error flag back to the client and abort all operations
			System.out.println("ERROR: Not enough funds");
		}
		else {
			preparedStatement = dbUtil.getPreparedStatementWithSchema("bullwork_trx",
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
	    		
	    		if (request.getParameter("cr_db").equalsIgnoreCase("DB")) {
	    			total_balance = total_balance - Float.parseFloat(request.getParameter("trx_value"));
	    		}
	    		else if (request.getParameter("cr_db").equalsIgnoreCase("CR")) {
	    			total_balance = total_balance + Float.parseFloat(request.getParameter("trx_value"));
	    		}
	    		else {
	    			System.out.println("ERROR: Undefined or Invalid Transaction type encounterd: " + request.getParameter("cr_db"));
	    		}
	    		
	    		available_balance = total_balance + acc_limit;
	    		
	    		preparedStatement = dbUtil.getPreparedStatement("UPDATE products_held SET total_balance = ?, available_balance = ? WHERE prod_acc_id = ?;");
	    		preparedStatement.setFloat(1, total_balance);
	    		preparedStatement.setFloat(2, available_balance);
	    		preparedStatement.setString(3, request.getParameter("acc_id"));
	    		preparedStatement.executeUpdate();
	    		 		
	    		preparedStatement.close();
	    		preparedStatement = null;
	    		dbUtil.db_close();
	    		dbUtil = null;
		}
    		
    		// Need to pass back a flag in the session for success/failure.
		
    		HttpSession session = request.getSession();
        session.setAttribute("acc_id", request.getParameter("acc_id"));
            		
        String redirectString = "v1/pages/transactions";
        	response.sendRedirect(redirectString);
	}

}
