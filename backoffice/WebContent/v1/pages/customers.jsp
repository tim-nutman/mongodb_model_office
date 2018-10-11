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
	              <h3 class="box-title">Active Customers</h3>
	            </div>
	            <div class="box-body table-responsive">
	            	<table id="customerlist" class="table table-bordered table-striped">
                    	<thead>
                    		<tr>
                    			<th>Customer Number</th>
                    			<th>Name</th>
                    			<th>Date of Birth</th>
                    			<th>Email</th>
                    			<th>Branch</th>
                    			<th>Actions</th>
                    		</tr>
                   	</thead>
                    	<tbody>
                    		<sql:query dataSource="${snapshot}" var="active_customers">
                    			SELECT cust_id, customer_number, title, first_name, last_name, date_of_birth, email, branch_id FROM customer_details;
                    		</sql:query>
                    		<c:forEach var="customer" items="${active_customers.rows}">
                    			<tr>
                    				<td><c:out value="${customer.customer_number}" /></td>
                    				<td><c:out value="${customer.tite}" /> <c:out value="${customer.first_name}" /> <c:out value="${customer.last_name}" /></td>
                    				<td><fmt:formatDate type="date" dateStyle="long" value="${customer.date_of_birth}"/></td>
                    				<td><c:out value="${customer.email}" /></td>
                    				<td>
                    					<sql:query dataSource="${snapshot}" var="branch_details">
                    						SELECT branch_id, name FROM branches WHERE branch_id = ?;
                    						<sql:param value="${customer.branch_id}" />
			                    		</sql:query>
                    					<c:forEach var="branch" items="${branch_details.rows}">
                    						<c:out value="${branch.branch_id}" />, <c:out value="${branch.name}" />
                    					</c:forEach>
                    				</td>
                    				<td>
                    					<form action="viewCustomer" method="post">
					                		<input type="hidden" name="cust_id" value="${customer.cust_id}">
							            <button type="submit" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View/Edit Customer Record">
								            <c:choose>
								            		<c:when test="${theme_name == '386'}">
								            			Edit
								            		</c:when>
								            		<c:otherwise>
								            			<i class="fa fa-user"></i>
								            		</c:otherwise>
								            </c:choose>
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
            		<form action="../../CreateCustomer" method="post" role="form">
		            <div class="box box-primary">
		            		<div class="nav-tabs-custom">
			            		<ul class="nav nav-tabs">
								<li class="pull-left header">
									<i class="fa fa-user"></i>
									Add New Customer
								</li>
								<li class="active">
									<a href="#tab_1" data-toggle="tab" aria-expanded="true">Contact Details</a>
								</li>
								<li>
									<a href="#tab_2" data-toggle="tab" aria-expanded="false">Additional Details</a>
								</li>
							</ul>
				            <div class="tab-content">
				            		<div class="tab-pane active" id="tab_1">
				            			<div class="row">
				            				<div class="col-md-4">
				            					<div class="form-group">
            										<label for="cust_title">Title</label>
            										<select class="form-control" id="cust_title" name="cust_title">
            											<option selected value="Mr">Mr.</option>
            											<option value="Mrs">Mrs.</option>
            											<option value="Miss">Miss.</option>
            											<option value="Ms">Ms.</option>
            											<option value="Rev">Rev.</option>
            											<option value="Dr">Dr.</option>
            											<option value="Prof">Prof.</option>
            											<option value="NA">NA</option>
            										</select>
		            							</div>
		            							<div class="form-group">
            										<label for="cust_fname">First Name</label>
            										<input type="text" class="form-control" id="cust_fname" name="cust_fname" placeholder="Customer's First Name">
            									</div>
            									<div class="form-group">
            										<label for="cust_lname">Last Name</label>
            										<input type="text" class="form-control" id="cust_lname" name="cust_lname" placeholder="Customer's Last Name">
            									</div>
										</div>
										<div class="col-md-4">
											<div class="form-group">
            										<label for="cust_mnames">Middle Names</label>
            										<input type="text" class="form-control" id="cust_mnames" name="cust_mnames" placeholder="Customer's Middle Names">
            									</div>
            									<div class="form-group">
            										<label for="cust_dob">Date of Birth</label>
            										<input type="date" class="form-control" id="cust_dob" name="cust_dob">
            									</div>
            									<div class="form-group">
            										<label for="cust_email">Email</label>
            										<input type="text" class="form-control" id="cust_email" name="cust_email" placeholder="Customer's Email Address">
            									</div>
				            				</div>
				            				<div class="col-md-4">
											<div class="form-group">
           										<label for="cust_number">Customer Number</label>
           										<input type="text" class="form-control" id="cust_number" name="cust_number" placeholder="Customer Number">
           									</div>
           									<div class="form-group">
           										<label for="cust_active">Customer Active/Dormant</label>
           										<select class="form-control" id="cust_active" name="cust_active">
            											<option value="true" selected>Active</option>
            											<option value="false">Dormant</option>
            										</select>
           									</div>
										</div>
				            			</div>
				            		</div>
				            		<div class="tab-pane" id="tab_2">
									<div class="row">
										<div class="col-md-4">
											<div class="form-group">
           										<label for="cust_addr1">Address Line 1</label>
           										<input type="text" class="form-control" id="cust_addr1" name="cust_addr1" placeholder="Address Line 1">
           									</div>
           									<div class="form-group">
           										<label for="cust_addr2">Address Line 2</label>
           										<input type="text" class="form-control" id="cust_addr2" name="cust_addr2" placeholder="Address Line 2">
           									</div>
           									<div class="form-group">
           										<label for="cust_city">City</label>
           										<input type="text" class="form-control" id="cust_city" name="cust_city" placeholder="City">
           									</div>
           									<div class="form-group">
           										<label for="cust_state">State/County</label>
           										<input type="text" class="form-control" id="cust_state" name="cust_state" placeholder="State / County">
           									</div>
										</div>
										<div class="col-md-4">
											<div class="form-group">
           										<label for="cust_zip">Zip / Post Code</label>
           										<input type="text" class="form-control" id="cust_zip" name="cust_zip" placeholder="Zip / Post Code">
           									</div>
           									<div class="form-group">
           										<label for="cust_address_type">Address Type</label>
           										<select class="form-control" id="cust_address_type" name="cust_address_type">
            											<option value="Home" selected>Home</option>
            											<option value="Postal">Postal</option>
            											<option value="Business">Business</option>
            											<option value="Other">Other</option>
            										</select>
           									</div>
										</div>
										<div class="col-md-4">
											<div class="form-group">
           										<label for="cust_primary_contact">Primary Contact</label>
           										<input type="text" class="form-control" id="cust_primary_contact" name="cust_primary_contact" placeholder="Customer's Primary Contact">
           									</div>
           									<div class="form-group">
	        										<label for="cust_primary_contact_type">Primary Contact Type</label>
	        										<select class="form-control" id="cust_primary_contact_type" name="cust_primary_contact_type">
	        											<option value="Home Telephone" selected>Home Telephone</option>
	        											<option value="Mobile Telephone">Mobile Telephone</option>
	        											<option value="Business Telephone">Business Telephone</option>
	        											<option value="Fax">Fax</option>
	        											<option value="Other">Other</option>
	        										</select>
        										</div>
        										<div class="form-group">
           										<label for="cust_secondary_contact">Secondary Contact</label>
           										<input type="text" class="form-control" id="cust_secondary_contact" name="cust_secondary_contact" placeholder="Customer's Secondary Contact">
           									</div>
           									<div class="form-group">
	        										<label for="cust_secondary_contact_type">Secondary Contact Type</label>
	        										<select class="form-control" id="cust_secondary_contact_type" name="cust_secondary_contact_type">
	        											<option value="Home Telephone" selected>Home Telephone</option>
	        											<option value="Mobile Telephone">Mobile Telephone</option>
	        											<option value="Business Telephone">Business Telephone</option>
	        											<option value="Fax">Fax</option>
	        											<option value="Other">Other</option>
	        										</select>
        										</div>
										</div>
									</div>
								</div>
				            </div>
			        		</div>
			        		<div class="box-footer">
			                	<button type="submit" class="btn btn-primary">Create Customer Record</button>
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
