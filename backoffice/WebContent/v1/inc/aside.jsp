<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Left side column. contains the logo and sidebar -->
      <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
          <!-- sidebar menu: : style can be found in sidebar.less -->
          <ul class="sidebar-menu tree" data-widget="tree">
          	<li class="treeview"><a href="dashboard"><i class="fa fa-dashboard"></i> <span>Dashboard</span></a></li>
	      	<li class="treeview"><a href="customers"><i class="fa fa-users"></i> <span>Customers</span></a></li>
	      	<li class="treeview"><a href="branches"><i class="fa fa-bank"></i> <span>Branches</span></a></li>
	      	<c:choose>
				<c:when test="${theme_name == '386'}">
					<li><a href="productTypes"><i class="fa fa-circle-o"></i> Product Types</a></li>
	      			<li><a href="productSubTypes"><i class="fa fa-circle-o"></i> Product Sub Types</a></li>
	      			<li><a href="products"><i class="fa fa-circle-o"></i> Products</a></li>            			
				</c:when>
				<c:otherwise>
					<li class="treeview">
			      		<a href="#">
			      			<i class="fa fa-money"></i>
			      			<span>Products</span>
			      			<span class="pull-right-container">
			      				<i class="fa fa-angle-left pull-right"></i>
			      			</span>
			      		</a>
			      		<ul class="treeview-menu" style="display: none;">
			      			<li><a href="productTypes"><i class="fa fa-circle-o"></i> Product Types</a></li>
			      			<li><a href="productSubTypes"><i class="fa fa-circle-o"></i> Product Sub Types</a></li>
			      			<li><a href="products"><i class="fa fa-circle-o"></i> Products</a></li>
			      		</ul>
			      	</li>		            			
				</c:otherwise>
			</c:choose>
	      	
	      		
          </ul>
        </section>
        <!-- /.sidebar -->
      </aside>