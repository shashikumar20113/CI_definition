<%@page import="com.liferay.portal.kernel.json.JSONFactoryUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@page import="com.lti.itops.ipac.pwd.vault.server.service.SecretLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.pwd.vault.server.model.Secret"%>
<%@page import="com.lti.itops.ipac.pwd.vault.server.model.SecretEngine"%>
<%@page import="com.lti.itops.ipac.pwd.vault.server.service.SecretEngineLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.pwd.vault.server.service.OrgVaultServerLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.pwd.vault.server.model.OrgVaultServer"%>
<%@page import="com.liferay.portal.kernel.theme.ThemeDisplay"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.kernel.model.ListTypeConstants"%>
<%@page import="com.lti.itops.ipac.domgmt.util.DeliveryOrganizationConstants"%>

<%@page import="java.util.Set"%>
<%@page import="com.lti.itops.ipac.spmgmt.model.Tower"%>
<%@page import="com.lti.itops.ipac.spmgmt.service.TowerLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.spmgmt.model.Technology"%>
<%@page import="com.lti.itops.ipac.spmgmt.service.TechnologyLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.spmgmt.service.TowerTechnologyMapLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.spmgmt.model.TowerTechnologyMap"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.taglib.search.ResultRow"%>
<%@page import="com.liferay.portal.kernel.dao.search.SearchContainer"%>


<%@page import="com.lti.itops.ipac.custcatmgmt.model.TTechnologyCustomerMap"%>

<%@page import="com.lti.itops.ipac.custcatmgmt.service.TTechnologyCustomerMapLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.custcatmgmt.service.TowerCustomerMapLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.custcatmgmt.model.TowerCustomerMap"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.kernel.json.JSONArray"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@ include file="init.jsp" %>
<%@ include file="/html/cidefinition/navigation.jsp" %>



<%@page import="com.liferay.portal.kernel.util.PortalClassLoaderUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.Property"%>
<%@page import="com.liferay.portal.kernel.dao.orm.Junction"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.Criterion"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.PortletClassLoaderUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style>

#overflowTest {
 
 
  padding-top: 0px;
  padding-right: 0px;
  padding-bottom: 0px;
  padding-left: 0px;
  width: 100%;
  height: 260px;
  overflow: auto;
  border: 1px solid #ccc;
}

#space {
 
  
  padding-top: 15px;
  
}

#next { 
                position:absolute;                  
                bottom:0;                          
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

	try
	{
	String cidefinitionkey = ParamUtil.getString(request, "cidefinitionkey");
	
	String cidefinitionid = ParamUtil.getString(request, "cidefinitionid");
	
	String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
	
	long organizationId = ParamUtil.getLong(request, "organizationId");
	
	JSONObject cidefinition=null;
	
	cidefinition= CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(),cidefinitionkey);
	
	cidefinition.get("CI_Name");

	String key= ParamUtil.getString(request, "key");

	cidefinition= CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(),cidefinitionkey);
		
%>

