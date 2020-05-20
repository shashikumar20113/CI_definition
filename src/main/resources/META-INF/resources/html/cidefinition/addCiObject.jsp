
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

<style>

#overflowTest1 {
 
 
  padding-top: 0px;
  padding-right: 0px;
  padding-bottom: 0px;
  padding-left: 0px;
  width: 50%;
  height: 160px;
  overflow: auto;
  border: 1px solid #ccc;
}

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
                margin-top: 7px;                          
                right:0px;                          
      } 
      
 #next1 { 
                position:absolute;                  
                margin-top: 7px;                          
                right:474px;                          
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
%>

<%

/* code to Map Technology */
HashMap<Long,Tower> towersHashMap = new HashMap<Long,Tower>();
List<TowerCustomerMap> towerCustomerMaps = new ArrayList<TowerCustomerMap>();
List<Tower> towersMap = new ArrayList<Tower>();
List<Long> towerIds = new ArrayList<Long>();
Set<String> technologyName = new HashSet<>();
List<TTechnologyCustomerMap> ttechnologyCustomerMap = new ArrayList<TTechnologyCustomerMap>();
Set<Long> ownerid = new HashSet<Long>();

towerCustomerMaps = TowerCustomerMapLocalServiceUtil
		.findActiveTowerCustomerMapByOrganizationId(organizationId);

if(!towerCustomerMaps.isEmpty())
{
	
	for (TowerCustomerMap towerCustomerMap : towerCustomerMaps) 
	{
		towerIds.add(towerCustomerMap.getTowerId());
		
		long towerCustomerId= towerCustomerMap.getTowerCustomerId();
		
		TowerCustomerMap towerCustomer = TowerCustomerMapLocalServiceUtil
				.getTowerCustomerMap(towerCustomerId);
		
		long towerId = towerCustomerMap.getTowerId();
		long orgId = towerCustomerMap.getOrganizationId();
		
		List<TowerTechnologyMap> towerTechnologyMaps = TowerTechnologyMapLocalServiceUtil
				.findActiveByTowerId(towerId);
		
		
		List<Long> towerTechnologyIds = new ArrayList<Long>();
		for(TowerTechnologyMap towerTechnologyMap : towerTechnologyMaps){
			towerTechnologyIds.add(towerTechnologyMap.getTowerTechnologyId());
		}


		List<TTechnologyCustomerMap> towerTechnologyCustomerMaps = new ArrayList<TTechnologyCustomerMap>();

		towerTechnologyCustomerMaps = TTechnologyCustomerMapLocalServiceUtil
		.getActiveTTechnologyCustomerMapByorganizationId(orgId , towerTechnologyIds);
		
		 
        if(!towerTechnologyCustomerMaps.isEmpty())
        {
		for(TTechnologyCustomerMap towerTechnologyCustomerMap:towerTechnologyCustomerMaps )
		{
			
			technologyName.add(towerTechnologyCustomerMap.getName().toString());
			ttechnologyCustomerMap.add(towerTechnologyCustomerMap);
			
			ownerid.add(towerTechnologyCustomerMap.getCompanyId());
			
			
			
		}
		
        }
	}
	
	towersMap = TowerLocalServiceUtil.findTowerIdByTowerIdList(towerIds);
	for(Tower tower : towersMap){
		towersHashMap.put(tower.getTowerId(), tower);
	}
}

// code to map Secret Ids ! added by Shashi
		List<Organization> organization2=new ArrayList<Organization>();
		organization2=OrganizationLocalServiceUtil.getParentOrganizations(organizationId);
		
		
		List<Long> orgIDParent=new ArrayList<Long>();
		for (Organization organization:organization2){
			orgIDParent.add(organization.getOrganizationId());
		}
		
		Long parentOrgId=orgIDParent.get(0);
	   
		List<OrgVaultServer> orgVaultServers=new ArrayList<OrgVaultServer>();
		List<Long> opvServerId=new ArrayList<Long>();
		
		List<String> secretName= new ArrayList<String>();
		
	    orgVaultServers=OrgVaultServerLocalServiceUtil.findOrgVaultServerByOrgID(parentOrgId);
		
		
	        if(!orgVaultServers.isEmpty()){
	        	for (OrgVaultServer orgVaultServer2:orgVaultServers){
		    		opvServerId.add(orgVaultServer2.getOpvServerId());
					
		    		long secretEngineId= orgVaultServer2.getPrimaryKey();
		    		
		    		
		    		DynamicQuery orgQuery1 = SecretEngineLocalServiceUtil.dynamicQuery();
		    		
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
		
		//end 

		
		List<Organization> ous=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), companyOrgID, null, CustomerConstants.TYPE_OU, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);
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

