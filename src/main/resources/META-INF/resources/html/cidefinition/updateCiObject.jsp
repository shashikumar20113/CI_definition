<%@page import="java.util.Objects"%>
<%@page import="com.arangodb.entity.BaseDocument"%>
<%@page import="com.liferay.taglib.aui.AlertTag"%>
<%@page import="com.lti.itops.ipac.cidefinition.portlet.CIDefinitionPortlet"%>
<%@page import="com.lti.itops.ipac.cidefinition.permission.CIDefinitionPermission"%>
<%@page import="java.util.Date"%>
<%@page import="java.security.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.liferay.portal.kernel.util.CalendarFactoryUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.lti.itops.ipac.spmgmt.service.TowerLocalServiceUtil"%>
<%@page import="java.util.Set"%>
<%@page import="com.lti.itops.ipac.custcatmgmt.service.TTechnologyCustomerMapLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.spmgmt.model.TowerTechnologyMap"%>
<%@page import="com.lti.itops.ipac.spmgmt.service.TowerTechnologyMapLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.custcatmgmt.service.TowerCustomerMapLocalServiceUtil"%>
<%@page import="com.lti.itops.ipac.custcatmgmt.model.TTechnologyCustomerMap"%>
<%@page import="com.lti.itops.ipac.custcatmgmt.model.TowerCustomerMap"%>
<%@page import="com.lti.itops.ipac.spmgmt.model.Tower"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.kernel.json.JSONArray"%>
<%@page import="com.liferay.portal.kernel.json.JSON"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@ include file="init.jsp"%>
<%@ include file="/html/cidefinition/navigation.jsp" %>

<%@page import="com.liferay.portal.kernel.util.Constants"%>


<style>
#overflowTest1
{
 
 
  padding-top: 0px;
  padding-right: 0px;
  padding-bottom: 0px;
  padding-left: 0px;
  width: 50%;
  height: 100px;
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

    String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
	
	String key= ParamUtil.getString(request, "key");
	
	String cidefinitionid =ParamUtil.getString(request, "cidefinitionid");
	
	String cidefinitionkey =ParamUtil.getString(request, "cidefinitionkey");
	
	long organizationId = ParamUtil.getLong(request, "organizationId");
	
	JSONObject cidefinition=null;
	
	
	JSONObject ciobject=null;
	ciobject=CIDefinitionUtil.getCIObjectAsJSON(themeDisplay.getCompanyId(), key);
	
	JSONObject ciObj=null;
	ciObj=CIDefinitionUtil.getCIObjectAsJSON(themeDisplay.getCompanyId(), key);

	cidefinition= CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(),cidefinitionkey);

%>
<portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
<portlet:param name="cidefinitionid" value="<%=cidefinitionid%>" />
<portlet:param name="displayStyle" value="<%=displayStyle%>" />
<portlet:param name="cidefinitionkey" value="<%=String.valueOf(cidefinitionkey)%>" /> 
<portlet:param name="organizationId" value="<%= String.valueOf(organizationId)%>"/>
</portlet:renderURL>

<portlet:actionURL var="updateCiobjectURL" name="updateCiobject">
    <portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
    <portlet:param name="displayStyle" value="<%=displayStyle%>" />
    <portlet:param name="cidefinitionid" value="<%=cidefinitionid%>" />
    <portlet:param name="cidefinitionkey" value="<%=String.valueOf(cidefinitionkey)%>" /> 
    <portlet:param name="organizationId" value="<%= String.valueOf(organizationId)%>"/>
</portlet:actionURL>

<portlet:actionURL var="updateCompetencyGroupIdURL" name="updateCompetencyGroupId">
    <portlet:param name="mvcPath" value="/html/cidefinition/displayciObject.jsp"/>
    <portlet:param name="displayStyle" value="<%=displayStyle%>" />
    <portlet:param name="cidefinitionid" value="<%=cidefinitionid%>" />
    <portlet:param name="cidefinitionkey" value="<%=String.valueOf(cidefinitionkey)%>" /> 
    <portlet:param name="organizationId" value="<%= String.valueOf(organizationId)%>"/>
</portlet:actionURL>

