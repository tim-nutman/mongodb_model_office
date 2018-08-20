<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date,java.text.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/sql.jsp"%>

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
    <link rel="stylesheet" href="../bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome - local resource -->
    <link rel="stylesheet" href="../dist/css/font-awesome.min.css">
    <!-- Ionicons local rsource -->
    <link rel="stylesheet" href="../dist/css/ionicons.min.css">
    <!-- jvectormap -->
    <link rel="stylesheet" href="../plugins/jvectormap/jquery-jvectormap-1.2.2.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../dist/css/skins/_all-skins.min.css">
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
      
      

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->


        <!-- Main content -->
        <section class="content">
        
        <div id="menuTarget1">
          <!-- Info boxes -->

          
          <div class="row">
            <div class="col-xs-12">
            <div class="box box-primary">
	            <div class="box-header">
	              <h3 class="box-title">Branches</h3>
	            </div>
	            <div class="box-body table-responsive">
	            	<table id="customerlist" class="table table-bordered table-striped">
                    	<thead>
                    		<tr>
                    			<th>Name</th>
                    			<th>Address</th>
                    			<th>City</th>
                    			<th>State</th>
                    			<th>Postcode</th>
                    			<th>Manager</th>
                    			<th>Actions</th>
                    		</tr>
                   	</thead>
                    	<tbody>
                    		<sql:query dataSource="${snapshot}" var="branches">
                    			SELECT branch_id, name, addressline_1, addressline_2, city, state, postcode, primary_contact FROM branches;
                    		</sql:query>
                    		<c:forEach var="branch" items="${branches.rows}">
                    			<tr>
                    				<td><c:out value="${branch.name}" /></td>
                    				<td><c:out value="${branch.addressline_1}" /> <c:out value="${branch.addressline_2}" /></td>
                    				<td><c:out value="${branch.city}" /></td>
                    				<td><c:out value="${branch.state}" /></td>
                    				<td><c:out value="${branch.postcode}" /></td>
                    				<td><c:out value="${branch.primary_contact}" /></td>
                    				<td>
                    					<form action="view_branch" method="post">
					                		<input type="hidden" name="branch_id" value="${branch.branch_id}">
								            <button type="submit" class="btn btn-primary btn-sm" data-toggle="tooltip" title="Edit Branch Details">
								            	<i class="fa fa-building"></i>
								            </button>
							            </form>
                    				</td>
                    			</tr>
                    		</c:forEach>
                    	</tbody>
                    </table>
	            </div>
            </div>
            </div>
          </div><!-- /.row -->
          
          <div class="row">
            <div class="col-md-12">
            		<form action="../CreateBranch" method="post" role="form">
		            <div class="box box-primary">
			            <div class="box-header">
			              <h3 class="box-title">Create New Branch</h3>
			            </div>
		            		<div class="box-body">
							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
         										<label for="branch_name">Branch Name</label>
         										<input type="text" class="form-control" id="branch_name" name="branch_name" placeholder="Branch Name">
         									</div>
									<div class="form-group">
         										<label for="branch_addr1">Address Line 1</label>
         										<input type="text" class="form-control" id="branch_addr1" name="branch_addr1" placeholder="Address Line 1">
         									</div>
         									<div class="form-group">
         										<label for="branch_addr2">Address Line 2</label>
         										<input type="text" class="form-control" id="branch_addr2" name="branch_addr2" placeholder="Address Line 2">
         									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
         										<label for="branch_city">City</label>
         										<input type="text" class="form-control" id="branch_city" name="branch_city" placeholder="City">
         									</div>
         									<div class="form-group">
         										<label for="branch_state">State/County</label>
         										<input type="text" class="form-control" id="branch_state" name="branch_state" placeholder="State / County">
         									</div>
									<div class="form-group">
         										<label for="branch_zip">Zip / Post Code</label>
         										<input type="text" class="form-control" id="branch_zip" name="branch_zip" placeholder="Zip / Post Code">
         									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
         										<label for="branch_primary_contact">Primary Branch Contact / Manager</label>
         										<input type="text" class="form-control" id="branch_primary_contact" name="branch_primary_contact" placeholder="Branch's Primary Contact">
         									</div>
								</div>
							</div>
			        		</div>
			        		<div class="box-footer">
			                	<button type="submit" class="btn btn-primary">Create Branch Record</button>
		                	</div>
			        </div>
		        </form>
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
    <script src="../bootstrap/js/bootstrap.min.js"></script>
    <script src="../plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="../plugins/datatables/dataTables.bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="../plugins/fastclick/fastclick.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/app.min.js"></script>
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
    
    //$('#active_contacts').DataTable();
        
    
      function newContactForm(){
			
		$.ajax({
			type: 'POST',
			url: '../ajax/newContactForm.jsp',
			//data: ,
			success: function(data) {
				$('#menuTarget1').html(data);
			}
		});
		
		}
      
      function newUserForm(){
			
  		$.ajax({
  			type: 'POST',
  			url: '../ajax/newUserForm.jsp',
  			//data: ,
  			success: function(data) {
  				$('#menuTarget1').html(data);
  			}
  		});
  		
  		}
      
      function runGlobalSearch(){
			
  		$.ajax({
  			type: 'POST',
  			url: '../ajax/globalSearch.jsp',
  			data: "q="+$('#q').val(),
  			success: function(data) {
  				$('#menuTarget1').html(data);
  				$('#breadcrumbTarget').html('<li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li><li class="active"><a href="#"><i class="fa fa-search"></i> Search</a></li>');
  			}
  		});
  		
  		
  		
  		}
      
      function updateDebugInfo() {
    	  $.ajax({
    			type: 'POST',
    			url: '../ajax/getDebugInfo.jsp',
    			success: function(data) {
    				$('#debugModalBody').html(data);
    			}
    		});
      }
    
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