<portlet:actionURL var="addCiobjectURL" name="addCiobject">
    <portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
    <portlet:param name="cidefinitionid" value="<%=cidefinitionid%>"/>
     <portlet:param name="cidefinitionkey" value="<%=cidefinitionkey%>"/>
    <portlet:param name="displayStyle" value="<%=displayStyle%>" />
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
if (!OrganizationLocalServiceUtil.getParentOrganizations(organizationId).isEmpty()) {
	PortalUtil.addPortletBreadcrumbEntry(request, OrganizationLocalServiceUtil
			.getOrganization(organizationId).getParentOrganization().getName(), customerBackURL);
   
	PortalUtil.addPortletBreadcrumbEntry(request,
			OrganizationLocalServiceUtil.getOrganization(organizationId).getName(),
			projectBackURL.toString());
	
	PortalUtil.addPortletBreadcrumbEntry(request, cidefinition.getString("CI_Name"),newBackURL.toString());
	
	PortalUtil.addPortletBreadcrumbEntry(request, "CI Objects",backURL.toString());

	PortalUtil.addPortletBreadcrumbEntry(request, " ADD Ci object",themeDisplay.getURLCurrent());

}


%>


<div class="main-content-area">
   <div class="container-fluid">
    <div class="row">
      <div class="col-md-6">
	             <a href="<%=backURL.toString()%>"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i> Add CI Object </a>
	  </div>			
    </div>
    <hr class="devider" />
  </div>
  
  
  <div class="user-form mt-30 user-wrapper-form">
  
  
      
    <aui:form   action="${addCiobjectURL} " method="post" name="form" >
		 <aui:fieldset-group markupView="lexicon">
		 
		 	
		 <liferay-ui:tabs names="CIObject Properties, Inherited Properties, Supported Group IDs, Secret IDs" refresh="false"   >
			       <liferay-ui:section>
			       
						  <aui:input name="cidefinitionid" value="<%=cidefinitionid%>" type="hidden" > </aui:input>
					     <aui:input type="hidden" name="organizationId" value="<%=organizationId%>"></aui:input>
					     
					     
					     <%-- <aui:input type="hidden" name="<portlet:namespace />propertyname" ></aui:input> --%> 
					     <div class="form-fields-content">
					     <aui:row>
					     <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="CI Object and CI Definition Name property" >
					        <aui:col span="6">
						      <div class="input-feild">
							     <div class="form-group">
								  <aui:input label="CI Object Name" class="form-control input-default" type="text" name="ciobjectname" value="" required="true">
								  <aui:validator name="alpha" errorMessage="Accept Alphabates only"/>
				                  <aui:validator name="maxLength">20</aui:validator>
								  </aui:input>
				
							    </div>
						     </div>
						    </aui:col> 
						    
						    <aui:col span="6">
						    
						   
						    
						      <div class="input-feild">
							     <div class="form-group">
								  <aui:select label="Technology{Type}" class="form-control input-default" id="technology" name="technology" required="true">
									   <%
							           if(!ttechnologyCustomerMap.isEmpty())
							           {
									    for(TTechnologyCustomerMap tTechnologyCustomerMap:ttechnologyCustomerMap)
									    {
									    	String techname= tTechnologyCustomerMap.getName().toString();
									    	long techid=tTechnologyCustomerMap.getTowerTechnologyId();
									    	
									    	
									    	
									    
									    %>
											   <aui:option value="<%=String.valueOf(techid)%>"><%=techname%></aui:option>
						                        
										<%
									     }
							           }
									   
							           else{
									     %> 
									     
									     <aui:option value=" " >No Technology Mapped</aui:option>
									     
									     <%} %>
								  </aui:select>
								  
							    </div>
						     </div>
						     
						     
						    </aui:col> 
						    
						    
						    <aui:col span="6">
						     <div class="input-feild">
						      <div class="form-group">
							   <aui:input label="CI Definition" class="form-control input-default" type="text" name="ciname" value="<%=cidefinition.get(CIDefinitionPortletKeys.CI_NAME)%>" readonly="readonly"></aui:input>
			                    
						      </div>
					         </div>
					       </aui:col>
					       
					       
					       
					       <aui:col span="6">
						     
						     
						    </aui:col>
					       
					       
					       </aui:fieldset>
					      </aui:row>
					      </div>
					      
								      		      
					      <div class="form-fields-content" id="space">
					        <aui:row>
					              <%String label= cidefinition.get(CIDefinitionPortletKeys.CI_NAME).toString()+" "+"Properties";
					             
					              %>
					              <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="<%=label%>" >
					              <div  id="overflowTest">
					              <%
					              String [] keyArray = new String[]{CIDefinitionPortletKeys.CHANGEHISTORY, CIDefinitionPortletKeys.DESCRIPTION, CIDefinitionPortletKeys.CI_NAME, CIDefinitionPortletKeys.INHERITED_CLASS, "_rev", "_id", "_key",CIDefinitionPortletKeys.STATUS};
									 
									 JSONArray jsnArray = cidefinition.names ();
									 
									 String[] jsnkeyArray =new String[jsnArray.length()]; 
									 
									 for(int i=0; i<jsnArray.length(); i++)
									  { 
										 jsnkeyArray[i]= jsnArray.getString(i);
					                  } 
									 
									 List<String> list1 = Arrays.asList(jsnkeyArray);
									 List<String> list2 =Arrays.asList(keyArray);
									
									 HashSet<String> union = new HashSet<String>(list1);
									 union.addAll(list2);
									 
									 HashSet<String> intersection =new HashSet<String>(list1);
									 intersection.retainAll(list2);
									 
									 union.removeAll(intersection);
									 
									  int j=1;
									  boolean odd=true;
									 for(String propertyName: union)
									 {
										
										String ismandtry= cidefinition.getJSONObject(propertyName).getString("isMandatory");
										String propertyname= "propertyname"+j;
										String propertyvalue= "propertyvalue"+j;
										String type= cidefinition.getJSONObject(propertyName).getString("type");
										
					              
					              %>
					              
			                            <aui:input class="form-control input-default" type="hidden" name="<%=propertyname%>" value="<%=propertyName%>" ></aui:input>
					             
					               <%
					               if(ismandtry.equalsIgnoreCase("true"))
					               {
					            	  if(odd)
					            	  {
					            	   if(type.equalsIgnoreCase("singleref"))
					            	   {
					            	            
					               %> 
					               <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propertyvalue %>">
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to add Single Refrence" required="true" readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                   </aui:col>
					                <% } 
					            	   
					            	   else if(type.equalsIgnoreCase("multipleref"))
					            	   {
					            	                  
					               %> 
					               <aui:col span="6">
					                 <aui:col span="10">
					                  <div class="input-feild">
					                   <div class="form-group" id="formgroup"> 
					                    <div id="<%=propertyvalue %>">  
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to multiple reference" required="true" readonly="readonly" ></aui:input>
					                    </div>
					                    </div>
					                  </div>
					                </aui:col>
					                       <aui:col span="2">
								                 <div id="add">
								                   <a onClick="multiplePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
											               <i class="ci icon-add-1"></i>
										           </a> 
										         </div> 
								           </aui:col>
					               </aui:col>
					                <% } 
					            	   
					            	   else{%>
					                         <aui:col span="6">
					                         <aui:col span="10">
					                            <div class="input-feild">
					                             <div class="form-group" id="formgroup">  
					                                <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>"  required="true" ></aui:input>
					                             </div>
					                            </div>
					                            </aui:col>
					                            <aui:col span="2">
					                            </aui:col>
					                           </aui:col>  
					               
					              <%         }
					            	   odd=false;
					            	   }else
					            	     {
					            		  
							            	   if(type.equalsIgnoreCase("singleref"))
							            	   {
							            	            
							               %> 
							               <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propertyvalue %>">
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to add Single Refrence" required="true" readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                       </aui:col>
					                       		               
							                <%
							                   } 
							            	   
							            	   else if(type.equalsIgnoreCase("multipleref"))
							            	   {
							            	                  
							               %> 
							               <aui:col span="6">
					                 <aui:col span="10">
					                  <div class="input-feild">
					                   <div class="form-group" id="formgroup"> 
					                    <div id="<%=propertyvalue %>">  
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to multiple reference" required="true" readonly="readonly" ></aui:input>
					                    </div>
					                    </div>
					                  </div>
					                </aui:col>
					                       <aui:col span="2">
								                 <div id="add">
								                   <a onClick="multiplePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
											               <i class="ci icon-add-1"></i>
										           </a> 
										         </div> 
								           </aui:col>
					               </aui:col>
							                <% } 
							            	   
							            	   else{%>
							               
							                          <aui:col span="6">
							                           <aui:col span="10">
								                            <div class="input-feild">
								                             <div class="form-group" id="formgroup">  
								                                <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>"  required="true" ></aui:input>
								                             </div>
								                            </div>
								                       </aui:col>
								                       <aui:col span="2">
								                       </aui:col>     
					                                  </aui:col>
							              <%         }
							            	   
					            		   odd=true;
					            	     }
					            	  
					            	}else{
					            		
					            		if(odd)
					            		{  
					            		if(type.equalsIgnoreCase("singleref"))
						            	   {
						            	                  
						               %> 
						                   <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propertyvalue %>">
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to add single reference"  readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                       </aui:col>    
						                <% } 
						            	   
					            		else if(type.equalsIgnoreCase("multipleref"))
						            	   {
						            	                  
						               %> 
						                <aui:col span="6">
					                 <aui:col span="10">
					                  <div class="input-feild">
					                   <div class="form-group" id="formgroup"> 
					                    <div id="<%=propertyvalue %>">  
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to multiple reference"  readonly="readonly" ></aui:input>
					                    </div>
					                    </div>
					                  </div>
					                </aui:col>
					                       <aui:col span="2">
								                 <div id="add">
								                   <a onClick="multiplePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
											               <i class="ci icon-add-1"></i>
										           </a> 
										         </div> 
								           </aui:col>
					               </aui:col>    
						                <% } 
						            	   
						            	   else{%>
						                       <aui:col span="6">
						                        <aui:col span="10">
					                            <div class="input-feild">
					                             <div class="form-group" id="formgroup">
						                           <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>"   ></aui:input>
						                          </div>
						                          </div>
						                          </aui:col>
						                         <aui:col span="2"> 
						                         </aui:col>
						                       </aui:col>   
						               
						              <%        }
					            		odd=true;
					            	     }else{
					            	    	 if(type.equalsIgnoreCase("singleref"))
							            	   {
							            	                  
							               %> 
							                   <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propertyvalue %>">
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to add single reference"  readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                       </aui:col>   
							                <% } 
							            	   
						            		else if(type.equalsIgnoreCase("multipleref"))
							            	   {
							            	                  
							               %> 
							                <aui:col span="6">
					                 <aui:col span="10">
					                  <div class="input-feild">
					                   <div class="form-group" id="formgroup"> 
					                    <div id="<%=propertyvalue %>">  
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" placeholder="click plus icon to multiple reference"  readonly="readonly" ></aui:input>
					                    </div>
					                    </div>
					                  </div>
					                </aui:col>
					                       <aui:col span="2">
								                 <div id="add">
								                   <a onClick="multiplePopup(this)" datalabel="<%=propertyName%>" id ="<%=propertyvalue %>" name="<%=propertyvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
											               <i class="ci icon-add-1"></i>
										           </a> 
										         </div> 
								           </aui:col>
					               </aui:col>   
							                <% } 
							            	   
							            	   else{%>
							                       <aui:col  span="6">
							                       <aui:col span="10">
						                            <div class="input-feild">
						                             <div class="form-group" id="formgroup">
							                           <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>"   ></aui:input>
							                          </div>
							                          </div>
							                        </aui:col>
							                        <aui:col span="2">
							                        </aui:col>  
							                       </aui:col>   
							               
							              <%        }
						            		odd=false;
						            	    
					            	    	 
					            	          }
					            		
					            	   }
					              
					               j++;
					            	 }%>           
					              <aui:input type="hidden" name="count" value="<%=j%>"></aui:input>
					              </div>
								 </aui:fieldset>
					         </aui:row>
					         
					         </div>
					         <div id="next">
					         <aui:button  value="click Inherited Properties tab" name="NEXT" />
					         </div>
					</liferay-ui:section>
		      
				   <liferay-ui:section>
				   
								   <h3 class="header-title"><label id="">Inherited Class Properties</label></h3> 
						            
						          <div class="form-fields-content" id="space">
						            <aui:row> 
						             
						           <%
						           
						           JSONArray classids = cidefinition.getJSONArray(CIDefinitionPortletKeys.INHERITED_CLASS);
						           
						           if(classids.length()!=0)
						           {
						           int cicount=1;
						           String propcounte="";
						           int propcount=1;
						           for(int i=0; i<classids.length(); i++)
						           {
							        	 String classkey = classids.getString(i);
							        	   
							        	 JSONObject inheritedclasscidef = CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(), classkey);
							        	   
							        	 String inhertciclasskey="inhertciclasskey"+cicount;
							        	 
							        	 String inheritedlabel= inheritedclasscidef.get(CIDefinitionPortletKeys.CI_NAME).toString()+" "+"Properties";
							        	     	
							        %>    <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="<%=inheritedlabel%>" > 
							               <div  id="overflowTest"> 
											<aui:input label="CI Name" class="form-control input-default" type="hidden" name="<%=inhertciclasskey%>" value="<%=classkey%>" readonly="readonly"></aui:input>
											
								     <% 
								     
							        	 String [] keyArr = new String[]{CIDefinitionPortletKeys.CHANGEHISTORY, CIDefinitionPortletKeys.DESCRIPTION, CIDefinitionPortletKeys.CI_NAME, CIDefinitionPortletKeys.INHERITED_CLASS, "_rev", "_id", "_key",CIDefinitionPortletKeys.STATUS};
											 
										 JSONArray jsnArr = inheritedclasscidef.names ();
										 
										
											 
										 String[] jsnkeyArr =new String[jsnArr.length()]; 
										 
										
										 
										 for(int k=0; k<jsnArr.length(); k++)
										  { 
											 jsnkeyArr[k]= jsnArr.getString(k);
											 
						                  } 
										 
										 List<String> jsnkeylist = Arrays.asList(jsnkeyArr);
										 List<String> keylist =Arrays.asList(keyArr);
										
										 HashSet<String> unionof = new HashSet<String>( jsnkeylist);
										 unionof.addAll(keylist);
										 
										 HashSet<String> intersectionof =new HashSet<String>(jsnkeylist);
										 intersectionof.retainAll(keylist);
										 
										 unionof.removeAll( intersectionof);
										 boolean odd=true;
										 for(String propName: unionof)
										 {
											 
											 if(propName.equalsIgnoreCase("null"))
											 {
												continue;
											 }
											 else{
											    String ismandatory= inheritedclasscidef.getJSONObject(propName).getString("isMandatory");
												String propname= "propname"+propcount;
												String propvalue= "propvalue"+propcount;
												String type = inheritedclasscidef.getJSONObject(propName).getString("type");
												
									 %>
				                         <aui:input class="form-control input-default" type="hidden" name="<%=propname%>" value="<%=propName%>" ></aui:input>
						             
						              <% if(ismandatory.equalsIgnoreCase("true")) 
						                  {
						            	  if(odd)
						            	  {
						            	   if(type.equalsIgnoreCase("singleref"))
						            	   {   
						               %> 
						               
						               <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propvalue %>">
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to add single reference" required="true" readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propName%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                   </aui:col>
						                
						                <% } 
							            	   
						            		else if(type.equalsIgnoreCase("multipleref"))
							            	   {
							            	                  
							            %>
							               
							            <aui:col span="6">
								                 <aui:col span="10">
								                  <div class="input-feild">
								                   <div class="form-group" id="formgroup"> 
								                    <div id="<%=propvalue %>">  
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to multiple reference" required="true" readonly="readonly" ></aui:input>
								                    </div>
								                    </div>
								                  </div>
								                </aui:col>
								                       <aui:col span="2">
											                 <div id="add">
											                   <a onClick="multiplePopup(this)" datalabel="<%=propname%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
														               <i class="ci icon-add-1"></i>
													           </a> 
													         </div> 
											           </aui:col>
					                      </aui:col> 
							                
						                
						                <% } 
						            	   
						            	   else{
						            	   
						            	%>         
						            	
						                         <aui:col span="6">
						                          <aui:col span="10">
						                            <div class="input-feild">
						                             <div class="form-group" id="formgroup">  
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" required="true"></aui:input>
						                             </div>
						                            </div>
						                           </aui:col>
						                           <aui:col span="2">
						                           </aui:col>
						                           </aui:col>  
						                
						                <%      }
						            	   odd=false;
						            	   }else
						            	     {
						            		  
								            	 if(type.equalsIgnoreCase("singleref"))
								            	   {
								            	            
								               %> 
								                      <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propvalue %>">
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to add single reference" required="true" readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propName%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                   </aui:col>
						                
						                
						                <%          } 
							            	   
						            		else if(type.equalsIgnoreCase("multipleref"))
							            	   {
							            	                  
							            %>
							               
							            <aui:col span="6">
								                 <aui:col span="10">
								                  <div class="input-feild">
								                   <div class="form-group" id="formgroup"> 
								                    <div id="<%=propvalue %>">  
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to multiple reference" required="true" readonly="readonly" ></aui:input>
								                    </div>
								                    </div>
								                  </div>
								                </aui:col>
								                       <aui:col span="2">
											                 <div id="add">
											                   <a onClick="multiplePopup(this)" datalabel="<%=propName%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
														               <i class="ci icon-add-1"></i>
													           </a> 
													         </div> 
											           </aui:col>
					                      </aui:col> 
						                
						                <%   } 
						            	   
						            	   else{
						            	   
						            	%>         
						            	
						                         <aui:col span="6">
						                         <aui:col span="10">
						                            <div class="input-feild">
						                             <div class="form-group" id="formgroup">  
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" required="true"></aui:input>
						                             </div>
						                            </div>
						                        </aui:col>
						                        <aui:col span="2">
						                        </aui:col>
						                           </aui:col>  
						                
						                <%      }
						            	   odd=true;
						            	
						            	     }    
								               
						                
						              }else{   
								            	  if(odd)
								            	  {
						                       	   if(type.equalsIgnoreCase("singleref"))
						            	   {   
						               %> 
						               
						                      <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propvalue %>">
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to add single reference"  readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propName%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                         </aui:col>
						                
						                <% } 
							            	   
						            		else if(type.equalsIgnoreCase("multipleref"))
							            	   {
							            	                  
							            %>
							               
							            <aui:col span="6">
								                 <aui:col span="10">
								                  <div class="input-feild">
								                   <div class="form-group" id="formgroup"> 
								                    <div id="<%=propvalue %>">  
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to add multiple reference"  readonly="readonly" ></aui:input>
								                    </div>
								                    </div>
								                  </div>
								                </aui:col>
								                       <aui:col span="2">
											                 <div id="add">
											                   <a onClick="multiplePopup(this)" datalabel="<%=propName%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
														               <i class="ci icon-add-1"></i>
													           </a> 
													         </div> 
											           </aui:col>
					                      </aui:col>  
							                
						                
						                <% } 
						            	   
						            	   else{
						            	   
						            	%>         
						            	
						                         <aui:col span="6">
						                          <aui:col span="10">
						                            <div class="input-feild">
						                             <div class="form-group" id="formgroup">  
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" ></aui:input>
						                             </div>
						                            </div>
						                           </aui:col>
						                           <aui:col span="2">  
						                           </aui:col>
						                           </aui:col>
						                
						                <%      }
						            	   odd=false;
						            	   }else
						            	     {
						            		  
								            	 if(type.equalsIgnoreCase("singleref"))
								            	   {
								            	            
								               %> 
								                    <aui:col span="6">
							                    <aui:col span="10">
								                 <div class="input-feild">
								                   <div class="form-group" id="formgroup">
								                   <div id="<%=propvalue %>">
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to add single reference"  readonly="readonly" ></aui:input>
				     			                   </div>
				     			                   
								                  </div>
								                  </div>
								                 </aui:col>
								                  <aui:col span="2">
									                  <div id="add">
									                  <a onClick="singlePopup(this)" datalabel="<%=propName%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add singlerefrence Object">
												               <i class="ci icon-add-1"></i>
											          </a> 
										          </div> 
										         </aui:col>
										         
					                         </aui:col>
						                
						                <%          } 
							            	   
						            		else if(type.equalsIgnoreCase("multipleref"))
							            	   {
							            	                  
							            %>
							               
							            <aui:col span="6">
								                 <aui:col span="10">
								                  <div class="input-feild">
								                   <div class="form-group" id="formgroup"> 
								                    <div id="<%=propvalue %>">  
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to multiple reference"  readonly="readonly" ></aui:input>
								                    </div>
								                    </div>
								                  </div>
								                </aui:col>
								                       <aui:col span="2">
											                 <div id="add">
											                   <a onClick="multiplePopup(this)" datalabel="<%=propName%>" id ="<%=propvalue %>" name="<%=propvalue%>" class="btn-" data-toggle="tooltip" data-original-title="Add multiplerefrence Object">
														               <i class="ci icon-add-1"></i>
													           </a> 
													         </div> 
											           </aui:col>
					                      </aui:col> 
						                
						                <%   } 
						            	   
						            	   else{
						            	   
						            	%>         
						            	
						                         <aui:col span="6">
						                          <aui:col span="10">
						                            <div class="input-feild">
						                             <div class="form-group" id="formgroup">  
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" ></aui:input>
						                             </div>
						                            </div>
						                           </aui:col> 
						                           <aui:col span="2">
						                           </aui:col>
						                           </aui:col> 
						                
						                <%      }
						            	   odd=true;
						            	
						            	     }
								            	  
						                     }
						              propcount++;
						               }
										 }	
										 propcounte=propcounte+","+propcount;
										 
										 cicount++;
										%>
										</div>
										</aui:fieldset>
										<% 
						               } 
						           
						           %>
						           
								   <aui:input type="hidden" name="propcount" value="<%=propcounte%>"></aui:input>
								    <aui:input type="hidden" name="cicount" value="<%=cicount%>"></aui:input>
								   <%}else{ %> 
								         <p>This Class dont have inherited classes</p>
								   <%} %>
								   
								 </aui:row>       
						        </div>	
				           
						            <div id="next">
							         <aui:button  value="click Supported IDs tab" name="NEXT" />
							         
							         </div>
						    
								        			        
				   </liferay-ui:section>
				   
				   <liferay-ui:section>
				        
				       <%  Organization organization=null;
						organization = OrganizationLocalServiceUtil
								.getOrganization(organizationId);
						
				       %>
				        
				        <div class="user-form mt-30 user-wrapper-form">
				      
				                                          <a href="javascript:void(0)" id="assignOwnerGroupsToOrgId"	
																class="btn btn-primary" data-toggle="tooltip" title="supportedBy"	
																data-original-title="Assign Supported Groups" onclick='assignOwnerGroupToOrg(<%=String.valueOf(organization.getOrganizationId())+",\""+String.valueOf(organization.getName())+"\""%>);'>
																<i	class="ci icon-assign-role-user"></i>Assign Supported Group 	
																
							                                </a> 
				       
				       
					   
					   <hr class="devider" />
					   <aui:row>
					     
					     <div  id="overflowTest1"> 
					        <aui:col span="4">
						      <div class="input-feild">
							     <div class="form-group" id="innerspace" >
								  	<div id="labelname">
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
						    
						    </aui:row>
					   
					   </div>
					   
					         <div id="next1">
					         <aui:button  value="click Secret IDs tab" name="NEXT" />
					         </div>
				
					   	    
				   </liferay-ui:section>
				   
				   <liferay-ui:section>
				   
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
				   
				   </liferay-ui:section>
     </liferay-ui:tabs>

		 </aui:fieldset-group>				
    
    </aui:form>
    
  </div>
