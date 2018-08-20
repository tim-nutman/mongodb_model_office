<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<header class="main-header">

        <!-- Logo -->
        <a href="index2.html" class="logo">
          <!-- mini logo for sidebar mini 50x50 pixels -->
          <span class="logo-mini">BW </span>
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"><i>Bullwork </i><b>BackOffice</b></span>
        </a>

        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top" role="navigation">
          <!-- Sidebar toggle button-->
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
          </a>
          <!-- Navbar Right Menu -->
          <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
              
              <!-- Tasks: style can be found in dropdown.less -->
              
              <!-- User Account: style can be found in dropdown.less -->
              <li class="dropdown user user-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  <span class="hidden-xs">
                  	<c:out value="${sessionScope.dname}" /> | <c:out value="${sessionScope.oname}" /> | <c:out value="${sessionScope.role_name}" />
                  	</span>
                </a>
                <ul class="dropdown-menu">
                  <!-- Menu Body -->
                  <!-- Menu Footer-->
                  <li class="user-footer">
                    <!-- <div class="pull-left">
                      <a href="userprofile" class="btn btn-default btn-flat">Profile</a>
                    </div> -->
                    <c:if test="${sessionScope.debug == true }">
                      <button type="button" class="btn btn-default btn-flat" data-toggle="modal" data-target="#myModal">
  Debug
</button>
</c:if>                    
                    
                    <div class="pull-right">
                      <a href="/crm/doLogout" class="btn btn-default btn-flat">Sign out</a>
                    </div>
                  </li>
                </ul>
              </li>
              <!-- Control Sidebar Toggle Button -->
              <li>
                <!-- <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>  -->
              </li>
            </ul>
          </div>

        </nav>
      </header>