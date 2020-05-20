<%-- Copyright (c) 2019 LTI. All rights reserved.--%>


<%@page import="com.liferay.portal.kernel.model.Organization"%>
<portlet:renderURL var="viewCidefinitionURL">
	<portlet:param name="mvcPath" value="/html/cidefinition/displayciDefinition.jsp" />
</portlet:renderURL>

<portlet:renderURL var="viewCiobjectURL">
	<portlet:param name="mvcPath" value="/html/cidefinition/view.jsp" />
</portlet:renderURL>


<div class="toggle-icon">
	<i aria-hidden="true" class="ci icon-chevron-right"></i>
</div>
<div class="main-sidebar-area">

	<h4 class="mobile-sub-navigation-title">
		CMDB<i aria-hidden="true" class="ci icon-domain"></i>
	</h4>
	
	<div class="sub-menu">
		<h6>
			CMDB<i aria-hidden="true"
				class="ci icon-assign-role-user"></i>
		</h6>
		<div class="sub-navigation-listing">
			<div class="sub-naigation-box">
				
				<ul>
					<li><a href="${viewCidefinitionURL}"> <i
							aria-hidden="true" class="ci icon-organization"></i> <span>CI Definitions</span>
					</a></li>
				</ul>
			</div>
			
			<div class="sub-naigation-box">
				
				<ul>
					<li><a href="${viewCiobjectURL}"> <i
							aria-hidden="true" class="ci icon-organization"></i> <span>CI Objects</span>
					</a></li>
				</ul>
			</div>
			
		</div>
		
		<span class="artwork-image"> <img
			src="${themeDisplay.getPathThemeImages()}/service-portfolio-menu-artwork.png" " />
		</span>
	</div>

</div>