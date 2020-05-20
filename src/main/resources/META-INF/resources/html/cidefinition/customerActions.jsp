<%-- Copyright (c) 2019 LTI. All rights reserved.--%>
<%--  @author Raj Kumar Kulasekaran --%>




 
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.kernel.dao.search.ResultRow"%>
<%@ include file="init.jsp"%>
<%@ include file="/html/cidefinition/navigation.jsp" %>
<%
	ResultRow row = (ResultRow) request
			.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
	Organization customer = (Organization) row.getObject();
	
	String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
%>



<portlet:renderURL var="viewProjectURL">
	<portlet:param name="mvcPath" value="/html/cidefinition/viewProjects.jsp" />
	<portlet:param name="organizationId" value="<%=String.valueOf(customer.getOrganizationId())%>" />
	<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>
		
<div class="card-actions">
    <div class="actions">
	<a href="${viewProjectURL}" class="view-project-icon" data-toggle="tooltip" title="" data-original-title="View Project">
		<i class="ci icon-arrow-right"></i>
	</a>
	</div>
</div>

