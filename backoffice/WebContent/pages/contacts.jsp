<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date,java.text.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/sql.jsp"%>

<!-- ** TO DO ** -->
<!-- Remove member from Org -->
<!-- How to handle dependencies??? ORG Groups -->
<!-- Field validation scripts -->



<!-- Test to see whether we have a valid session -->
<c:if test="${empty sessionScope.u_id}">
    <!-- There is not a user **attribute** in the session -->
    <c:set var="system_msg" value="Your session has expired" scope="session" />
	<c:redirect url="login"/>
</c:if>
                	
<c:set var="now" value="<%=new java.util.Date()%>" />

<!DOCTYPE html>
<html>
	<head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <title>DEMO CRM | Contacts</title>
	    <!-- Tell the browser to be responsive to screen width -->
	    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
	    <!-- Bootstrap 3.3.5 -->
	    <link rel="stylesheet" href="../bootstrap/css/bootstrap.min.css">
	    <!-- Font Awesome - local resource -->
	    <link rel="stylesheet" href="../dist/css/font-awesome.min.css">
	    <!-- Ionicons local rsource -->
	    <link rel="stylesheet" href="../dist/css/ionicons.min.css">
	    <!--<link rel="stylesheet" href="../dist/css/ionicons.min.css">-->
	    <!-- jvectormap -->
	    <link rel="stylesheet" href="../plugins/jvectormap/jquery-jvectormap-1.2.2.css">
	    <link rel="stylesheet" href="../plugins/datatables/dataTables.bootstrap.css">
	    <!-- Theme style -->
	    <link rel="stylesheet" href="../dist/css/AdminLTE.min.css">
	    <!-- AdminLTE Skins. Choose a skin from the css/skins
	         folder instead of downloading all of them to reduce the load. -->
	    <link rel="stylesheet" href="../dist/css/skins/_all-skins.min.css">
		<link rel="icon" href="resources/cropped-Thunderhead_favicon32.png" sizes="32x32">
		<link rel="icon" href="resources/cropped-Thunderhead_favicon192.png" sizes="192x192">
		<link rel="apple-touch-icon-precomposed" href="resources/cropped-Thunderhead_favicon180.png?fit=180,180">
		<meta name="msapplication-TileImage" content="resources/cropped-Thunderhead_favicon270.png?fit=270,270">

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
				<section class="content-header">
 					<h1>Contacts
            			<small>Version 2.0</small>
          			</h1>
					<ol id="breadcrumbTarget" class="breadcrumb">
		            	<li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
		            	<li class="active"><a href="#"><i class="fa fa-group"></i> Contacts</a></li>
					</ol>
        		</section>

				<%@ include file="../inc/debug.jsp"%>

				<!-- If super user then use Active Org for the filter -->
				<!-- If Administrator user then use o_id in session -->
				<!-- If User then use o_id in session -->
				<!-- List out contacts in data table, sort by last viewed by default? -->
				<!-- Add new contact option - standard and customer props -->
				<!-- View Contact with Agent View -->
				
				<c:choose>
					<c:when test="${sessionScope.level == 0 }">
						<c:if test="${not empty sessionScope.active_org}">
							<c:set var="org_id" value="${sessionScope.active_org}" />
						</c:if>
						<c:if test="${empty sessionScope.active_org}">
							<c:set var="org_id" value="${sessionScope.o_id}" />
						</c:if>
					</c:when>
					<c:when test="${sessionScope.level >= 1 }">
						<c:set var="org_id" value="${sessionScope.o_id}" />
					</c:when>
				</c:choose>
				
				<section class="content">
					<div class="row">
						<div class="col-md-12">
							<div class="box box-primary">
								<div class="box-header">
									<h3 class="box-title">Contacts</h3>
								</div>
								<div class="box-body">
									<table id="roleDataTable" class="table table-bordered table-hover">
               							<thead>
               								<tr>
							                 	<th>ID</th>
							                 	<th>Name</th>
							                  	<th>Address 1</th>
							                  	<th>Post/Zip Code</th>
							                  	<th>Date of Birth</th>
							                  	<th>Email</th>
							                  	<th>Actions</th>
               								</tr>
               							</thead>
               							<tbody>
               								<sql:query dataSource="${snapshot}" var="contacts">
												SELECT id, title, fname, lname, addr1, pcode, dob, email, last_viewed FROM contacts WHERE o_id = ? ORDER BY last_viewed ASC;
												<sql:param value="${org_id }" />
											</sql:query>
											
											<c:forEach var="contact" items="${contacts.rows}">
												<tr>
													<td><c:out value="${contact.id}" /></td>
								                  	<td><c:out value="${contact.title}" /> <c:out value="${contact.fname}" /> <c:out value="${contact.lname}" /></td>
									                <td><c:out value="${contact.addr1}" /></td>
									                <td><c:out value="${contact.pcode}" /></td>
									                <td><fmt:formatDate type="date" dateStyle="long" value="${contact.dob}"/></td>
									                <td><c:out value="${contact.email}" /></td>
									                <td>
									                	<form action="view_contact" method="post">
									                		<input type="hidden" name="contact_id" value="${contact.id}">
												            <button type="submit" class="btn btn-primary" data-toggle="tooltip" title="View Contact Record">
												            	<i class="fa fa-binoculars"></i>
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
					<div class="row">
						<div class="col-md-12">
						<form action="../CreateContact" method="post" role="form" enctype="multipart/form-data">
							<div class="box box-solid">
								<div class="nav-tabs-custom">
										<ul class="nav nav-tabs">
											<li class="pull-left header">
												<i class="fa fa-th"></i>
												Add New Contact
											</li>
											<li class="active">
												<a href="#tab_1" data-toggle="tab" aria-expanded="true">Basic Details</a>
											</li>
											<li>
												<a href="#tab_2" data-toggle="tab" aria-expanded="false">Address</a>
											</li>
											<li>
												<a href="#tab_3" data-toggle="tab" aria-expanded="false">Extended</a>
											</li>
										</ul>
										<div class="tab-content">
											
											<div class="tab-pane active" id="tab_1">
										
												<div class="row">
													<div class="col-md-4">
														<div class="form-group">
		            										<label for="contact_title">Title</label>
		            										<select class="form-control" id="contact_title" name="contact_title">
		            											<option value="Mr.">Mr.</option>
		            											<option value="Mrs.">Mrs.</option>
		            											<option value="Miss.">Miss.</option>
		            											<option value="Ms.">Ms.</option>
		            											<option value="Rev.">Rev.</option>
		            											<option value="Dr.">Dr.</option>
		            											<option value="Prof.">Prof.</option>
		            											<option value="NA">NA</option>
		            										</select>
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_fname">First Name</label>
		            										<input type="text" class="form-control" id="contact_fname" name="contact_fname" placeholder="Contact First Name">
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_lname">Last Name</label>
		            										<input type="text" class="form-control" id="contact_lname" name="contact_lname" placeholder="Contact Last Name">
		            									</div>
													</div>
													<div class="col-md-4">
														<div class="form-group">
		            										<label for="contact_mnames">Middle Names</label>
		            										<input type="text" class="form-control" id="contact_mnames" name="contact_mnames" placeholder="Contact Middle Names">
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_dob">Date of Birth</label>
		            										<input type="date" class="form-control" id="contact_dob" name="contact_dob">
		            									</div>
		            									<div class="contact_email">
		            										<label for="user_dname">Email</label>
		            										<input type="text" class="form-control" id="contact_email" name="contact_email" placeholder="Contact Email Address">
		            									</div>
													</div>
													<div class="col-md-4">
														<div class="form-group">
		            										<label for="contact_tel">Telephone</label>
		            										<input type="text" class="form-control" id="contact_tel" name="contact_tel" placeholder="Contact Primary Telephone">
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_mob">Mobile</label>
		            										<input type="text" class="form-control" id="contact_mob" name="contact_mob" placeholder="Contact Mobile Number">
		            									</div>
		            									<div class="form-group">
									                    		<label for="contact_photo">Photo</label>
									                    		<input type="file" class="form-control" id="contact_photo" name="contact_photo" accept=".png">
									                    		<p class="help-block">Upload Contact Image (PNG format only)</p>
								                    		</div>
													</div>
												</div>
											</div>
											<div class="tab-pane" id="tab_2">
												<div class="row">
													<div class="col-md-4">
														<div class="form-group">
		            										<label for="contact_addr1">Address 1</label>
		            										<input type="text" class="form-control" id="contact_addr1" name="contact_addr1" placeholder="Address Line 1">
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_addr2">Address 2</label>
		            										<input type="text" class="form-control" id="contact_addr2" name="contact_addr2" placeholder="Address Line 2">
		            									</div>
													</div>
													<div class="col-md-4">
														<div class="form-group">
		            										<label for="contact_town">Town</label>
		            										<input type="text" class="form-control" id="contact_town" name="contact_town" placeholder="Town">
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_city">City</label>
		            										<input type="text" class="form-control" id="contact_city" name="contact_city" placeholder="City">
		            									</div>
													</div>
													<div class="col-md-4">
														<div class="form-group">
		            										<label for="contact_state">State/County</label>
		            										<input type="text" class="form-control" id="contact_state" name="contact_state" placeholder="State">
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_pcode">Post/Zip Code</label>
		            										<input type="text" class="form-control" id="contact_pcode" name="contact_pcode" placeholder="Post/Zip Code">
		            									</div>
		            									<div class="form-group">
		            										<label for="contact_country">Country</label>
		            										<input type="text" class="form-control" id="contact_country" name="contact_country" placeholder="Country">
		            									</div>
													</div>
												</div>
											</div>
											<div class="tab-pane" id="tab_3">
												<sql:query dataSource="${snapshot}" var="props">
													SELECT id, type, name, list_type, notes FROM ep_defs WHERE o_id = ? AND object = 'CONTACT';
													<sql:param value="${org_id }" />
												</sql:query>
												<table id="roleDataTable" class="table table-bordered table-hover">
													<thead>
														<tr>
															<th>Field Name</th>
															<th>Type</th>
															<th>If list, List Type</th>
															<th>Description</th>
															<th>Value</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach var="prop" items="${props.rows}">
															<tr>
																<td><c:out value="${prop.name}" /></td>
																<td><c:out value="${prop.type}" /></td>
																<td><c:out value="${prop.list_type}" /></td>
																<td><c:out value="${prop.notes}" /></td>
																<td>
																	<div class="form-group">
																		<c:choose>
																			<c:when test="${prop.type == 'INT' or prop.type == 'STRING'}">
																				<input class="form-control" id="extField_<c:out value='${prop.id}' />" name="extField_<c:out value='${prop.id}' />" type="text" />
																			</c:when>
																			<c:when test="${prop.type == 'STRING'}">
																				<input class="form-control" id="extField_<c:out value='${prop.id}' />" name="extField_<c:out value='${prop.id}' />" type="text" />
																			</c:when>
																			<c:when test="${prop.type == 'FLOAT'}">
																				<input class="form-control" id="extField_<c:out value='${prop.id}' />" name="extField_<c:out value='${prop.id}' />" type="text" />
																			</c:when>
																			<c:when test="${prop.type == 'DATE'}">
																				<input class="form-control" id="extField_<c:out value='${prop.id}' />" name="extField_<c:out value='${prop.id}' />" type="date" />
																			</c:when>
																			<c:when test="${prop.type == 'BOOLEAN'}">
																				<select class="form-control" id="extField_<c:out value='${prop.id}' />" name="extField_<c:out value='${prop.id}' />">
																					<option value="0">No</option>
																					<option value="1">Yes</option>
																				</select>
																			</c:when>
																			<c:when test="${prop.type == 'LIST'}">
																				<sql:query dataSource="${snapshot}" var="list_props">
																					SELECT id, dname, value FROM ep_list_item_defs WHERE ep_defs_id = ?;
																					<sql:param value="${prop.id}" />
																				</sql:query>
																				<select class="form-control" id="extField_<c:out value='${prop.id}' />" name="extField_<c:out value='${prop.id}' />">
																					<c:forEach var="list_prop" items="${list_props.rows}">
																						<option value="<c:out value="${list_prop.value}"/>"><c:out value="${list_prop.dname}"/></option>
																					</c:forEach>
																				</select>
																			</c:when>
																		</c:choose>
																	</div>
																</td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</div>
										</div>
									</div>
									<div class="box-footer">
										<input type="hidden" name="org_id" value="${org_id}" >
					                	<button type="submit" class="btn btn-primary">Create</button>
				                	</div>
								</div>
							</form>
						</div>
					</div>
				</section>
				
          	</div><!-- /.content-wrapper -->
 
		<%@ include file="../inc/footer.jsp"%>
		<%@ include file="../inc/control-panel.jsp"%>
	
	</div><!-- ./wrapper -->

    <!-- jQuery 2.1.4 -->
    <script src="../plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="../bootstrap/js/bootstrap.min.js"></script>
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
    <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
    <script src="../dist/js/pages/dashboard2.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../dist/js/demo.js"></script>
     <script src="../plugins/datatables/jquery.dataTables.min.js"></script>
     <script src="../plugins/datatables/dataTables.bootstrap.min.js"></script>

    
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