<portlet:actionURL var="getChangeHistoryURL" name="getChangeHistory">
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

<portlet:renderURL var="singlerefUrl" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcPath" value="/html/cidefinition/singlerefpopup.jsp"/>
	<portlet:param name="cidefinitionid" value="<%=String.valueOf(cidefinitionid)%>" />
</portlet:renderURL>

<portlet:renderURL var="multiplerefUrl" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcPath" value="/html/cidefinition/multiplerefpopup.jsp"/>
	<portlet:param name="cidefinitionid" value="<%=String.valueOf(cidefinitionid)%>" />
</portlet:renderURL>

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




List<Organization> ous=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), companyOrgID, null, CustomerConstants.TYPE_OU, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);

%>

<%



ciobject= CIDefinitionUtil.getCIObjectAsJSON(themeDisplay.getCompanyId(), key);



if (!OrganizationLocalServiceUtil.getParentOrganizations(organizationId).isEmpty()) {
	PortalUtil.addPortletBreadcrumbEntry(request, OrganizationLocalServiceUtil
			.getOrganization(organizationId).getParentOrganization().getName(), customerBackURL);
   
	PortalUtil.addPortletBreadcrumbEntry(request,
			OrganizationLocalServiceUtil.getOrganization(organizationId).getName(),
			projectBackURL.toString());
	
	PortalUtil.addPortletBreadcrumbEntry(request, cidefinition.getString("CI_Name"),newBackURL.toString());
	
	PortalUtil.addPortletBreadcrumbEntry(request, ciobject.getString("CI_Object"),backURL.toString());

	PortalUtil.addPortletBreadcrumbEntry(request, " Update CI Object",themeDisplay.getURLCurrent());

}








