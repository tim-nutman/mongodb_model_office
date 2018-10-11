<c:choose>
	<c:when test="${not empty param.theme}">
	 	<c:set var="theme_name" value="${param.theme}" scope="session"></c:set>
	</c:when>
	<c:otherwise>
		<c:if test="${empty theme_name}">
			<c:set var="theme_name" value="default" scope="session"></c:set>
		</c:if>
	</c:otherwise>
</c:choose>