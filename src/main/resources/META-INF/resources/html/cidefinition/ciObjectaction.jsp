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
	String cidefinitionid =ParamUtil.getString(request, "cidefinitionid");
	String cidefinitionkey =ParamUtil.getString(request, "cidefinitionkey");
	long organizationId = ParamUtil.getLong(request, "organizationId");
	
	ResultRow row = (ResultRow) request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
	
	BaseDocument basedoc =null;
	
	int[] roleTypes = { RoleConstants.TYPE_ORGANIZATION };
	
	basedoc =(BaseDocument) row.getObject();
	boolean check=(boolean) basedoc.getProperties().get("status");

%>
<div class="card-actions">
   <div class="actions">
       <portlet:renderURL var="editCIobject">
		 <portlet:param name="mvcPath"
			    value="/html/cidefinition/updateCiObject.jsp" />
		 <portlet:param name="key"
				value="<%=String.valueOf(basedoc.getKey())%>" />
		 <portlet:param name="displayStyle"
				value="<%=displayStyle%>" />
		  <portlet:param name="cidefinitionid"
				value="<%=cidefinitionid%>" /> 
		  <portlet:param name="cidefinitionkey" 
				value="<%=String.valueOf(cidefinitionkey)%>" /> 
		  <portlet:param name="organizationId"
				value="<%=String.valueOf(organizationId)%>" /> 						
	  </portlet:renderURL>
	  <a href="${editCIobject}" id="add-cidefinition"
					class="btn-" data-toggle="tooltip" title=""
					data-original-title="Edit"><i class="ci icon-edit"></i>
	  </a>
	  
	  <!-- Added By Shashi -->
			<% Organization organization=null;
			organization = OrganizationLocalServiceUtil.getOrganization(organizationId);
							
			organization.getOrganizationId();
			organization.getName();
															
		//_log.info("shashi org details"+" "+String.valueOf(organization.getOrganizationId())+" "+String.valueOf(organization.getName()));
		%>
		<a href="javascript:void(0)" id="assignOwnerToOrgId" class="btn-"	
		   data-toggle="tooltip" title="Assign Owners" 	
		   data-original-title="Assign Owners" onclick='assignOwnerToOrg(<%=String.valueOf(organization.getOrganizationId())+",\""+String.valueOf(basedoc.getKey())+"\""%>);'><i	
					class="ci icon-assign-user"></i>	
		</a> 	
		<a href="javascript:void(0)" id="assignOwnerGroupsToOrgId"	
		   class="btn-" data-toggle="tooltip" title="Assign Owner groups"	
		   data-original-title="Assign Owner Groups" onclick='assignOwnerGroupToOrg(<%=String.valueOf(organization.getOrganizationId())+",\""+String.valueOf(basedoc.getKey())+"\""%>);'><i	
				class="ci icon-assign-role-user"></i>	
	    </a> 													
														
															
															
															<!--  -->
															
		<a href="javascript:void(0)" id="assignSupportedGroupsToOrgId"	
		   class="btn-" data-toggle="tooltip" title="supportedBy"	
		   data-original-title="Assign Supported Groups" onclick='assignSupportedToOrg(<%=String.valueOf(organization.getOrganizationId())+",\""+String.valueOf(basedoc.getKey())+"\""%>);'><i	
		   class="nav-item-icon icon-cog"></i>	
		</a>  
	  
	<c:choose>
		<c:when test='<%=check%>'>
			<portlet:actionURL var="editCIobjectstatus" name="updateCIobjectstatus">
			<portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
			<portlet:param name="key"
			     value="<%=String.valueOf(basedoc.getKey())%>" /> 		   
			<portlet:param name="displayStyle"
				 value="<%=displayStyle%>" />
			<portlet:param name="cidefinitionid"
				 value="<%=cidefinitionid%>" /> 
			<portlet:param name="cidefinitionkey" 
				 value="<%=String.valueOf(cidefinitionkey)%>" /> 
			<portlet:param name="organizationId"
				 value="<%=String.valueOf(organizationId)%>" /> 		 	 
			</portlet:actionURL>
	        <a href="${editCIobjectstatus}" id="add-cidefinition"
					class="btn-" data-toggle="tooltip" title=""
					data-original-title="Update-Status"><i class="ci icon-deactive"></i>
			</a>
		</c:when>
		<c:otherwise>
		   <portlet:actionURL var="editCIobjectstatus" name="updateCIobjectstatusasactive">
		   <portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
		   <portlet:param name="key"
			     value="<%=String.valueOf(basedoc.getKey())%>" /> 
			<portlet:param name="displayStyle"
				 value="<%=displayStyle%>" />
			<portlet:param name="cidefinitionid"
				 value="<%=cidefinitionid%>" />	
			<portlet:param name="cidefinitionkey" 
				value="<%=String.valueOf(cidefinitionkey)%>" /> 
			<portlet:param name="organizationId"
						value="<%=String.valueOf(organizationId)%>" /> 		  
			</portlet:actionURL>
			<a href="${editCIobjectstatus}" id="add-cidefinition"
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