%>
<div class="main-content-area">
    <div class="container-fluid">
    <div class="row">
      <div class="col-md-6">
	             <a href="<%=backURL.toString()%>"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i> Update CI Object </a>
	  
	                
	  	</div>
    </div>
    <hr class="devider" />
    </div>
    
    <div class="user-form mt-30 user-wrapper-form">
         
            
            
            <liferay-ui:tabs names="CIObject Properties, Inherited Properties, Supported Group IDs, Secret IDs, View ChangeHistory" refresh="false"   >
            <aui:form   action="${updateCiobjectURL} " method="post" name="form" >
            <aui:fieldset-group markupView="lexicon">
                <liferay-ui:section>
                 <input name="<portlet:namespace />key" value="<%=key%>" type="hidden" />
                 <%-- <input name="<portlet:namespace />dynamicfields" type="hidden" ></input>
                 <input type="hidden" name="<portlet:namespace />propertyname"></input> --%>
                 
                 
                 
                 
                 <div class="form-fields-content">
                   <aui:row>
					     <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="CI Object and CI Name Property" > 
					     
					     
					      <aui:col span="6">
				                    <div class="input-feild">
							         <div class="form-group">	 
								          <aui:input label="CI Object Name" class="form-control input-default" type="text" name="ciobjectname" value="<%=ciobject.get("CI_Object")%>" required="true"  >
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
								  try{
								  List<TowerCustomerMap> twrCustomerMaps = new ArrayList<TowerCustomerMap>();
								  
								  twrCustomerMaps = TowerCustomerMapLocalServiceUtil
											.findActiveTowerCustomerMapByOrganizationId(organizationId);
								  
								  if(!twrCustomerMaps.isEmpty())
								  {
								  	
								  	for (TowerCustomerMap twrCustomerMap : twrCustomerMaps) 
								  	{
								  		long orgId = twrCustomerMap.getOrganizationId();
								  		
								  		List<TTechnologyCustomerMap> towerTechnologyCustomerMaps = new ArrayList<TTechnologyCustomerMap>();
								  		
								  		String technologyId= ciobject.get(CIDefinitionPortletKeys.TECHNOLOGY_ID).toString();
								  	
								  		
								  		long tId= Long.parseLong(technologyId);
								  		
								  		List<Long> technologyid = new ArrayList<Long>();
								  		technologyid.add(tId);
								  		
								  		towerTechnologyCustomerMaps = TTechnologyCustomerMapLocalServiceUtil
								  				.getActiveTTechnologyCustomerMapByorganizationId(orgId , technologyid);
								  		
								  		 if(!towerTechnologyCustomerMaps.isEmpty())
								         {
								 		for(TTechnologyCustomerMap towerTechnologyCustomerMap:towerTechnologyCustomerMaps )
								 		{
								 			
								 			String technName=towerTechnologyCustomerMap.getName().toString();
								 			
								 			%>
								 			<aui:option value="<%=String.valueOf(ciobject.get(CIDefinitionPortletKeys.TECHNOLOGY_ID))%>"><%=technName%></aui:option>
								 			<% 
								 			
								 			
								 		}
								 		
								         }
								  		
								  	}
								  }
								  }
								  
								  catch(NumberFormatException ex)
								  {
									  System.out.println(ex);
								  }
								  
								  %>
								  
								  
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
								          <aui:input label="CI Definition" class="form-control input-default" type="text" name="ciname" value="<%=ciobject.get("CI_Name")%>"  readonly="readonly"></aui:input>
							         </div>
						            </div>
                            </aui:col>
                           
		            </aui:fieldset>
		            </aui:row>
		          </div>
		          
		          <div class="form-fields-content" id="space">
		          
		          <aui:row>
		          
		          <%String label= ciobject.getString(CIDefinitionPortletKeys.CI_NAME)+" "+"Properties";
					             
	               %>
	                     <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="<%=label%>" >
					              <div  id="overflowTest">
					              
					              <%
					              String [] keyArray = new String[]{CIDefinitionPortletKeys.CHANGEHISTORY, CIDefinitionPortletKeys.CI_NAME, CIDefinitionPortletKeys.INHERITED, "_rev", "_id", "_key",CIDefinitionPortletKeys.STATUS, CIDefinitionPortletKeys.ASSIGN_OWNER, CIDefinitionPortletKeys.ASSIGN_OWNER_GROUP,CIDefinitionPortletKeys.INBOUND, CIDefinitionPortletKeys.OUTBOUND,CIDefinitionPortletKeys.SECRET_ID,CIDefinitionPortletKeys.SUPPORTEDBY,CIDefinitionPortletKeys.TECHNOLOGY_ID,CIDefinitionPortletKeys.CI_OBJECT,CIDefinitionPortletKeys.ORGANIZATION_ID};
									 
									 JSONArray jsnArray = ciobject.names();
									 
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
										
										String propertyValue=ciobject.get(propertyName).toString();
									 
					              
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
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>" required="true" readonly="readonly" ></aui:input>
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
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>" required="true" readonly="readonly" ></aui:input>
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
					                                <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>" required="true" ></aui:input>
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
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>" required="true" readonly="readonly" ></aui:input>
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
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>" required="true" readonly="readonly" ></aui:input>
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
								                                <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>"  required="true" ></aui:input>
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
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>"  readonly="readonly" ></aui:input>
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
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>" readonly="readonly" ></aui:input>
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
						                           <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>"  ></aui:input>
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
								                       <aui:input datalabel="<%=propertyName%>" label="<%=propertyName %>"  id ="<%=propertyName %>" class="form-control input-default" type="text" name="<%=propertyvalue%>"  value="<%=propertyValue%>" readonly="readonly" ></aui:input>
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
					                      <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>"  readonly="readonly" ></aui:input>
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
							                           <aui:input label="<%=propertyName %>"  class="form-control input-default" type="text" name="<%=propertyvalue%>" value="<%=propertyValue%>"  ></aui:input>
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
		          </liferay-ui:section>  
		            
		            
		          <liferay-ui:section>
		          <h3 class="header-title"><label id="">Inherited Class Properties</label></h3> 
						            
						          <div class="form-fields-content" id="space">
						            <aui:row> 
						             
						           <%
						           
						           JSONArray classids = ciobject.getJSONArray(CIDefinitionPortletKeys.INHERITED);
						           
						           if(classids.length()!=0)
						           {
						           int cicount=1;
						           String propcounte="";
						           int propcount=1;
						           for(int i=0; i<classids.length(); i++)
						           {
						        	   JSONObject jsnobject = classids.getJSONObject(i);
						        	   
						        	   String classkey = jsnobject.get("id").toString();
						        	   
							        	   
							        	 JSONObject inheritedclasscidef =CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(), classkey);
							        	   
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
												 
												 try{
											    String ismandatory= inheritedclasscidef.getJSONObject(propName).getString("isMandatory");
												String propname= "propname"+propcount;
												String propvalue= "propvalue"+propcount;
												String type = inheritedclasscidef.getJSONObject(propName).getString("type");
												
												String propValue=jsnobject.get(propName).toString();
												
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
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>" required="true" readonly="readonly" ></aui:input>
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
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>" required="true" readonly="readonly" ></aui:input>
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
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>" required="true"></aui:input>
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
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>" required="true" readonly="readonly" ></aui:input>
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
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>" required="true" readonly="readonly" ></aui:input>
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
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>" required="true"></aui:input>
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
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>"  readonly="readonly" ></aui:input>
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
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>"  readonly="readonly" ></aui:input>
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
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>" ></aui:input>
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
								                       <aui:input datalabel="<%=propName%>" label="<%=propName %>"  id ="<%=propname %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>"  readonly="readonly" ></aui:input>
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
								                      <aui:input label="<%=propName %>"  class="form-control input-default" type="text" name="<%=propvalue%>" placeholder="click plus icon to multiple reference" value="<%=propValue%>" readonly="readonly" ></aui:input>
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
						                                 <aui:input  label="<%=propName %>" class="form-control input-default" type="text" name="<%=propvalue%>" value="<%=propValue%>"></aui:input>
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
												 catch(NullPointerException ex)
												 {
													 System.out.println(ex);
												 }
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
							    
							    <aui:button-row>
								 <aui:button type="submit" name="save" ></aui:button>
								 <aui:button type="cancel" href="<%=backURL.toString()%>"></aui:button>
						        </aui:button-row> 
				          
                 </liferay-ui:section>  
                 </aui:fieldset-group>
         
                 </aui:form>    
                 
                  <liferay-ui:section> 
                  
                                                  
                  
                  <div class="user-form mt-30 user-wrapper-form">
                          <a href="javascript:void(0)" id="assignSupportedGroupsToOrg"	
							class="btn btn-primary" data-toggle="tooltip" title="supportedBy"	
							data-original-title="Assign Supported Groups" onclick='assignsupportedGroupToOrg(<%=String.valueOf(organizationId)+",\""+String.valueOf(key)+"\""%>);'>
							<i	class="nav-item-icon icon-cog"></i>Assign Supported Group 	
																
						 </a>                           
                  
                 <hr class="devider" />
         <aui:form   action="${updateCompetencyGroupIdURL} " method="post" name="form" >
         
           <aui:fieldset-group markupView="lexicon">
           
           <input name="<portlet:namespace />key" value="<%=key%>" type="hidden" />
           
           <aui:row>
					     <h5>Assigned Supported Group </h5>
					     <div  id="overflowTest1"> 
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
								  			
								  			<input type="text" class="form-control input-default" name="<portlet:namespace />competency" id="competency" value="<%=competecygrpName%>" readonly="readonly"></input>
								  			
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
						    
						    
						    
					     
						    
						    
						    <!-- <div class="input-feild">
							     <div class="form-group" id="innerspace" >
								  	<div id="labelname">
								  	
								  	</div>			
							    </div>
						     </div> -->
						    
						    
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
<%--      <div>
      <aui:form   action="${updateChangeHistoryURL} " method="post" name="form" >
         
           <aui:fieldset-group markupView="lexicon">
           
           <input name="<portlet:namespace />key" value="<%=key%>" type="hidden" />
           
           
           <aui:row>
           </aui:row>
           </aui:fieldset-group>
           </aui:form>
           
     </div> --%>
     
                  
                  
                  </liferay-ui:section>
                  
                   <liferay-ui:section> 
                  </liferay-ui:section>
                  
            
            <aui:form  action="${getChangeHistoryURL} " method="post" name="form" >
            
            	<%

			

				if (CIDefinitionPermission.hasCIDefinitionViewPermission(themeDisplay)){
				PortletURL iteratorURL = renderResponse.createRenderURL();
				iteratorURL.setParameter("mvcPath", "/html/cidefinition/updateCiObject.jsp");

				iteratorURL.setParameter("cidefinitionid", cidefinitionid);
				iteratorURL.setParameter("cidefinitionkey", cidefinitionkey);
				//iteratorURL.setParameter("key", key);

				iteratorURL.setParameter("organizationId", String.valueOf(organizationId));
				iteratorURL.setParameter("displayStyle", displayStyle);
				
				List<String>  orgIds = new ArrayList<String>();
				orgIds.add(String.valueOf(organizationId));
				
				JSONObject ciobjectFor=null;
				
				ciobjectFor=CIDefinitionUtil.getCIObjectAsJSON(themeDisplay.getCompanyId(), key);
				
				//String ab=CIDefinitionPortletKeys.CHANGEHISTORY;
		  		String ChangeHistoryString= ciobjectFor.get(CIDefinitionPortletKeys.CHANGEHISTORY).toString();
		  		
		  		JSONArray chis = ciobjectFor.getJSONArray(CIDefinitionPortletKeys.CHANGEHISTORY);
		  		
		  	List<Object> list=new ArrayList<Object>();

		  			for(int i=0;i<chis.length();i++){
				  		JSONObject jsnob =chis.getJSONObject(i);
		  		list.add(jsnob)	;
		  	}			  				
		  				
		  			List<Object> ChangeHistoryList1=new ArrayList<Object>();
		  			
		  			for(int i=0;i<list.size();i++){
		  				Object j=list.get(i);
		  			ChangeHistoryList1.add(j);
		  			
		  			}
			System.out.println("deep list "+ list);
	
			System.out.println("deep change list "+  ChangeHistoryList1);
	
				System.out.println("Get zzz= "+ ChangeHistoryString);
			
				
				System.out.println("absbb shashi object= "+ciobjectFor);
				
				List<String> ChangeHistoryList=new ArrayList<String>();
				
				ChangeHistoryList.add(ChangeHistoryString);
				
				List<Object> objectList = (List)ChangeHistoryList;
				
				System.out.println("objectList="+objectList);

				System.out.println("objectList size ="+objectList.size());
				System.out.println("list abe size ="+ChangeHistoryList.size());

								
				
				List<BaseDocument> strings = new ArrayList<>(ChangeHistoryList.size());
				for (BaseDocument object : ChangeHistoryList) {
				    strings.add(Objects.toString(object));
				}
				
				System.out.println("List strings"+strings);

			//	System.out.println("Sashhi def count "+CIDefinitionUtil.getCIObjectsByOrgIdsCount(themeDisplay.getCompanyId(), orgIds, cidefinitionid));
			//System.out.println("Sashhi def "+CIDefinitionUtil.getCIObjectsByOrgIds(themeDisplay.getCompanyId(), orgIds, cidefinitionid, start, end));
				
		%>
         
           <aui:fieldset-group markupView="lexicon">
<%--            	   <%@ include file="/html/cidefinition/management-bar/toolbar.jspf"%>
 --%>           	        <div class="customer-mgmt-table">
           	                    <input id="keyValue" name="<portlet:namespace />key" value="<%=key%>" type="hidden" />
           							<liferay-ui:search-container var="ciobjectSearchContainer" emptyResultsMessage="not-found"  total="<%= objectList.size() %>" iteratorURL="<%=iteratorURL%>">
					  
					   <%-- <liferay-ui:search-container-results  results="<%=CIDefinitionUtil.getCIObjects(themeDisplay.getCompanyId(), ciobjectSearchContainer.getStart(), ciobjectSearchContainer.getEnd())%>" >
	                  </liferay-ui:search-container-results> --%>
	                  
	                  		<liferay-ui:search-container-results 
					results="<%=ListUtil.subList(strings,ciobjectSearchContainer.getStart(),ciobjectSearchContainer.getEnd())%>" />
				<%-- 	
						<liferay-ui:search-container-results 
					results="<%=CIDefinitionUtil.getCIChangeHistoryArray(themeDisplay.getCompanyId(), key)%>" /> --%>
				
						                  	
					 <liferay-ui:search-container-row className="com.arangodb.entity.BaseDocument" modelVar="basedoc"> 
					
					
	                 <%--  
	                    <%
	    				//System.out.println("Sashhi def "+CIDefinitionUtil.getCIObjectsByOrgIds(themeDisplay.getCompanyId(), orgIds, cidefinitionid, ciobjectSearchContainer.getStart(), ciobjectSearchContainer.getEnd()));
						//System.out.println("ci object shashi"+basedoc.getProperties().get(CIDefinitionPortletKeys.CI_OBJECT));
						//System.out.println("ci name shsahi "+ basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME));
						
				  		 //System.out.println("= Shashi ID ciobjectarr length"+ciobjectArray.length());
				  		 //System.out.println("= Shashi ID ciobj "+ciObj);
				  		 System.out.println("Key Shashi boss =>"+key+"<--");
				  		 
				  		 System.out.println("Shashi container = "+CIDefinitionUtil.getCIChangeHistory(themeDisplay.getCompanyId(), key, ciobjectSearchContainer.getStart(), ciobjectSearchContainer.getEnd()));
						System.out.println("change history shashi "+basedoc.getProperties().get(CIDefinitionPortletKeys.CHANGEHISTORY));
						
						System.out.println("Shashi value of displayStyle"+displayStyle);
	                    boolean check = (boolean)basedoc.getProperties().get(CIDefinitionPortletKeys.STATUS);
	        	   		
	                    JSONArray ciobjectArray = ciObj.getJSONArray(CIDefinitionPortletKeys.CHANGEHISTORY);
						
						System.out.println("ci name shsahi "+ basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME));
			
							
	                    %> 
	                   
	                     <c:choose>
	                         <c:when test='<%=displayStyle.equals("icon")%>'>
	                       
	                       --%>  				
	                       <liferay-ui:search-container-column-text name="Region Name" value="region" />
	                       <%--  
	                   <liferay-ui:search-container-column-text name="CI_Object">
	                         <h6 class="text-default">fasdfasd</h6>
	                         </liferay-ui:search-container-column-text>
	                         
	                         <% 
	                         //for (int i=0;i<ciobjectArray.length();i++){
	 	                    	if(basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME)!=null){
	 	                    		System.out.println("Inside if");
	 	                    		
	 	                    		System.out.println("key val="+key);
	 	                    		
	 	                     %>
	                          <liferay-ui:search-container-column-text name="CI_Name">
	                         <h6 class="text-default">ddssd</h6>
	                         </liferay-ui:search-container-column-text>
	                              
	                         <%}
	 	                    	
	                         //} %>
	                         <liferay-ui:search-container-column-text name="Status">
					
						<aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  /> 
	
					</liferay-ui:search-container-column-text>
	 --%>				<%-- </c:when>
					</c:choose> --%>
					

<%--                   <liferay-ui:section> 
                  <aui:row>
				                  <div class="main-content-area">
										  <div class="container-fluid">
										   <div class="row">
												<div class="col-md-6">
												          <h2 class="domain-title">Change History</h2>
										                 
														
										       </div>
										       <div class="col-md-3">&nbsp;</div>
												<div class="col-md-3">
													<div class="input-feild">
														<div class="form-group">


						<label> Select Date to retrieve
						<liferay-ui:input-date name="date" formName="dob" dayValue="5" yearValue="2020" monthValue="3" dayParam="d1" monthParam="m1" yearParam="y1" />
							</label>
<!-- 							<input  id="datepicker" name="datepicker" type="text">
 -->
							
						</div>
					</div>
				</div>

			
			</div>
									</div>s
									</div>
									
			
					</aui:row>	
						<aui:row>
					     <div  id="overflowTest"> 
					        <aui:col span="4">
						      <div class="input-feild">
					  
								  	
					<%
			   		JSONArray ciobjectArray = ciObj.getJSONArray(CIDefinitionPortletKeys.CHANGEHISTORY);
			  		/* System.out.println("= Shashi ID ciobjectarr length"+ciobjectArray.length());
			  		System.out.println("= Shashi ID ciobjectarr obj "+ciObj);
			  		System.out.println("= Shashi ID ciobjectarr arr"+ciobjectArray);
					 */
			  		
			  		
			  		//System.out.print("ciobjectArray.get(1) =="+ciobjectArray.get(1));
				 for (int i=0;i<ciobjectArray.length();i++){
					 JSONObject jsonObject=ciobjectArray.getJSONObject(i);
					 String v=jsonObject.getString("changeTimeStamp");
					 
					 if(!v.equalsIgnoreCase("Datetime")){
				  		 long va = Long.parseLong(v);
						 Date date=new Date(va);
						 DateFormat dateFormat=new SimpleDateFormat("dd/MM/yyyy");
						String formatted =dateFormat.format(date);
						//System.out.println("formatted shashi date"+formatted);
					 }
					 
					 
					 					 
					// System.out.println("VVV shashi "+v);
					 
					%>

		<aui:row>
					<input type="text" class="form-control input-default" name="<portlet:namespace />classname" value=<%=ciObj%> readonly="readonly" ></input>
		</aui:row>
						<%} 
						%>		  	
								  	</div>
								  	</aui:col>
								  	</div>
								  	</aui:row>
								  										
								<aui:button-row>
								 <aui:button type="submit" name="save" value="Execute"></aui:button>
								 <aui:button type="cancel" href="<%=backURL.toString()%>"></aui:button>
						        </aui:button-row> 
                  
                  </liferay-ui:section> --%>
                  </liferay-ui:search-container-row>
                  
                  <aui:button-row>
								 <aui:button type="submit" name="save" value="Execute" onClick="func()"></aui:button>
								 <aui:button type="cancel" href="<%=backURL.toString()%>"></aui:button>
						        </aui:button-row> 
                  
<%--                   </liferay-ui:search-container-row>
 --%>                  </liferay-ui:search-container>
                  </div>
                  </aui:fieldset-group>
                  <% } %>
                  </aui:form>
                  
                  
	         
	         </liferay-ui:tabs>
            
    </div>
