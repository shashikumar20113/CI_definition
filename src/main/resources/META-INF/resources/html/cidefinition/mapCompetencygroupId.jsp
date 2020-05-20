<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portal.kernel.json.JSONArray"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>

<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@ include file="init.jsp" %>
<%@ include file="/html/cidefinition/navigation.jsp" %>
<style>

#overflowTest {
 
 
  padding-top: 0px;
  padding-right: 0px;
  padding-bottom: 0px;
  padding-left: 0px;
  width: 50%;
  height: 100px;
  overflow: auto;
  border: 1px solid #ccc;
}

#space {
 
  
  padding-top: 15px;
  
}

#next { 
                position:absolute;                  
                margin-top: 7px;                          
                right:0;                          
      } 
            
            
#innerspace {
 
  
  padding-top: 5px;
  
  padding-bottom: 5px;
  
  
}

#formgroup {
 
  padding-bottom: -15px;
  margin-bottom: -5px;
  
  
}

#add{
 padding-top: 28px;
margin-top: 10px;
margin-left: -6px;
}

.lbl{
margin-bottom: 5px;

}

</style>


<%
try{
	    String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
		String key= ParamUtil.getString(request, "key");

		long organizationId = ParamUtil.getLong(request, "organizationId");
		
		String cidefinitionkey = ParamUtil.getString(request, "cidefinitionkey");
		String cidefinitionid =ParamUtil.getString(request, "cidefinitionid");
		
		
		JSONObject cidefinition=null;

		cidefinition= CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(),cidefinitionkey);

		List<Organization> ous=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), companyOrgID, null, CustomerConstants.TYPE_OU, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);
		
%>


<portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
<portlet:param name="cidefinitionid" value="<%=cidefinitionid%>" />
<portlet:param name="displayStyle" value="<%=displayStyle%>" />
<portlet:param name="cidefinitionkey" value="<%=String.valueOf(cidefinitionkey)%>" /> 
<portlet:param name="organizationId" value="<%= String.valueOf(organizationId)%>"/>
</portlet:renderURL>


<portlet:actionURL var="updateCompetencyGroupIdURL" name="updateCompetencyGroupId">
    <portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
    <portlet:param name="displayStyle" value="<%=displayStyle%>" />
    <portlet:param name="cidefinitionid" value="<%=cidefinitionid%>" />
    <portlet:param name="cidefinitionkey" value="<%=String.valueOf(cidefinitionkey)%>" /> 
    <portlet:param name="organizationId" value="<%= String.valueOf(organizationId)%>"/>
</portlet:actionURL>



<portlet:renderURL var="customerBackURL">
	<portlet:param name="mvcPath" value="/html/cidefinition/view.jsp" />
	<portlet:param name="organizationId"
		value="<%=String.valueOf(
							OrganizationLocalServiceUtil.getOrganization(organizationId).getParentOrganizationId())%>" />
	<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>

<portlet:renderURL var="projectBackURL">
	<portlet:param name="mvcPath" value="/html/cidefinition/viewProjects.jsp" />
	<portlet:param name="organizationId"
		value="<%=String.valueOf(
							OrganizationLocalServiceUtil.getOrganization(organizationId).getParentOrganizationId())%>" />
						
	<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>

<portlet:renderURL var="newBackURL">
	<portlet:param name="mvcPath" value="/html/cidefinition/viewciDefinitionClass.jsp" />
	<portlet:param name="organizationId"
		value="<%=String.valueOf(organizationId)%>" />
						
	<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>


<%

  JSONObject ciobject=null;

ciobject= CIDefinitionUtil.getCIObjectAsJSON(themeDisplay.getCompanyId(), key);



if (!OrganizationLocalServiceUtil.getParentOrganizations(organizationId).isEmpty()) {
	PortalUtil.addPortletBreadcrumbEntry(request, OrganizationLocalServiceUtil
			.getOrganization(organizationId).getParentOrganization().getName(), customerBackURL);
   
	PortalUtil.addPortletBreadcrumbEntry(request,
			OrganizationLocalServiceUtil.getOrganization(organizationId).getName(),
			projectBackURL.toString());
	
	PortalUtil.addPortletBreadcrumbEntry(request, cidefinition.getString("CI_Name"),newBackURL.toString());
	
	PortalUtil.addPortletBreadcrumbEntry(request, ciobject.getString("CI_Object"),backURL.toString());

	PortalUtil.addPortletBreadcrumbEntry(request, " Update Supported Group IDs",themeDisplay.getURLCurrent());

}

%>



