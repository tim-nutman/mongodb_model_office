<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="../inc/sql.jsp"%>



<c:choose>
	<c:when test="${param.fnc == 'getSubTypes'}">
		<sql:query dataSource="${snapshot}" var="productSubTypes">
			SELECT prd_sub_type_id, product_sub_type FROM prod_sub_type WHERE parent_type_ref=?;
	 		<sql:param value="${param.prd_type_id}" />
		</sql:query>
		<select class="form-control" id="product_sub_type" name="product_sub_type" onchange="getNewProductDetailsForm()">
			<option value="NaN" selected>Please select...</option>
			<c:forEach var="productSubType" items="${productSubTypes.rows}">
				<option value="<c:out value="${productSubType.prd_sub_type_id}" />"><c:out value="${productSubType.product_sub_type}" /></option>
			</c:forEach>
		</select>
	</c:when>
	<c:when test="${param.fnc == 'getNewProductDetailsForm'}">
		<div class="col-md-4">
			<div class="form-group">
				<label for="product_name">Product Name</label>
				<input type="text" class="form-control" id="product_name" name="product_name" placeholder="Product Name">
			</div>
			<div class="form-group">
				<label for="product_desc">Product Description</label>
				<input type="text" class="form-control" id="product_desc" name="product_desc" placeholder="Product Description">
			</div>
			<div class="form-group">
				<label for="active">Active</label>
				<select class="form-control" id="active" name="active">
					<option value="1" selected>Active</option>
					<option value="0">Inactive</option>
				</select>
			</div>
		</div>
		<div class="col-md-4">
			<div class="form-group">
				<label for="product_fee_type">Fee Type</label>
				<select class="form-control" id="product_fee_type" name="product_fee_type">
					<option value="NaN" selected>Please select...</option>
					<option value="Annual" selected>Annual</option>
					<option value="Monthly" selected>Monthly</option>
					<option value="None" selected>No Fees</option>
				</select>
			</div>
			<div class="form-group">
				<label for="product_fee_amount">Fee Amount</label>
				<input type="text" class="form-control" id="product_fee_amount" name="product_fee_amount" placeholder="Set Fee Value">
			</div>
			<div class="form-group">
				<label for="product_cr_int">Annual (Credit) Interest %</label>
				<input type="text" class="form-control" id="product_cr_int" name="product_cr_int" placeholder="Credit Interest %">
			</div>
			<div class="form-group">
				<label for="product_db_int">Annual (Debit) Interest %</label>
				<input type="text" class="form-control" id="product_db_int" name="product_db_int" placeholder="Debit Interest %">
			</div>
		</div>
	</c:when>
	<c:when test="${param.fnc == 'getSubTypesCustomer'}">
		<sql:query dataSource="${snapshot}" var="productSubTypes">
			SELECT prd_sub_type_id, product_sub_type FROM prod_sub_type WHERE parent_type_ref=?;
	 		<sql:param value="${param.prd_type_id}" />
		</sql:query>
		<select class="form-control" id="prod_sub_type_id" name="prod_sub_type_id" onchange="getProductList()">
		<option value="NaN" selected>Please select...</option>
			<c:forEach var="productSubType" items="${productSubTypes.rows}">
				<option value="<c:out value="${productSubType.prd_sub_type_id}" />"><c:out value="${productSubType.product_sub_type}" /></option>
			</c:forEach>
		</select>
	</c:when>
	<c:when test="${param.fnc == 'getProductList'}">
		<sql:query dataSource="${snapshot}" var="productCatEntries">
			SELECT prd_cat_id, prod_name FROM product_catalog WHERE prod_sub_type_id = ?;
			<sql:param value="${param.prod_sub_type_id}" />
		</sql:query>
		<select class="form-control" id="prd_cat_id" name="prd_cat_id" onchange="getProductDetails()">
			<option value="NaN" selected>Please select...</option>
			<c:forEach var="product" items="${productCatEntries.rows}">
				<option value="<c:out value="${product.prd_cat_id}" />"><c:out value="${product.prod_name}" /></option>
			</c:forEach>
		</select>
	</c:when>
	<c:when test="${param.fnc == 'getProductDetailsWithForm'}">
		<sql:query dataSource="${snapshot}" var="productCatDetails">
			SELECT cr_int_rate, db_int_rate, fee, fee_type, active FROM product_catalog WHERE prd_cat_id = ?;
			<sql:param value="${param.prd_cat_id}" />
		</sql:query>
		<c:forEach var="product" items="${productCatDetails.rows}">
			<div class="col-md-4">
				<div class="form-group">
					<label for="cr_int_rate">Credit Interest Rate</label>
					<input class="form-control" id="cr_int_rate" type=text value="<c:out value="${product.cr_int_rate}" />" readonly />
				</div>
				<div class="form-group">
					<label for="db_int_rate">Debit Interest Rate</label>
					<input class="form-control" id="db_int_rate" type=text value="<c:out value="${product.db_int_rate}" />" readonly />
				</div>
				<div class="form-group">
					<label for="fee">Fee</label>
					<input class="form-control" id="fee" type=text value="<c:out value="${product.fee}" />" readonly />
				</div>
				<div class="form-group">
					<label for="fee_type">Fee</label>
					<input class="form-control" id="fee_type" type=text value="<c:out value="${product.fee_type}" />" readonly />
				</div>
				<div class="form-group">
					<label for="active">Active</label>
					<input class="form-control" id="active" type=text value="<c:out value="${product.active}" />" readonly />
				</div>
			</div>
			<div class="col-md-4">
          		<div class="form-group">
           			<label for="new_prod_acc_id">Account ID (Number)<span id="newAccIdCheckResult"></span></label>
           			<input class="form-control" id="new_prod_acc_id" name="new_prod_acc_id" type=text value="" placeholder="Enter New Acc Number" onChange="CheckAccNumber();"/>
           		</div>
           		<div class="form-group">
           			<label for="new_prod_limit">Limit (Credit Limit or Overdraft)</label>
           			<input class="form-control" id="new_prod_limit" name="new_prod_limit" type=text value="" placeholder="Enter OD/CR Limit" />
           		</div>
           		<div class="form-group">
           			<label for="new_date_opened">Date Opened</label>
           			<input type="date" class="form-control" id="new_date_opened" name="new_date_opened">
           		</div>
           		<div class="form-group">
           			<label for="new_prod_active">Active or Dormant</label>
           			<select class="form-control" id="new_prod_active" name="new_prod_active">
           				<option value="1" selected>Active</option>
            				<option value="0">Dormant</option>
           			</select>
           		</div>
           		<div class="form-group">
           			<label for="new_prod_status">Account/Product Status</label>
           			<select class="form-control" id="new_prod_status" name="new_prod_status">
           				<option value="Open" selected>Open</option>
            				<option value="Closed">Closed</option>
            				<option value="Frozen">Frozen</option>
           			</select>
           		</div>
           		<div class="form-group">
					<input type="hidden" name="cust_id" value="<c:out value="${param.customer_id}" />" />
					<button type="submit" id="cust_add_new_acc_btn" class="btn btn-primary" disabled>Add New Account</button>
				</div>
          	</div>
		</c:forEach>
		
	</c:when>
	<c:otherwise>
		
	</c:otherwise>
</c:choose>