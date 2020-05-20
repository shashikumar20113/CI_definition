<%-- Copyright (c) 2019 LTI. All rights reserved.--%>
<%--  @author Raj Kumar Kulasekaran --%>






<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.kernel.dao.search.ResultRow"%>
<%@ include file="init.jsp"%>
<%@ include file="/html/cidefinition/navigation.jsp" %>
<%

	ResultRow row = (ResultRow) request
			.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
	Organization project = (Organization) row.getObject();
	
	int[] roleTyes = { RoleConstants.TYPE_ORGANIZATION};
	
	String displayStyle = ParamUtil.getString(request, "displayStyle", 
			CustomerConstants.DEFAULT_DISPLAY_STYLE); 
%>


<div class="card-actions">
	<div class="actions">
		<%-- <c:if test="<%=ProjectPermission.isManager(themeDisplay, project) && project.getStatusId()!=CustomerConstants.ORG_DEACTIVATE_STATUS %>">--%>
			
			<portlet:renderURL var="viewciDefinitionClassjsp">
				<portlet:param name="mvcPath"
					value="/html/cidefinition/viewciDefinitionClass.jsp" />
				<portlet:param name="organizationId"
					value="<%=String.valueOf(project.getOrganizationId())%>" />
				<portlet:param name="organizationId"
					value="<%=String.valueOf(project.getOrganizationId())%>" />
				<portlet:param name="displayStyle"
					value="<%=displayStyle%>" />
			</portlet:renderURL>
			<a href="<%=viewciDefinitionClassjsp.toString() %>" id="" class="btn-" data-toggle="tooltip" title="" data-original-title="View CI Definitions"> 
				<i class="ci icon-catalog-group"></i>
			</a> 
	</div>
</div>