<div class="main-content-area">
  <div class="container-fluid">
    <div class="row">
     <div class="col-md-6">
        <a href="${backURL}"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i> </a>
	                 
					                                <a href="javascript:void(0)" id="assignOwnerGroupsToOrgId"	
																class="btn btn-primary" data-toggle="tooltip" title="supportedBy"	
																data-original-title="Assign Supported Groups" onclick='assignOwnerGroupToOrg(<%=String.valueOf(organizationId)+",\""+String.valueOf(key)+"\""%>);'>
																<i	class="nav-item-icon icon-cog"></i>Assign Supported Group 	
																
							                        </a> 
     
     </div>
    
    </div>
         <hr class="devider" />
         
  </div>

     <div class="user-form mt-30 user-wrapper-form">
       
     
         <aui:form   action="${updateCompetencyGroupIdURL} " method="post" name="form" >
         
           <aui:fieldset-group markupView="lexicon">
           
           <input name="<portlet:namespace />key" value="<%=key%>" type="hidden" />
           
           <aui:row>
					    <h2 >Assigned Supported Group</h2>
					     <div  id="overflowTest"> 
					        <aui:col span="6">
						      <div class="input-feild">
							     <div class="form-group" id="innerspace" >
								  	<div id="labelname">
								  	 
								  	<%
								  	JSONArray ciobjectarr = ciobject.getJSONArray(CIDefinitionPortletKeys.SUPPORTEDBY);
								  	if(ciobjectarr!=null){
								  	for(int i=0; i<ciobjectarr.length(); i++)
								  	{
								  		
								  		String competencygroupid = ciobjectarr.getString(i);
								  								  		
								  		 long competencygroupmapid = Long. parseLong(competencygroupid);
								 
								  		
								  		Organization CompetencyGroupList= OrganizationLocalServiceUtil.fetchOrganization(competencygroupmapid);
					
								  								  			
								  		String competecygrpName=CompetencyGroupList.getName().toString();
								  		
								  	
								  			
								  			%>
								  			
								  			<input type="text" class="form-control input-default" name="<portlet:namespace />competency" value="<%=competecygrpName%>" readonly="readonly"></input>
								  			
								  			<% 
								  		
								  	}
								  	}
								  	
								  	else
								  	{
								  	%>
								  	
								  	<input type="text" class="form-control input-default" name="<portlet:namespace />competency" value="Supported Group not Assigned" readonly="readonly"></input>
								  			
								  	<%} %>
								  	
								  	
								  	</div>			
							    </div>
						     </div>
						    </aui:col> 
						    </div>
						    
						   
					     
						    <%-- <aui:col span="4">
						    
						    <div class="input-feild">
							     <div class="form-group" id="innerspace" >
								  	<div id="labelname">
								  	
								  	</div>			
							    </div>
						     </div> --%>
						  
						    
						      <div class="input-feild">
							     <div class="form-group" id="innerspace">
								  	<div id="myForm">
						                  <input type="hidden" name="<portlet:namespace />classname"></input>
						              </div>		
							    </div>
						     </div>
						    
						   
						    
						    
						    
						    </aui:row>
							           <aui:button-row>
											 <aui:button type="submit" name="save" ></aui:button>
											 <aui:button type="cancel" href="<%=backURL.toString()%>"></aui:button>
								         </aui:button-row> 
           
           </aui:fieldset-group>
         
         
         </aui:form>
     
     
     
     </div>
                 


</div>

<portlet:actionURL name="addsupportedBy" var="addsupportedByURL">	
	<portlet:param name="redirect" value="<%=themeDisplay.getURLCurrent()%>"/>	
</portlet:actionURL>	
<%@ include file="/html/cidefinition/updatesupportedBy.jspf" %>

<script>
function assignOwnerGroupToOrg(organizationId, orgName){	
				
			//clear current and available list 	
			document.getElementById("<portlet:namespace />assignRoleUserHeaderId").innerHTML = "Assign Supported Groups";	
			document.getElementById("<portlet:namespace />mappedRoleUserList").innerHTML = "";	
			document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "";	
			document.getElementById("<portlet:namespace />statusRoleUserDivId").innerHTML = "";	
			document.getElementById("<portlet:namespace />searchRoleUser").value = "";	
			document.getElementById("<portlet:namespace />orgRoleId").value = "";	
			document.getElementById("<portlet:namespace />roleOrganizationId").value = organizationId;	
			document.getElementById("<portlet:namespace />Key").value = orgName;
		}	
			
</script>

<aui:script>

function parentMethodofsupportedby(selectedval)
{	
       document.getElementById("labelname").innerHTML = "";	
	   document.getElementById("myForm").innerHTML = ""; 
		
			 var x = document.createElement("INPUT");
			 x.setAttribute("type", "hidden");
			 
			 x.setAttribute("Name", "<portlet:namespace />classname");
			 		 
			 document.getElementById("myForm").appendChild(x);
			 		 
		for(var cont=0; cont<selectedval.length; cont++)	
		{
				  
				     var obj = selectedval[cont];
				  
					 var y = document.createElement("INPUT");
					 y.setAttribute("type", "hidden");
					 y.setAttribute("value", obj["value"]);
					 y.setAttribute("Name", "<portlet:namespace />classname");
					 y.setAttribute("class", "form-control input-default");
					 y.setAttribute("readonly", "readonly");
					 
					 document.getElementById("myForm").appendChild(y);
	 
					 var z = document.createElement("INPUT");
					 z.setAttribute("type", "text");
					 z.setAttribute("value", obj["label"]);
					 z.setAttribute("Name", "<portlet:namespace />labelname");
					 z.setAttribute("class", "form-control input-default");
					 z.setAttribute("readonly", "readonly");
					 
					 document.getElementById("labelname").appendChild(z);
	 
		}	
		window.popUpWindow.destroy();
}

</aui:script>




<%
}
catch(Exception ex)
{
	
}

%>