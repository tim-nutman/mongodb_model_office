<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="../inc/sql.jsp"%>


<sql:query dataSource="${snapshot}" var="accountsWithID">
	SELECT prod_inst_id FROM products_held WHERE prod_acc_id=?;
	<sql:param value="${param.newAccId}" />
</sql:query>
<c:choose>
	<c:when test="${accountsWithID.rowCount == 0}">
	<font color="green">Valid Account ID</font><script>$("#cust_add_new_acc_btn").prop('disabled', false);</script>
	</c:when>
	<c:otherwise>
	<font color="red">This Account ID is already in use</font><script>$("#cust_add_new_acc_btn").prop('disabled', true);</script>
	</c:otherwise>
</c:choose>
