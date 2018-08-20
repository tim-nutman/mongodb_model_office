package org.mongodb.sademo.backoffice.db.mysql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;


public class mySQLDBUtil {

	private String connectionURL = "jdbc:mysql://localhost:3306/";
	private String schema = "bullwork_core_accs";
	private String userName = "root";
	private String pWord = "debezium";
	private Connection connect = null;
    private Statement statement = null;
    private PreparedStatement preparedStatement = null;
    private ResultSet resultSet = null;

	public ResultSet getResultSet(String sqlString) throws Exception {
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			connect = DriverManager.getConnection(connectionURL,userName,pWord);
			statement = connect.createStatement();
			resultSet = statement.executeQuery(sqlString);
			return resultSet;
		}
		catch (Exception e) {
			throw e;
		}
		finally {

		}
	}
	
	public PreparedStatement getPreparedStatementWithSchema(String schemaName, String sqlString) throws Exception {
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			connect = DriverManager.getConnection(connectionURL+schemaName,userName,pWord);
			preparedStatement = connect.prepareStatement(sqlString, Statement.RETURN_GENERATED_KEYS);
			return preparedStatement;
		}
		catch (Exception e){
			throw e;
		}
		finally {
			
		}
		
	}
	
	public PreparedStatement getPreparedStatement(String sqlString) throws Exception {
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			connect = DriverManager.getConnection(connectionURL+schema,userName,pWord);
			preparedStatement = connect.prepareStatement(sqlString, Statement.RETURN_GENERATED_KEYS);
			return preparedStatement;
		}
		catch (Exception e){
			throw e;
		}
		finally {
			
		}
		
	}
	

   public void db_close() {
	        try {
	          if (resultSet != null) {
	            resultSet.close();
	          }

	          if (statement != null) {
	            statement.close();
	          }

	          if (connect != null) {
	            connect.close();
	          }
	        } catch (Exception e) {

	        }

	    }
	
}

