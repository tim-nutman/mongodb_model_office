<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date,java.text.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/sql.jsp"%>
<%@ include file="../inc/themeHandler.jsp" %>

<c:set var="now" value="<%=new java.util.Date()%>" />

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>SA DEMO Bullwork Backoffice</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../theme/<c:out value="${theme_name}" />/dist/css/bootstrap.min.css">
    <!-- Font Awesome - local resource -->
    <link rel="stylesheet" href="../theme/<c:out value="${theme_name}" />/dist/css/font-awesome.min.css">
    <!-- Ionicons local rsource -->
    <link rel="stylesheet" href="../theme/<c:out value="${theme_name}" />/dist/css/ionicons.min.css">
    <!-- jvectormap -->
    <link rel="stylesheet" href="../plugins/jvectormap/jquery-jvectormap-1.2.2.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../theme/<c:out value="${theme_name}" />/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../theme/<c:out value="${theme_name}" />/dist/css/skins/_all-skins.min.css">
    <link rel="stylesheet" href="../plugins/datatables/dataTables.bootstrap.css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
    
		<%@ include file="../inc/header.jsp"%>
		<%@ include file="../inc/aside.jsp"%>
      
    	<c:choose>
		<c:when test="${empty param.acc_id}">
			<c:set var="acc_id" value="${sessionScope.acc_id}" />
		</c:when>
		<c:otherwise>
			<c:set var="acc_id" value="${param.acc_id}" />
		</c:otherwise>
	</c:choose>

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->


        <!-- Main content -->
        <section class="content">
        
        <div id="menuTarget1">
          <!-- Info boxes -->

		<div class="row">
			<div class="col-xs-12">
				<form action="../../AddTransaction" method="post" role="form">
					<div class="box box-primary">
					 	<div class="box-header">
		              		<h3 class="box-title">New Transaction : <c:out value="${acc_id}"/></h3>
		            		</div>
		            		<div class="box-body">
		            			<div class="col-md-4">
		            				<div class="form-group">
				            			<label for="payee">Payee</label>
				            			<input type="text" class="form-control" id="payee" name="payee" placeholder="Payee Details">
				            		</div>
				            		<div class="form-group">
				            			<label for="description">Description</label>
				            			<input type="text" class="form-control" id="description" name="description" placeholder="Description">
				            		</div>
		            			</div>
		            			<div class="col-md-4">
		            				<div class="form-group">
				            			<label for="cr_db">CR/DB</label>
				            			<select class="form-control" id="cr_db" name="cr_db">
										<option value="CR">Credit</option>
										<option value="DB">Debit</option>
									</select>
				            		</div>
				            		<div class="form-group">
				            			<label for="trx_type">Type</label>
				            			<select class="form-control" id="trx_type" name="trx_type">
										<option value="SO">Standing Order</option>
										<option value="DD">Direct Debit</option>
										<option value="FP">Faster Payment</option>
										<option value="CW">Cash Withdrawal</option>
										<option value="TR">Transfer</option>
									</select>
				            		</div>
				            		<div class="form-group">
				            			<label for="trx_value">Value</label>
				            			<input type="text" class="form-control" id="trx_value" name="trx_value" placeholder="Amount">
				            		</div>
		            			</div>
		            		</div>
		            		<div class="box-footer">
		            			<input type="hidden" name="acc_id" value="<c:out value="${acc_id}" />" />
		            			<button type="submit" class="btn btn-primary">Post Transaction</button>
		            		</div>
					</div>
				</form>
			</div>
		</div>
          
          <div class="row">
            <div class="col-xs-12">
            <div class="box box-primary">
	            <div class="box-header">
	              <h3 class="box-title">Transactions for : <c:out value="${acc_id}"/></h3>
	            </div>
	            <div class="box-body table-responsive">
	            	<table id="customerlist" class="table table-bordered table-striped">
                    	<thead>
                    		<tr>
                    			<th>ID</th>
                    			<th>Date Received</th>
                    			<th>Date Processed</th>
                    			<th>Payee</th>
                    			<th>Description</th>
                    			<th>Type</th>
                    			<th>CR/DB</th>
                    			<th>Value</th>
                    		</tr>
                   	</thead>
                    	<tbody>
                    		<sql:setDataSource var="trx" driver="com.mysql.jdbc.Driver"
							url="jdbc:mysql://localhost:3306/bullwork_trx" user="root"  password="debezium" />
                    		<sql:query dataSource="${trx}" var="transactions">
                    			SELECT trx_id, trx_value, trx_type, cr_db, payee, description, trx_date_rec, trx_date_pro FROM transactions WHERE acc_id=?;
                    			<sql:param value="${acc_id}" />
                    		</sql:query>
                    		<c:forEach var="trx" items="${transactions.rows}">
                    			<tr>
                    				<td><c:out value="${trx.trx_id}" /></td>
                    				<td><fmt:formatDate type="both" dateStyle="short" value="${trx.trx_date_rec}"/></td>
                    				<td><fmt:formatDate type="both" dateStyle="short" value="${trx.trx_date_pro}"/></td>
                    				<td><c:out value="${trx.payee}" /></td>
                    				<td><c:out value="${trx.description}" /></td>
                    				<td><c:out value="${trx.trx_type}" /></td>
                    				<td><c:out value="${trx.cr_db}" /></td>
                    				<td><c:out value="${trx.trx_value}" /></td>
                    			</tr>
                    		</c:forEach>
                    	</tbody>
                    </table>
	            </div>
            </div>
            </div>
          </div><!-- /.row -->
          
          
          
		</div>
          
        </section><!-- /.content -->
      </div><!-- /.content-wrapper -->
      


      
	<%@ include file="../inc/footer.jsp"%>
	<%@ include file="../inc/control-panel.jsp"%>

    </div><!-- ./wrapper -->

    <!-- jQuery 2.1.4 -->
    <script src="../plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="../theme/<c:out value="${theme_name}" />/dist/js/bootstrap.min.js"></script>
    <script src="../plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="../plugins/datatables/dataTables.bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="../plugins/fastclick/fastclick.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../theme/<c:out value="${theme_name}" />/dist/js/app.min.js"></script>
    <!-- Sparkline -->
    <script src="../plugins/sparkline/jquery.sparkline.min.js"></script>
    <!-- jvectormap -->
    <script src="../plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="../plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- SlimScroll 1.3.0 -->
    <script src="../plugins/slimScroll/jquery.slimscroll.min.js"></script>
    <!-- ChartJS 1.0.1 -->
    <script src="../plugins/chartjs/Chart.min.js"></script>
    
    <script>
	  $(function () {
	    $('#customerlist').DataTable()
	  })
	</script>
    
    <script>

    
      function timeStamp() {
    	// Create a date object with the current time
    	  var now = new Date();

    	// Create an array with the current month, day and time
    	  var date = [ now.getMonth() + 1, now.getDate(), now.getFullYear() ];

    	// Create an array with the current hour, minute and second
    	  var time = [ now.getHours(), now.getMinutes(), now.getSeconds() ];

    	// Determine AM or PM suffix based on the hour
    	  var suffix = ( time[0] < 12 ) ? "AM" : "PM";

    	// Convert hour from military time
    	  time[0] = ( time[0] < 12 ) ? time[0] : time[0] - 12;

    	// If hour is 0, set it to 12
    	  time[0] = time[0] || 12;

    	// If seconds and minutes are less than 10, add a zero
    	  for ( var i = 1; i < 3; i++ ) {
    	    if ( time[i] < 10 ) {
    	      time[i] = "0" + time[i];
    	    }
    	  }

    	// Return the formatted string
    	  return date.join("/") + " " + time.join(":") + " " + suffix;
    	}

    </script>
    
  </body>
</html>