<%
List<Organization> organization2=new ArrayList<Organization>();
		organization2=OrganizationLocalServiceUtil.getParentOrganizations(organizationId);
		
		
		List<Long> orgIDParent=new ArrayList<Long>();
		for (Organization organization:organization2){
			orgIDParent.add(organization.getOrganizationId());
		}
		
		Long parentOrgId=orgIDParent.get(0);
		
		
		//System.out.println("Shashi org id"+organization.getOrganizationId());	
		//long opvServerId=ParamUtil.getLong(request, "opvServerId");
	
		//orgVaultServer=OrgVaultServerLocalServiceUtil.getOrgVaultServer(1302);
	   // orgVaultServer=OrgVaultServerLocalServiceUtil.getOrgVaultServer(opvServerId);
	   
		List<OrgVaultServer> orgVaultServers=new ArrayList<OrgVaultServer>();
		List<Long> opvServerId=new ArrayList<Long>();
		
		List<String> secretName= new ArrayList<String>();
		
	    orgVaultServers=OrgVaultServerLocalServiceUtil.findOrgVaultServerByOrgID(parentOrgId);
		
		
	        if(!orgVaultServers.isEmpty()){
	        	for (OrgVaultServer orgVaultServer2:orgVaultServers){
		    		opvServerId.add(orgVaultServer2.getOpvServerId());
					
		    		long secretEngineId= orgVaultServer2.getPrimaryKey();
		    		
		    		
		    		DynamicQuery orgQuery1 = SecretEngineLocalServiceUtil.dynamicQuery();
		    		
		    		//orgQuery1.add(PropertyFactoryUtil.property("opvServerId"));
		    		//orgQuery1.add(PropertyFactoryUtil.forName("opserverId").eq(new long(1302)));
		    		//orgQuery1.add(PropertyFactoryUtil.forName("opvServerId")));
		    		
		    		List<SecretEngine> engine=SecretEngineLocalServiceUtil.dynamicQuery(orgQuery1);
		    		List<Long> engines=new ArrayList<Long>();
		    		for(SecretEngine engine2:engine){
		    			engines.add(engine2.getSecretEngineId());
		    			
		    			
		    			DynamicQuery orgQuery = SecretLocalServiceUtil.dynamicQuery();
			    		
			    		List<Secret> secretList=SecretEngineLocalServiceUtil.dynamicQuery(orgQuery);
			    		List<Long> list=new ArrayList<Long>();
			    		
			    		for(Secret secret:secretList){
			    			list.add(secret.getSecretId());
			    			secretName.add(secret.getSecretName());
			    			
			    		}


		    		}

	        	}		    	
		    	

	        }
		
%>

<portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
<portlet:param name="cidefinitionid" value="<%=cidefinitionid%>"/>
<portlet:param name="cidefinitionkey" value="<%=String.valueOf(cidefinitionkey)%>" /> 
<portlet:param name="displayStyle" value="<%=displayStyle%>" />
<portlet:param name="organizationId" value="<%= String.valueOf(organizationId)%>"/>
</portlet:renderURL>

<portlet:renderURL var="singlerefUrl" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcPath" value="/html/cidefinition/singlerefpopup.jsp"/>
	<portlet:param name="cidefinitionid" value="<%=String.valueOf(cidefinitionid)%>" />
</portlet:renderURL>

<portlet:renderURL var="multiplerefUrl" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcPath" value="/html/cidefinition/multiplerefpopup.jsp"/>
	<portlet:param name="cidefinitionid" value="<%=String.valueOf(cidefinitionid)%>" />
</portlet:renderURL>

<portlet:actionURL var="updateSecretURL" name="updateSecret">
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
		
		PortalUtil.addPortletBreadcrumbEntry(request, "CI objects",backURL.toString());
	
		PortalUtil.addPortletBreadcrumbEntry(request, " Add Secret IDs",themeDisplay.getURLCurrent());
	
	}

/* HashMap<Long,Technology> curtechnologiesHashMap =new  HashMap<Long,Technology>();
 
HashMap<Long, TowerTechnologyMap> towerTechnologyHashMap = new HashMap<Long, TowerTechnologyMap>();

      curtechnologiesHashMap.get(towerTechnologyHashMap.get(TTechnologyCustomerMap.getTowerTechnologyId()).getTechnologyId()).getName();
 */
%>


