<%@page import="com.arangodb.entity.BaseDocument"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.model.RoleConstants"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.kernel.dao.search.ResultRow"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="init.jsp"%>
<%@ include file="/html/cidefinition/navigation.jsp" %>
<%

try{
	
	String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
    
	long organizationId = ParamUtil.getLong(request, "organizationId", 0l);
	ResultRow row = (ResultRow) request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
	
	BaseDocument basedoc =null;
	
	int[] roleTypes = { RoleConstants.TYPE_ORGANIZATION };
	
	basedoc =(BaseDocument) row.getObject();
	
%>
<div class="card-actions">
   <div class="actions">
     <portlet:renderURL var="CIObjects">
		<portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp" />
			<portlet:param name="cidefinitionid"
						value="<%=String.valueOf(basedoc.getId())%>" /> 
			<portlet:param name="cidefinitionkey"
				        value="<%=String.valueOf(basedoc.getKey())%>" />					   
			<portlet:param name="displayStyle"
						value="<%=displayStyle%>" />
			<portlet:param name="organizationId"
						 value="<%=String.valueOf(organizationId)%>" />				
		</portlet:renderURL>
		<a href="${CIObjects}" class="view-project-icon" data-toggle="tooltip" title="" data-original-title="Manage CiObjects">
		<i class="ci icon-arrow-right"></i>
	</a>	 
																												                       																																													
   </div>
</div>


<%


}
catch(Exception ex)


{
	System.out.println("exception"+ ":"+ ex);
}



%>