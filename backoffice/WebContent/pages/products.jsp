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
	              <h3 class="box-title">Product Catalogue</h3>
	            </div>
	            <div class="box-body table-responsive">
	            	<table id="customerlist" class="table table-bordered table-striped">
                    	<thead>
                    		<tr>
                    			<th>Product ID</th>
                    		    <th>Product Name</th>
                    			<th>Product Catalog Type</th>
                    			<th>Credit Interest Rate</th>
                    			<th>Debit Interest Rate</th>
                    			<th>Active</th>
                    			<th>Actions</th>
                    		</tr>
                   	</thead>
                    	<tbody>
                    		<sql:query dataSource="${snapshot}" var="products">
                    			SELECT prd_cat_id, prod_name, prod_sub_type_id, cr_int_rate, db_int_rate, active FROM product_catalog;
                    		</sql:query>
                    		<c:forEach var="product" items="${products.rows}">
                    			<tr>
                    				<td><c:out value="${product.prd_cat_id}" /></td>
                    				<td><c:out value="${product.prod_name}" /></td>
                    				<td>
                    					<sql:query dataSource="${snapshot}" var="productSubTypes">
                    						SELECT product_sub_type FROM prod_sub_type WHERE prd_sub_type_id=?;
                    						<sql:param value="${product.prod_sub_type_id}" />
                    					</sql:query>
                    					<c:forEach var="productSubType" items="${productSubTypes.rows}">
                    						<c:out value="${productSubType.product_sub_type}" />
                    					</c:forEach>
                    				</td>
                    				<td><c:out value="${product.cr_int_rate}" /></td>
                    				<td><c:out value="${product.db_int_rate}" /></td>
                    				<td><c:out value="${product.active}" /></td>
                    				<td>
                    					<form action="editProduct" method="post">
					                		<input type="hidden" name="prod_cat_id" value="${product.prd_cat_id}">
								            <button type="submit" class="btn btn-primary btn-sm" data-toggle="tooltip" title="Edit Product">
								            	<i class="fa fa-money"></i>
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
            		<form action="../CreateProduct" method="post" role="form">
		            <div class="box box-primary">
			            <div class="box-header">
			              <h3 class="box-title">Create New Product</h3>
			            </div>
		            		<div class="box-body">
							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label for="parent_prod_ref">Select Product Type</label>
										<select class="form-control" id="parent_prod_ref" name="parent_prod_ref" onchange="getProductSubTypes()">
											<sql:query dataSource="${snapshot}" var="productTypes">
                    								SELECT prd_type_id, product_type FROM prod_type;
                    							</sql:query>
                    							<option value="NaN" selected>Please select...</option>
                    							<c:forEach var="productType" items="${productTypes.rows}">
                    								<option value="<c:out value="${productType.prd_type_id}" />"><c:out value="${productType.product_type}" /></option>
                    							</c:forEach>
										</select>
									</div>
									<div class="form-group">
    										<label for="product_sub_type">Select Product Sub Type (to be populated from function)</label>
    										<div id="newProductFrmSubTypeSelectList"></div>
    									</div>
         						</div>
         						<div id="newProductFrmDetails"></div>
							</div>
			        		</div>
			        		<div class="box-footer">
			                	<button type="submit" class="btn btn-primary">Create Product</button>
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
        
    		function getProductSubTypes() {
    			
    			$.ajax({
    				type: 'POST',
    				url: '../ajax/getProductDetailsUtility.jsp',
    				data: "fnc=getSubTypes&prd_type_id="+$('#parent_prod_ref').val(),
    				success: function(data) {
    					$('#newProductFrmSubTypeSelectList').html(data);
    				}
    			});
    		}
    		
    		function getNewProductDetailsForm() {
    			
    			$.ajax({
    				type: 'POST',
    				url: '../ajax/getProductDetailsUtility.jsp',
    				data: 'fnc=getNewProductDetailsForm',
    				success: function(data) {
    					$('#newProductFrmDetails').html(data);
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
