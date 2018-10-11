<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${sessionScope.debug == true }">
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Debug Information</h4>
      </div>
      <div id="debugModalBody" class="modal-body">
        <c:if test="${sessionScope.debug == true }">
     
      		User ID : <c:out value="${sessionScope.u_id}" /><br>
      		Display Name : <c:out value="${sessionScope.dname}" /><br>
      		Org ID : <c:out value="${sessionScope.o_id}" /><br>
      		Role ID : <c:out value="${sessionScope.r_id}" /><br>
      		Role Name : <c:out value="${sessionScope.role_name}" /><br>
      		Permission Level : <c:out value="${sessionScope.level}" /><br>
      		Name : <c:out value="${sessionScope.oname}" /><br>
      		Debug : <c:out value="${sessionScope.debug}" /><br>
      		Last Action : <c:out value="${sessionScope.user_last_action}" /><br>
      		Current Contact ID : <c:out value="${sessionScope.current_contact_id}" /><br>
      		Current Location ID : <c:out value="${sessionScope.current_location_id}" /><br>
      		Active Org (Super Admin) : <c:out value="${sessionScope.active_org}" /><br>
      		As of: <fmt:formatDate type="both" value="${now}" />
      
</c:if>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" onclick="updateDebugInfo();">Refresh</button>
      </div>
    </div>
  </div>
</div>
</c:if>