</div>



<aui:script>
function singlePopup(item)
{
	var selectedval="";
	var id = $(item).attr("id");
	var propname=$(item).attr("datalabel");
	var name = $(item).attr("name");
	
	
	selectedval=id+","+propname+","+name;
	
	
	AUI().use('aui-base',
            'liferay-util-window','liferay-portlet-url','aui-node',function(A) {    
		
		var url = '${singlerefUrl}'+"&<portlet:namespace />selectedvalues="+selectedval;
	window.popUpWindow=Liferay.Util.Window.getWindow(
	  {
	            dialog: {
	                      centered: true,
	                      constrain2view: true,
	                      modal: true,
	                      destroyOnHide:false,
	                      resizable: false,
							width: 1000,
							height: 500,
	                     },
	            id: 'AddsinglerefDialog',
	            title: 'Add Singleref',
	            uri: url
	  });
	
	});
}

</aui:script>



<aui:script>
function multiplePopup(item)
{
	
	var id = $(item).attr("id");
	var propname=$(item).attr("datalabel");
	var name = $(item).attr("name");
	
	
	
	selectedval=id+","+propname+","+name;
	
	
	AUI().use('aui-base',
            'liferay-util-window','liferay-portlet-url','aui-node',function(A) {    
		
		var url = '${multiplerefUrl}'+"&<portlet:namespace />selectedvalues="+selectedval;
	window.popUpWindow=Liferay.Util.Window.getWindow(
	  {
	            dialog: {
	                      centered: true,
	                      constrain2view: true,
	                      modal: true,
	                      destroyOnHide:false,
	                      resizable: false,
							width: 1000,
							height: 500,
	                     },
	            id: 'AddmultiplerefDialog',
	            title: 'Add Multipleref',
	            uri: url
	  });
	
	});
}

