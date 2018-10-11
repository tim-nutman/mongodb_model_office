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
     
      
      <!-- Page requires either param.cust_id or sessionScope.cust_id / -->
      <!-- Test for presence of param.cust_id first, if empty/null then use session variable -->
      
      <c:choose>
		<c:when test="${empty param.cust_id}">
			<c:set var="customer_id" value="${sessionScope.cust_id}" />
		</c:when>
		<c:otherwise>
			<c:set var="customer_id" value="${param.cust_id}" />
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
            <div class="col-md-12">
	            <div class="box box-primary">
		            <div class="box-header">
		            		<i class="fa fa-user"></i>
		            		<h3 class="box-title">Customers Details</h3>
		            </div>
	            		<div class="nav-tabs-custom">
		            		<ul class="nav nav-tabs">
							<li class="active">
								<a href="#tab_0" data-toggle="tab" aria-expanded="true">Personal Details</a>
							</li>
							<sql:query dataSource="${snapshot}" var="cust_addresses">
                   					SELECT address_id, addressline_1, addressline_2, city, state, postcode, address_type FROM addresses WHERE cust_id=?;
                   					<sql:param value="${customer_id}" />
                   				</sql:query>
                   				<c:forEach var="cust_address" items="${cust_addresses.rows}">
                   					<li>
									<a href="#tab_<c:out value="${cust_address.address_id}"/>" data-toggle="tab" aria-expanded="false">Address Details: <c:out value="${cust_address.address_type}" /></a>
								</li>
                   				</c:forEach>
                   				<li>
                   					<a href="#tab_x" data-toggle="tab" aria-expanded="true">Add New Address</a>
                   				</li>
						</ul>
			            <div class="tab-content">
			            		<div class="tab-pane active" id="tab_0">
			            			<div class="row">
			            				<form action="../../UpdateCustomer" method="post" role="form">
			            					<sql:query dataSource="${snapshot}" var="active_customers">
                    							SELECT customer_number, title, first_name, last_name, middle_names, date_of_birth, email, branch_id, primary_contact, primary_contact_type, secondary_contact, secondary_contact_type, active FROM customer_details WHERE cust_id=?;
                    							<sql:param value="${customer_id}" />
                    						</sql:query>
                    						<c:forEach var="cust_details" items="${active_customers.rows}">
				            				<div class="col-md-4">
				            					<div class="form-group">
	        										<label for="cust_title">Title</label>
	        										<select class="form-control" id="cust_title" name="cust_title">
	        											<option value="Mr" <c:if test="${cust_details.title == 'Mr' }">selected</c:if> >Mr.</option>
	        											<option value="Mrs" <c:if test="${cust_details.title == 'Mrs' }">selected</c:if> >Mrs.</option>
	        											<option value="Miss" <c:if test="${cust_details.title == 'Miss' }">selected</c:if> >Miss.</option>
	        											<option value="Ms" <c:if test="${cust_details.title == 'Ms' }">selected</c:if> >Ms.</option>
	        											<option value="Rev" <c:if test="${cust_details.title == 'Rev' }">selected</c:if> >Rev.</option>
	        											<option value="Dr" <c:if test="${cust_details.title == 'Dr' }">selected</c:if> >Dr.</option>
	        											<option value="Prof" <c:if test="${cust_details.title == 'Prof' }">selected</c:if> >Prof.</option>
	        											<option value="NA" <c:if test="${cust_details.title == 'NA' }">selected</c:if> >NA</option>
	        										</select>
		            							</div>
		            							<div class="form-group">
	       										<label for="cust_fname">First Name</label>
	       										<input type="text" class="form-control" id="cust_fname" name="cust_fname" placeholder="Customer's First Name" value="<c:out value="${cust_details.first_name}" />">
	       									</div>
	       									<div class="form-group">
	       										<label for="cust_lname">Last Name</label>
	       										<input type="text" class="form-control" id="cust_lname" name="cust_lname" placeholder="Customer's Last Name" value="<c:out value="${cust_details.last_name}" />">
	       									</div>
	       									<div class="form-group">
	        										<label for="cust_mnames">Middle Names</label>
	        										<input type="text" class="form-control" id="cust_mnames" name="cust_mnames" placeholder="Customer's Middle Names" value="<c:out value="${cust_details.middle_names}" />">
	        									</div>
	        									<div class="form-group">
	        										<label for="cust_dob">Date of Birth</label>
	        										<input type="date" class="form-control" id="cust_dob" name="cust_dob" value="<fmt:formatDate pattern = "yyyy-MM-dd" value="${cust_details.date_of_birth}"/>">
	        									</div>
										</div>
										<div class="col-md-4">
	        									<div class="form-group">
	        										<label for="cust_email">Email</label>
	        										<input type="text" class="form-control" id="cust_email" name="cust_email" placeholder="Customer's Email Address" value="<c:out value="${cust_details.email}" />">
	        									</div>
	        									<div class="form-group">
           										<label for="cust_primary_contact">Primary Contact</label>
           										<input type="text" class="form-control" id="cust_primary_contact" name="cust_primary_contact" placeholder="Customer's Primary Contact" value="<c:out value="${cust_details.primary_contact}" />">
           									</div>
           									<div class="form-group">
	        										<label for="cust_primary_contact_type">Primary Contact Type</label>
	        										<select class="form-control" id="cust_primary_contact_type" name="cust_primary_contact_type">
	        											<option value="Home Telephone" <c:if test="${cust_details.primary_contact_type == 'Home Telephone' }">selected</c:if> >Home Telephone</option>
	        											<option value="Mobile Telephone" <c:if test="${cust_details.primary_contact_type == 'Mobile Telephone' }">selected</c:if> >Mobile Telephone</option>
	        											<option value="Business Telephone" <c:if test="${cust_details.primary_contact_type == 'Business Telephone' }">selected</c:if> >Business Telephone</option>
	        											<option value="Fax" <c:if test="${cust_details.primary_contact_type == 'Fax' }">selected</c:if> >Fax</option>
	        											<option value="Other" <c:if test="${cust_details.primary_contact_type == 'Other' }">selected</c:if> >Other</option>
	        										</select>
        										</div>
        										<div class="form-group">
           										<label for="cust_secondary_contact">Secondary Contact</label>
           										<input type="text" class="form-control" id="cust_secondary_contact" name="cust_secondary_contact" placeholder="Customer's Secondary Contact" value="<c:out value="${cust_details.secondary_contact}" />">
           									</div>
           									<div class="form-group">
	        										<label for="cust_secondary_contact_type">Secondary Contact Type</label>
	        										<select class="form-control" id="cust_secondary_contact_type" name="cust_secondary_contact_type">
	        											<option value="Home Telephone" <c:if test="${cust_details.secondary_contact_type == 'Home Telephone' }">selected</c:if> >Home Telephone</option>
	        											<option value="Mobile Telephone" <c:if test="${cust_details.secondary_contact_type == 'Mobile Telephone' }">selected</c:if> >Mobile Telephone</option>
	        											<option value="Business Telephone" <c:if test="${cust_details.secondary_contact_type == 'Business Telephone' }">selected</c:if> >Business Telephone</option>
	        											<option value="Fax" <c:if test="${cust_details.secondary_contact_type == 'Fax' }">selected</c:if> >Fax</option>
	        											<option value="Other" <c:if test="${cust_details.secondary_contact_type == 'Other' }">selected</c:if> >Other</option>
	        										</select>
        										</div>
				            				</div>
				            				<div class="col-md-4">
											<div class="form-group">
	       										<label for="cust_number">Customer Number</label>
	       										<input type="text" class="form-control" id="cust_number" name="cust_number" placeholder="Customer Number" value="<c:out value="${cust_details.customer_number}" />">
	       									</div>
	       									<div class="form-group">
	       										<label for="cust_active">Customer Active/Dormant</label>
	       										<select class="form-control" id="cust_active" name="cust_active">
	        											<option value="true" <c:if test="${cust_details.active == 1 }">selected</c:if> >Active</option>
	        											<option value="false" <c:if test="${cust_details.active == 0 }">selected</c:if> >Dormant</option>
	        										</select>
	       									</div>
	       									<div class="form-group">
	       										<label for="branch_id">Branch</label>
	       										<select class="form-control" id="branch_id" name="cust_branch_id">
	       											<sql:query dataSource="${snapshot}" var="branches">
                    										SELECT branch_id, name, postcode FROM branches;
                    									</sql:query>
		       										<c:forEach var="branch" items="${branches.rows}">
		       											<option value="<c:out value="${branch.branch_id}" />" <c:if test="${cust_details.branch_id == branch.branch_id}">selected</c:if> ><c:out value="${branch.name}" />, <c:out value="${branch.postcode}" /></option>
		       										</c:forEach>
		       									</select>
	       									</div>
	       									<div class="form-group">
	       										<input type="hidden" name="cust_id" value="<c:out value="${customer_id}" />" />
	       										<button id="update_general_details" type="submit" class="btn btn-primary">Update General Details</button>
	       									</div>
										</div>
										</c:forEach>
									</form>
			            			</div>
			            		</div>
			            		<c:forEach var="cust_address" items="${cust_addresses.rows}">
				            		<div class="tab-pane" id="tab_<c:out value="${cust_address.address_id}"/>">
									<div class="row">
										<form id="addressFrm_<c:out value="${cust_address.address_id}"/>" action="../../UpdateAddress" method="post" role="form">
											<div class="col-md-4">
												<div class="form-group">
	           										<label for="cust_addr1">Address Line 1</label>
	           										<input type="text" class="form-control" id="cust_addr1" name="cust_addr1" placeholder="Address Line 1" value="<c:out value="${cust_address.addressline_1}" />">
	           									</div>
	           									<div class="form-group">
	           										<label for="cust_addr2">Address Line 2</label>
	           										<input type="text" class="form-control" id="cust_addr2" name="cust_addr2" placeholder="Address Line 2" value="<c:out value="${cust_address.addressline_2}" />">
	           									</div>
	           									<div class="form-group">
	           										<label for="cust_city">City</label>
	           										<input type="text" class="form-control" id="cust_city" name="cust_city" placeholder="City" value="<c:out value="${cust_address.city}" />">
	           									</div>
	           									<div class="form-group">
	           										<label for="cust_state">State/County</label>
	           										<input type="text" class="form-control" id="cust_state" name="cust_state" placeholder="State / County"  value="<c:out value="${cust_address.state}" />">
	           									</div>
											</div>
											<div class="col-md-4">
												<div class="form-group">
	           										<label for="cust_zip">Zip / Post Code</label>
	           										<input type="text" class="form-control" id="cust_zip" name="cust_zip" placeholder="Zip / Post Code" value="<c:out value="${cust_address.postcode}" />">
	           									</div>
	           									<div class="form-group">
	           										<label for="cust_address_type">Address Type</label>
	           										<select class="form-control" id="cust_address_type" name="cust_address_type">
	            											<option value="Home" <c:if test="${cust_address.address_type == 'Home' }">selected</c:if> >Home</option>
	            											<option value="Postal" <c:if test="${cust_address.address_type == 'Postal' }">selected</c:if> >Postal</option>
	            											<option value="Business" <c:if test="${cust_address.address_type == 'Business' }">selected</c:if> >Business</option>
	            											<option value="Other" <c:if test="${cust_address.address_type == 'Other' }">selected</c:if> >Other</option>
	            										</select>
	           									</div>
											</div>
											<div class="col-md-4">
	        										<div class="form-group">
	        											<input type="hidden" name="address_id" value="<c:out value="${cust_address.address_id}" />" />
	        											<input type="hidden" name="cust_id" value="<c:out value="${customer_id}" />" />
		       										<button type="submit" class="btn btn-primary">Update Address Details</button>
		       									</div>
											</div>
										</form>
									</div>
								</div>
							</c:forEach>
							<div class="tab-pane" id="tab_x">
								<div class="row">
									<form action="../../AddAddressToCustomer" method="post" role="form">
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
	     										<input type="hidden" name="cust_id" value="<c:out value="${customer_id}" />" />
		       									<button type="submit" class="btn btn-primary">Add New Address Details</button>
		       								</div>
										</div>
									</form>
								</div>
							</div>
						</div>
		        		</div>
		        </div>
	        </div>
          </div><!-- /.row -->
          
		<div class="row">
            <div class="col-md-12">
	            <div class="box box-primary">
		            <div class="box-header">
		            		<i class="fa fa-money"></i>
		            		<h3 class="box-title">Products Held</h3>
		            		<div class="box-body table-responsive">
	            				<table id="customerlist" class="table table-bordered table-striped">
                    				<thead>
			                    		<tr>
			                    			<th>Account No.</th>
			                    			<th>Product</th>
			                    			<th>Current Balance</th>
			                    			<th>Available Balance</th>
			                    			<th>Limit</th>
			                    			<th>Status</th>
			                    			<th>Actions</th>
			                    		</tr>
			                   	</thead>
                    				<tbody>
                    					<sql:query dataSource="${snapshot}" var="productsHeld">
              							SELECT prod_acc_id, prod_name, total_balance, available_balance, acc_limit, acc_status FROM products_held_with_details WHERE cust_id=?;
              							<sql:param value="${customer_id}" />
               						</sql:query>
               						<c:forEach var="productHeld" items="${productsHeld.rows}">
               							<tr>
               								<td><c:out value="${productHeld.prod_acc_id}" /></td>
               								<td><c:out value="${productHeld.prod_name}" /></td>
               								<td><c:out value="${productHeld.total_balance}" /></td>
               								<td><c:out value="${productHeld.available_balance}" /></td>
               								<td><c:out value="${productHeld.acc_limit}" /></td>
               								<td><c:out value="${productHeld.acc_status}" /></td>
               								<td>
               									<form action="transactions" method="post">
								                		<input type="hidden" name="acc_id" value="<c:out value="${productHeld.prod_acc_id}" />">
										            <button type="submit" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View/Add Transactions">
										            		<c:choose>
											            		<c:when test="${theme_name == '386'}">
											            			View/Add Trx
											            		</c:when>
											            		<c:otherwise>
											            			<i class="fa fa-money"></i>
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
	     </div>
	  </div>
	  
	  <div class="row">
            <div class="col-md-12">
	            <div class="box box-primary">
		            <div class="box-header">
		            		<i class="fa fa-money"></i>
		            		<h3 class="box-title">Add New Products</h3>
		            </div>
		            <form action="../../AddProductToCustomer" method="post" role="form">
			            <div class="box-body">
				            	<div class="col-md-4">
				            		<div class="form-group">
				            			<label for="prod_type_id">Product Category</label>
				            			<select class="form-control" id="prod_type_id" name="prod_type_id" onchange="getProductSubTypes()">
				            				<option value="NaN" selected>Please select a product category...</option>
				            				<sql:query dataSource="${snapshot}" var="productTypes">
              								SELECT prd_type_id, product_type FROM prod_type;
               							</sql:query>
               							<c:forEach var="productType" items="${productTypes.rows}">
               								<option value="<c:out value="${productType.prd_type_id}" />"><c:out value="${productType.product_type}" /></option>
               							</c:forEach>
				            			</select>
				            		</div>
				            		<div class="form-group">
				            			<label for="prod_sub_type_id">Product Sub Category</label>
				            			<div id="newProductFrmSubTypeSelectList"></div>
				            		</div>
				            		<div class="form-group">
				            			<label for="prd_cat_id">Product</label>
				            			<div id="newProductList"></div>
				            		</div>
				            	</div>
				            	<div id="newProductDetails"></div>
			            </div>
			            <div class="box-footer">
			            </div>
		            </form>
	           </div>
	     </div>
	  </div>
          
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
       
       function getProductSubTypes() {
			
			$.ajax({
				type: 'POST',
				url: '../ajax/getProductDetailsUtility.jsp',
				data: "fnc=getSubTypesCustomer&prd_type_id="+$('#prod_type_id').val(),
				success: function(data) {
					$('#newProductFrmSubTypeSelectList').html(data);
				}
			});
		}
       
       function getProductList() {
			
			$.ajax({
				type: 'POST',
				url: '../ajax/getProductDetailsUtility.jsp',
				data: 'fnc=getProductList&prod_sub_type_id='+$('#prod_sub_type_id').val(),
				success: function(data) {
					$('#newProductList').html(data);
				}
			});
			
		}
		
		function getProductDetails() {
			
			$.ajax({
				type: 'POST',
				url: '../ajax/getProductDetailsUtility.jsp',
				data: 'fnc=getProductDetailsWithForm&prd_cat_id='+$('#prd_cat_id').val()+'&customer_id=<c:out value="${customer_id}"/>',
				success: function(data) {
					$('#newProductDetails').html(data);
				}
			});
			
		}
		
		function CheckAccNumber() {
			$.ajax({
				type: 'POST',
				url: '../ajax/checkAccNumber.jsp',
				data: 'newAccId='+$('#new_prod_acc_id').val(),
				success: function(data) {
					$('#newAccIdCheckResult').html(data);
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