<div class="main-content-area">
   <div class="container-fluid">
    <div class="row">
      <div class="col-md-6">
	             <a href="<%=backURL.toString()%>"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i> Add Secret IDs </a>
	  </div>			
    </div>
    <hr class="devider" />
  </div>
  
  
  <div class="user-form mt-30 user-wrapper-form">
  
  
      
    <aui:form   action="${updateSecretURL} " method="post" name="form" >
    
       <aui:fieldset-group markupView="lexicon">
           
           <input name="<portlet:namespace />key" value="<%=key%>" type="hidden" />
           
           <aui:row>
					     <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="Added Secret IDs" >
					     <div  id="overflowTest"> 
					        <aui:col span="4">
						      <div class="input-feild">
							     <div class="form-group" id="innerspace" >
								  	<div id="labelname">
								  	
								  	<%
								  	JSONArray ciobjectarr = ciobject.getJSONArray(CIDefinitionPortletKeys.SECRET_ID);
							  		System.out.println("= Shashi ID ciobjectarr length"+ciobjectarr.length());

								  	if(ciobjectarr.length()>1){
								  		
								  	
								  	for(int i=0; i<ciobjectarr.length(); i++)
								  	{
								  		
								  		String competencygroupid = ciobjectarr.getString(i);
								  								  		
								  		 long competencygroupmapid = Long. parseLong(competencygroupid);
								 
								  		//System.out.println(competencygroupid+"= Shashi comp values= "+competencygroupmapid);
								  		//Organization CompetencyGroupList= OrganizationLocalServiceUtil.fetchOrganization(competencygroupmapid);
								  		
								  	    String classids= ciobjectarr.getString(i);

								  		 Long secretId = Long. parseLong(classids);

							      		DynamicQuery orgQuery = SecretLocalServiceUtil.dynamicQuery();

							              orgQuery.add(PropertyFactoryUtil.forName("secretId").eq(new Long(classids)));

							              List<Secret> secretList=SecretEngineLocalServiceUtil.dynamicQuery(orgQuery);
									  		System.out.println("= Shashi ID secretList "+secretList);
									  		List<String> list=new ArrayList<String>();
									  		JSONArray secretarray=JSONFactoryUtil.createJSONArray();
											for(Secret secret:secretList){
												list.add(secret.getSecretName());
								      			secretarray.put(secret.getSecretName());
								    			
								    		}

									  		System.out.println("= Shashi ID list "+list.toString());
									  		System.out.println("= Shashi ID secretarray "+secretarray);
									  		

								  			
								  			%>
								  			
								  			<input type="text" class="form-control input-default" name="<portlet:namespace />classname" value=<%=list%> readonly="readonly"></input>
								  			
								  			<% 
								  		
								  	}
								  	}
								  	else{
								  	%>
								 <input type="text" class="form-control input-default" name="<portlet:namespace />classname" value="No Secret IDs Mapped"></input>
								  	
								<%
								  	}
								  	%>
								  	
								  	
								  	
								  	
								  	
								  	</div>			
							    </div>
						     </div>
						    </aui:col> 
						    <aui:col span="4">
						      <div class="input-feild">
							     <div class="form-group" id="innerspace">
								  	<div id="myForm">
						                  <input type="hidden" name="<portlet:namespace />classname"></input>
						              </div>		
							    </div>
						     </div>
						    </aui:col>
						    </div>
						    </aui:fieldset>
						    </aui:row>
           
           
           </aui:fieldset-group>
         
         	
		 <aui:fieldset-group markupView="lexicon">
		  <div class="form-fields-content">
							<aui:row>
								<aui:fieldset collapsed="<%=true%>" collapsible="<%=true%>"
									label="Secrets">
									<aui:col span="6">
									<div class= "input-field">
									<div class="form-group">
									<aui:select label="Secrets" class="form-control input-default" name="secretNames" multiple="true">
																						<%
														if (!secretName.isEmpty()) {
																								for (String secretNames : secretName) {
																									String secName = secretNames;
													%>
													<option><%=secName%></option>

													<%
														}
																							}

																							else {
													%>

													<option value="">No Secrets Mapped</option>

													<%
														}
													%>
									</aui:select>
									</div>
									</div>
									</aui:col>
									</aui:fieldset>
									</aui:row>
									</div>
									
								<aui:button-row>
									<aui:button type="submit" name="save"></aui:button>
									<aui:button type="cancel" href="<%=backURL.toString()%>"></aui:button>
								</aui:button-row>


		 </aui:fieldset-group>				
    
    </aui:form>
    
  </div>
</div>
<%
}
catch(Exception ex)
{
	System.out.println("Exception"+ ex);
}


%>
		 