</aui:script>

<aui:script>

function parentMethod(selectedval)
{
	
	
	
	var object= selectedval[0];
	
	var id=object["id"];
	var label=object["label"];
	
	var value=object["value"];
	var name=object["name"];
	
	var valueid=object["valueid"];
	
	 
	
      document.getElementById(id).innerHTML = "";	
	     
	 
					 var x = document.createElement("LABEL");
					  var t = document.createTextNode(label);
					  x.setAttribute("for", id);
					  x.setAttribute("class", "lbl");
					  x.appendChild(t);
					  document.getElementById(id).appendChild(x);
		
	 
					 var z = document.createElement("INPUT");
					 z.setAttribute("type", "text");
					 z.setAttribute("label", label);
					 z.setAttribute("value", value);
					 z.setAttribute("Name", "<portlet:namespace />"+id);
					 z.setAttribute("class", "form-control input-default");
					 z.setAttribute("readonly", "readonly");
					 
					 document.getElementById(id).appendChild(z);
	 
		
		window.popUpWindow.destroy();
}

</aui:script>




<aui:script>

function parentMethodformultiref(selectedval)
{
	var object= selectedval[0];
	var id=object["id"];
	var label=object["label"];
	var newid = id.split("_");
	var actulid= newid[4];
	
	document.getElementById(actulid).innerHTML = "";	
	
	var value="";
	var finalval="";
	for(var cont=0; cont<selectedval.length; cont++)	
	{
		      var obj = selectedval[cont];
		      
		      value = value+obj["value"]+",";
			   
			   
	}
	finalval="["+value+"]" ;   
         var x = document.createElement("LABEL");
		  var t = document.createTextNode(label);
		  x.setAttribute("for", actulid);
		  x.setAttribute("class", "lbl");
		  x.appendChild(t);
		  document.getElementById(actulid).appendChild(x);


		 var z = document.createElement("INPUT");
		 z.setAttribute("type", "text");
		 z.setAttribute("label", label);
		 z.setAttribute("value", finalval);
		 z.setAttribute("Name", "<portlet:namespace />"+actulid);
		 z.setAttribute("class", "form-control input-default");
		 z.setAttribute("readonly", "readonly");
		 
		 document.getElementById(actulid).appendChild(z);
         
		
		window.popUpWindow.destroy();
}

</aui:script>
   
<aui:script>
AUI().use('aui-base', function(A){
A.one("#<portlet:namespace/>technology").on('change',function(){
var selectedValue = A.one('#<portlet:namespace/>technology').get('value');
 
})

});
</aui:script>



<!-- popup for assign competencygroupid  -->	
<portlet:actionURL name="addsupportedBy" var="addsupportedByURL">	
	<portlet:param name="redirect" value="<%=themeDisplay.getURLCurrent()%>"/>	
</portlet:actionURL>	
<%@ include file="/html/cidefinition/supportedBy.jspf" %>

<portlet:resourceURL var="getOrgRoleUserList">	
			<portlet:param name="<%=Constants.CMD %>" value="getOrgRoleUserList"/>	
		</portlet:resourceURL>

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
	System.out.println("Exception"+ ex);
}


%>
