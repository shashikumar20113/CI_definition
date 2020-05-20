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
    
	
	ResultRow row = (ResultRow) request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
	
	BaseDocument basedoc =null;
	
	int[] roleTypes = { RoleConstants.TYPE_ORGANIZATION };
	
	basedoc =(BaseDocument) row.getObject();
	boolean check=(boolean) basedoc.getProperties().get("status");

%>
<div class="card-actions">
   <div class="actions">
      <portlet:renderURL var="editCIdefinition">
	    <portlet:param name="mvcPath"
		   value="/html/cidefinition/updateCiDefinition.jsp" />
	  <portlet:param name="key"
		   value="<%=String.valueOf(basedoc.getKey())%>" /> 
		<portlet:param name="displayStyle"
		   value="<%=displayStyle%>" />
	 </portlet:renderURL>
	 <a href="${editCIdefinition}" id="add-cidefinition"
		class="btn-" data-toggle="tooltip" title=""
		data-original-title="Edit"><i class="ci icon-edit"></i>
	</a>		
	<c:choose>
	<c:when test='<%=check%>'>
	<portlet:actionURL var="editCIdefinitionstatus" name="updateCIdefinitionstatus">
	    <portlet:param name="mvcPath" value="/html/cidefinition/displayciDefinition.jsp"/>
	    <portlet:param name="key"
			   value="<%=String.valueOf(basedoc.getKey())%>" /> 		   
		<portlet:param name="displayStyle"
			   value="<%=displayStyle%>" />
    </portlet:actionURL>
	 <a href="${editCIdefinitionstatus}" id="add-cidefinition"
		class="btn-" data-toggle="tooltip" title=""
		data-original-title="Update-Status"><i class="ci icon-deactive"></i>
	</a>
	</c:when>
	<c:otherwise>
	<portlet:actionURL var="editCIdefinitionstatus" name="updateCIdefinitionstatusasactive">
	    <portlet:param name="mvcPath" value="/html/cidefinition/displayciDefinition.jsp"/>
	    <portlet:param name="key"
			   value="<%=String.valueOf(basedoc.getKey())%>" /> 
		<portlet:param name="displayStyle"
			   value="<%=displayStyle%>" />
    </portlet:actionURL>
	 <a href="${editCIdefinitionstatus}" id="add-cidefinition"
		class="btn-" data-toggle="tooltip" title=""
		data-original-title="Update-Status"><i class="ci icon-active"></i>
	</a>
	
	</c:otherwise>													
	</c:choose>																																														
   </div>
</div>


<%


}
catch(Exception ex)


{
	System.out.println("exception"+ ":"+ ex);
}



%>