</div>



<aui:script>

function func(){
    var content = $('#keyValue').text();
    var inputs = document.getElementById("keyValue");
	alert("value is "+inputs);
}

AUI().use('aui-base', function(A){
A.one("#<portlet:namespace/>technology").on('change',function(){
var selectedValue = A.one('#<portlet:namespace/>technology').get('value');
 
})

});
</aui:script>

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
	            title: 'Add singleref',
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
	            title: 'Add multipleref',
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


<portlet:actionURL name="addsupportedBy" var="addsupportedByURL">	
<portlet:param name="redirect" value="<%=themeDisplay.getURLCurrent()%>"/>	
</portlet:actionURL>	
<%@ include file="/html/cidefinition/tabSupportedby.jspf" %>

<script>
function assignsupportedGroupToOrg(organizationId, orgkey)
      {	
			
	
	    document.getElementById("<portlet:namespace />documentKey").value = orgkey;
		//clear current and available list 	
		document.getElementById("<portlet:namespace />assignsupportedbyHeaderId").innerHTML = "Assign/Unassign Supported Groups";	
		document.getElementById("<portlet:namespace />mappedSupportByList").innerHTML = "";	
		document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "";	
		document.getElementById("<portlet:namespace />statusRoleUserDivId").innerHTML = "";	
		document.getElementById("<portlet:namespace />searchRoleUser").value = "";	
		document.getElementById("<portlet:namespace />orgRoleId").value = "";	
		document.getElementById("<portlet:namespace />roleOrganizationId").value = organizationId;	
		
		
		
		
	}	
	
			
</script>

<aui:script>


AUI().use("aui-datepicker", function(Y){
	var today = new Date();
    new Y.DatePicker(
      {
    	  trigger: '#<portlet:namespace />datepicker',
    	  popover: {
              zIndex: 1000
          },
    	  calendar: {minimumDate: new Date(today.getDate(), today.getMonth(), today.getFullYear())}
      }
    );

});

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
	
	
	/* window.popUpWindow.destroy(); */
}

</aui:script>




<%
}

catch(Exception ex)

{
	System.out.println(ex);
}
%>