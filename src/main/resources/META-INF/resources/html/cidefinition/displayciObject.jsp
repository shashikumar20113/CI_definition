<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@page import="com.lti.itops.ipac.cidefinition.permission.CIDefinitionPermission"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<!--added by Shashi  -->
<%@page import="com.liferay.portal.kernel.model.Role" %>	
<%@page import="com.liferay.portal.kernel.service.RoleLocalServiceUtil" %>	
<%@page import="com.liferay.portal.kernel.util.Constants" %>	
<%@page import="com.liferay.portal.kernel.util.HttpUtil" %>
<!--  -->


<%@ include file="init.jsp" %>


<liferay-ui:error exception="<%=PrincipalException.class%>" message="permission-denied" />
<%@ include file="/html/cidefinition/navigation.jsp" %>
<%

try
  {

String cidefinitionkey = ParamUtil.getString(request, "cidefinitionkey");
String cidefinitionid =ParamUtil.getString(request, "cidefinitionid");
String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
long organizationId = ParamUtil.getLong(request, "organizationId");


/* Added By Shashi  */
int[] roleTyes = { RoleConstants.TYPE_ORGANIZATION };	
List<Role> orgRoleList = RoleLocalServiceUtil.getRoles(themeDisplay.getCompanyId(), roleTyes);	
/* ----- */


JSONObject breadcrumobjct= CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(), cidefinitionkey);

List<Organization> ous=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), companyOrgID, null, CustomerConstants.TYPE_OU, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);

%>
<portlet:renderURL var="addciobject">
<portlet:param name="mvcPath" value="/html/cidefinition/addCiObject.jsp"/>
<portlet:param name="cidefinitionkey" value="<%=String.valueOf(cidefinitionkey)%>" />
<portlet:param name="cidefinitionid" value="<%=String.valueOf(cidefinitionid)%>" />
<portlet:param name="displayStyle" value="<%=displayStyle%>" />
<portlet:param name="organizationId" value="<%=String.valueOf(organizationId)%>" />
</portlet:renderURL>


<portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/viewciDefinitionClass.jsp"/>
<portlet:param name="organizationId" value="<%= String.valueOf(organizationId)%>"/>
<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>



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


        <portlet:resourceURL var="getProjectUserListURL">	
			<portlet:param name="<%=Constants.CMD %>" value="getUserList"/> 	
		</portlet:resourceURL>	
			
		<portlet:resourceURL var="getOrgRoleUserList">	
			<portlet:param name="<%=Constants.CMD %>" value="getOrgRoleUserList"/>	
		</portlet:resourceURL>	
			
		<portlet:resourceURL var="searchPortalUsers">	
			<portlet:param name="<%=Constants.CMD %>" value="searchPortalUsers"/>	
		</portlet:resourceURL>	
			
		<portlet:resourceURL var="searchOrganizationUsers">	
			<portlet:param name="<%=Constants.CMD %>" value="searchOrganizationUsers"/>  	
		</portlet:resourceURL>	
			
		<%	
		// liferay by default adding organizationId in url , removing organizationId params from url	
		getProjectUserListURL=HttpUtil.removeParameter(getProjectUserListURL.toString(), renderResponse.getNamespace()+"organizationId");	
		getOrgRoleUserList=HttpUtil.removeParameter(getOrgRoleUserList.toString(), renderResponse.getNamespace()+"organizationId");	
		searchPortalUsers=HttpUtil.removeParameter(searchPortalUsers.toString(), renderResponse.getNamespace()+"organizationId");	
		searchOrganizationUsers=HttpUtil.removeParameter(searchOrganizationUsers.toString(), renderResponse.getNamespace()+"organizationId");	
		%>	


<!-- breadcum code -->
<%
	if (!OrganizationLocalServiceUtil.getParentOrganizations(organizationId).isEmpty()) {
	PortalUtil.addPortletBreadcrumbEntry(request, OrganizationLocalServiceUtil
	.getOrganization(organizationId).getParentOrganization().getName(), customerBackURL);
   
	PortalUtil.addPortletBreadcrumbEntry(request,
	OrganizationLocalServiceUtil.getOrganization(organizationId).getName(),
	projectBackURL.toString());
	
	PortalUtil.addPortletBreadcrumbEntry(request, breadcrumobjct.getString(CIDefinitionPortletKeys.CI_NAME),newBackURL.toString());

	PortalUtil.addPortletBreadcrumbEntry(request, "CI Objects", themeDisplay.getURLCurrent());

		}

		if (CIDefinitionPermission.hasCIDefinitionViewPermission(themeDisplay)) {

			PortletURL iteratorURL = renderResponse.createRenderURL();
			iteratorURL.setParameter("mvcPath", "/html/cidefinition/displayciObject.jsp");

			iteratorURL.setParameter("cidefinitionid", cidefinitionid);
			iteratorURL.setParameter("cidefinitionkey", cidefinitionkey);

			iteratorURL.setParameter("organizationId", String.valueOf(organizationId));
			iteratorURL.setParameter("displayStyle", displayStyle);
%>

<liferay-ui:error exception="<%=PrincipalException.class%>"
	message="permission-denied" />
	
	<div class="main-content-area">
	  <div class="container-fluid">
	   <div class="row">
			<div class="col-md-6">
			          <a href="${backURL}"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i> </a>
	                 <c:if
					test="<%=CIDefinitionPermission.hasCIDefinitionManagePermission(themeDisplay)%>">
					<a class="btn btn-primary" href="${addciobject}">
						<i class="ci icon-add-1"></i>Add CI Object
					</a>
				     </c:if>
	       </div>
	       <div class="col-md-3">&nbsp;</div>
			<div class="col-md-3">
				<div class="input-feild">
					<div class="form-group">
						<span class="ci icon-search"></span> <input
							class="form-control input-default pl-35" id="usr"
							placeholder="Search" type="text" />
					</div>
				</div>
			</div>	       
	   </div>
	        <hr class="devider" />
		    <h2 class="domain-title">CI Object</h2>  
		</div>   
		
		
		<%
		List<String>  orgIds = new ArrayList<String>();
		orgIds.add(String.valueOf(organizationId));
		/* List<String>  cidefId = new ArrayList<String>();
		cidefId.add(String.valueOf(cidefinitionid)); */
		
		%>
	   <aui:fieldset-group markupView="lexicon">
	   <%@ include file="/html/cidefinition/management-bar/toolbar.jspf"%>
	        <div class="customer-mgmt-table">
	             <liferay-ui:search-container var="ciobjectSearchContiner"
				total="<%=CIDefinitionUtil.getCIObjectsByOrgIdsCount(themeDisplay.getCompanyId(), orgIds, cidefinitionid) %>" delta="10"
				emptyResultsMessage="no-ciobject-found"
				iteratorURL="<%=iteratorURL%>">
	                  <liferay-ui:search-container-results  results="<%=CIDefinitionUtil.getCIObjectsByOrgIds(themeDisplay.getCompanyId(), orgIds, cidefinitionid, ciobjectSearchContiner.getStart(),ciobjectSearchContiner.getEnd())%>" >
	                  </liferay-ui:search-container-results> 
	                    <liferay-ui:search-container-row className="com.arangodb.entity.BaseDocument" modelVar="basedoc"> 
	                    
	                   <%boolean check = (boolean)basedoc.getProperties().get(CIDefinitionPortletKeys.STATUS);%> 
	                   
	                     <c:choose>
	                         <c:when test='<%=displayStyle.equals("list")%>'>
	                         <liferay-ui:search-container-column-text name="CIObject Name">
	                         <h6 class="text-default">
	                         <%=basedoc.getProperties().get(CIDefinitionPortletKeys.CI_OBJECT) %>
	                         </h6>
	                         </liferay-ui:search-container-column-text>
	                         
	                          <liferay-ui:search-container-column-text name="CIName">
	                         <h6 class="text-default">
	                         <%=basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME) %>
	                         </h6>
	                         </liferay-ui:search-container-column-text>
	                         
	                         
	                         <liferay-ui:search-container-column-text name="Status">
					
						<aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  /> 
	
					</liferay-ui:search-container-column-text>
					
	                         
	                         <liferay-ui:search-container-column-jsp
								path="/html/cidefinition/ciObjectaction.jsp"
								name="actions" />
	                         
	                         </c:when>
	                         <c:otherwise>
	                           <%
								row.setCssClass("entry-card lfr-asset-item");
							  %>
							    <liferay-ui:search-container-column-text>
							       
							         <div class="cust-card">
							            <div class="card-body">
							            <div class="head-row">
							              <h4><%=basedoc.getProperties().get(CIDefinitionPortletKeys.CI_OBJECT) %></h4>
							               <div class="head-row-right"><aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  /> 
	                                      </div>
	                                      </div>
							             
							                 
							                
							                   <div class="action-row mt-15">
							                   
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
															organization = OrganizationLocalServiceUtil
																	.getOrganization(organizationId);
																	
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
															<%-- <portlet:renderURL var="mapCompetencygroupId">
																<portlet:param name="mvcPath"
																	value="/html/cidefinition/mapCompetencygroupId.jsp" />
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
													         
															<a href="${mapCompetencygroupId}" id="add-cidefinition"
																class="btn-" data-toggle="tooltip" title=""
																data-original-title="AssignSupportedGroup"><i class="nav-item-icon icon-cog"></i>
															</a> --%>
															
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
							         </div>
							       
							    </liferay-ui:search-container-column-text>
	                         </c:otherwise>
	                     </c:choose>
	                    
	                  </liferay-ui:search-container-row> 
	                   <liferay-ui:search-iterator displayStyle="<%= displayStyle %>" markupView="lexicon" />
	             </liferay-ui:search-container>
	        </div>
	   </aui:fieldset-group>   
	</div>
	
	
	<!--Added by Shashi  -->
	<!-- popup for assign user -->	

	<portlet:actionURL name="updateAssignOwner" var="updateAssignOwnerURL">	
			<portlet:param name="redirect" value="<%=themeDisplay.getURLCurrent()%>"/>	
		</portlet:actionURL> 
 
	
		<%@ include file="/html/cidefinition/assignOwner.jspf" %> 
		 	
		<!-- popup for assign roles user  -->	
		<portlet:actionURL name="updateAssignOwnerGroup" var="updateAssignOwnerGroupURL">	
			<portlet:param name="redirect" value="<%=themeDisplay.getURLCurrent()%>"/>	
		</portlet:actionURL>	
		<%@ include file="/html/cidefinition/assignOwnerGroups.jspf" %>	
			
		<script>	
		
			function assignOwnerToOrg(organizationId, orgName){	
					

				
				//clear current and available list 	
				document.getElementById("<portlet:namespace />assignUserHeaderId").innerHTML = "Assign Owners ";	
				document.getElementById("<portlet:namespace />mappedUserList").innerHTML = "";	
				document.getElementById("<portlet:namespace />availableUserList").innerHTML = "";	
				document.getElementById("<portlet:namespace />statusDivId").innerHTML = "";	
				document.getElementById("<portlet:namespace />searchUser").value = "";	
				document.getElementById("<portlet:namespace />userOrganizationId").value = organizationId;	
				document.getElementById("<portlet:namespace />Key").value = orgName;	
				getUserList(organizationId);	
			} 
	 

			
			
		function getUserList(organizationId){	
			AUI().use('aui-base','liferay-portlet-url','aui-io-request',function(A){ 	
					
				if( !A.one("#<portlet:namespace />loadingDivId").hasClass('show-loading') ){	
					A.one("#<portlet:namespace />loadingDivId").addClass('show-loading');	
				}	
					
				var url="<%=getProjectUserListURL.toString()%>"; 	
					
				var resourceURL = Liferay.PortletURL.createResourceURL();	
				resourceURL.setParameter("<%=Constants.CMD %>","getUserList");	
				
				console.log(resourceURL);	
				console.log("url::"+url);	
				console.log("getUserList::  organizationId::"+organizationId);	
				A.io.request(url,{	
		            dataType: 'json',	
		            data:{	
		            	<portlet:namespace />organizationId : organizationId	
		            },	
		            cache:false, 	
		            on: {	
		               success: function() {	
		            	   	var response=this.get('responseData');	
		            	   	if(response.status){	
		            	   		document.getElementById("<portlet:namespace />mappedUserList").innerHTML = response.mappedUsers;	
			    				document.getElementById("<portlet:namespace />availableUserList").innerHTML = response.portalUsers;	
		            	   	} else {	
		            	   		var errorMsg="<div class='alert alert-danger'>"+response.msg+"</div>";	
		            	   		document.getElementById("<portlet:namespace />statusDivId").innerHTML=errorMsg;	
		            	   	}	
		    				A.one("#<portlet:namespace />loadingDivId").removeClass('show-loading');	
		               },	
		               error: function() {	
		            	   A.one("#<portlet:namespace />loadingDivId").removeClass('show-loading');	
		               }	
					}	
				});	
			});	
		}	
			
		function assignOwnerGroupToOrg(organizationId, orgName){	
			
			//clear current and available list 	
			document.getElementById("<portlet:namespace />assignRoleUserHeaderId").innerHTML = "Assign Owner Groups ";	
			document.getElementById("<portlet:namespace />mappedRoleUserList").innerHTML = "";	
			document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "";	
			document.getElementById("<portlet:namespace />statusRoleUserDivId").innerHTML = "";	
			document.getElementById("<portlet:namespace />searchRoleUser").value = "";	
			document.getElementById("<portlet:namespace />orgRoleId").value = "";	
			document.getElementById("<portlet:namespace />roleOrganizationId").value = organizationId;	
			document.getElementById("<portlet:namespace />ciObjectKey").value = orgName;
		}
		
		
		function getRoleUserList(roleId){	
				
			document.getElementById("<portlet:namespace />mappedRoleUserList").innerHTML = "";	
			document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "";	
			document.getElementById("<portlet:namespace />statusRoleUserDivId").innerHTML = "";	
			document.getElementById("<portlet:namespace />searchRoleUser").value = "";	
				
			roleId=Number(roleId);	
			if(roleId>0){	
					
				AUI().use('aui-io-request',function(A){ 	
					if( !A.one("#<portlet:namespace />roleLoadingDivId").hasClass('show-loading') ){	
						A.one("#<portlet:namespace />roleLoadingDivId").addClass('show-loading');	
					}	
					var url='<%=getOrgRoleUserList%>';	
					A.io.request(url,{	
			            dataType: 'json',	
			            data:{	
			            	<portlet:namespace />organizationId : document.getElementById("<portlet:namespace />roleOrganizationId").value,	
			            	<portlet:namespace />roleId : roleId	
			            },	
			            cache:false, 	
			            on: {	
			               success: function() {	
			            	   	var response=this.get('responseData');	
			            	   	console.log(response);	
			            	   	if(response.status){	
			            	   		document.getElementById("<portlet:namespace />mappedRoleUserList").innerHTML = response.mappedOrgRoleUsers;	
				    				document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = response.mappedOrgUsers;	
			            	   	} else {	
			            	   		var errorMsg="<div class='alert alert-danger'>"+response.msg+"</div>";	
			            	   		document.getElementById("<portlet:namespace />statusRoleUserDivId").innerHTML=errorMsg;	
			            	   	}	
			    				A.one("#<portlet:namespace />roleLoadingDivId").removeClass('show-loading');	
			               },	
			               error: function() {	
			            	   A.one("#<portlet:namespace />roleLoadingDivId").removeClass('show-loading');	
			               }	
						}	
					});	
				});	
					
			} else {	
					
			}	
		}	
			
			
		function saveAssignUsersToOrg(){	
				
			var list=document.getElementById("<portlet:namespace />availableUserList");	
			var selectedUsers = list.querySelectorAll('input[type=checkbox]:checked');	
				
			if(selectedUsers.length==0){	
				document.getElementById("<portlet:namespace />orgUserMapForm").submit();	
			} else {	
					
				var mappingUserIds = []	
				for (var i = 0; i < selectedUsers.length; i++) {	
					var id=selectedUsers[i].value;	
					mappingUserIds.push(id);	
				}	
					
				/* //add existing users	
				var mappedList=document.getElementById("<portlet:namespace />mappedUserList");	
				var mappedUserIds = mappedList.querySelectorAll('input[name=userId]');	
				for (var i = 0; i < mappedUserIds.length; i++) {	
					var id=mappedUserIds[i].value;	
					if(!isValueExist(id,mappingUserIds)){	
						mappingUserIds.push(id);	
					}	
				}	 */
					
				document.getElementById("<portlet:namespace />addUserIds").value=mappingUserIds.toString();	
				document.getElementById("<portlet:namespace />orgUserMapForm").submit();	
					
			}	
		}	
			
			
			
		function saveAssignUsersToOrgRole(){	
				
			var list=document.getElementById("<portlet:namespace />availableRoleUserList");	
			var selectedUsers = list.querySelectorAll('input[type=checkbox]:checked');	
			if(selectedUsers.length==0){	
				document.getElementById("<portlet:namespace />orgRoleUserMapForm").submit();
			} else {	
				var mappingUserIds = []	
				for (var i = 0; i < selectedUsers.length; i++) {	
					var id=selectedUsers[i].value;	
					mappingUserIds.push(id);	
				}	
				//add existing users	
				/* var mappedList=document.getElementById("<portlet:namespace />mappedRoleUserList");	
				var mappedUserIds = mappedList.querySelectorAll('input[name=userId]');	
				for (var i = 0; i < mappedUserIds.length; i++) {	
					var id=mappedUserIds[i].value;	
					if(!isValueExist(id,mappingUserIds)){	
						mappingUserIds.push(id);	
					}	
				}	 */
				document.getElementById("<portlet:namespace />addRoleUserIds").value=mappingUserIds.toString();	
				document.getElementById("<portlet:namespace />orgRoleUserMapForm").submit();	
			}	
		}	
			
		function isValueExist(value, array) {	
			return array.indexOf(value) > -1;	
		}	
			
		function searchPortalUsers(){	
			AUI().use('aui-io-request',function(A){ 	
				if( !A.one("#<portlet:namespace />loadingDivId").hasClass('show-loading') ){	
					A.one("#<portlet:namespace />loadingDivId").addClass('show-loading');	
				}	
				var keyword=document.getElementById("<portlet:namespace />searchUser").value;	
				var url='<%=searchPortalUsers%>';	
					
				//empty ul	
    	   		document.getElementById("<portlet:namespace />availableUserList").innerHTML = "";	
					
				A.io.request(url,{	
		            dataType: 'json',	
		            data:{	
		            	<portlet:namespace />keyword : keyword	
		            },	
		            cache:false, 	
		            on: {	
		               success: function() {	
		            	   	var response=this.get('responseData');	
		            	   	console.log(response);	
		            	   	if(response.status){	
		            	   		var users=response.users;	
		            	   		if(users.length>0){	
		            	   			document.getElementById("<portlet:namespace />availableUserList").innerHTML = displaySearchUsers(users);	
		            	   		} else {	
		            	   			document.getElementById("<portlet:namespace />availableUserList").innerHTML = "<li>No users found.</li>";	
		            	   		}	
		            	   	} else {	
		            	   		document.getElementById("<portlet:namespace />availableUserList").innerHTML = "<li>Error while fetching data, Please contact admin.</li>";	
		            	   	}	
		    				A.one("#<portlet:namespace />loadingDivId").removeClass('show-loading');	
		               },	
		               error: function() {	
		            	   A.one("#<portlet:namespace />loadingDivId").removeClass('show-loading');	
		               }	
					}	
				});	
			});	
		}	
			
		function searchOrganizationUsers(){	
			AUI().use('aui-io-request',function(A){ 	
				if( !A.one("#<portlet:namespace />roleLoadingDivId").hasClass('show-loading') ){	
					A.one("#<portlet:namespace />roleLoadingDivId").addClass('show-loading');	
				}	
				var keyword=document.getElementById("<portlet:namespace />searchRoleUser").value;	
				var url='<%=searchOrganizationUsers%>';	
					
				//empty ul	
    	   		document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "";	
					
				A.io.request(url,{	
		            dataType: 'json',	
		            method: 'POST',	
		            data:{	
		            	<portlet:namespace />keyword : keyword,	
		            	<portlet:namespace />organizationId : document.getElementById("<portlet:namespace />roleOrganizationId").value	
		            },	
		            cache:false, 	
		            on: {	
		               success: function() {	
		            	   	var response=this.get('responseData');	
		            	   	console.log(response);	
		            	   	if(response.status){	
		            	   		var users=response.users;	
		            	   		if(users.length>0){	
		            	   			document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = displaySearchUsers(users);	
		            	   		} else {	
		            	   			document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "<li>No users found.</li>";	
		            	   		}	
		            	   	} else {	
		            	   		document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "<li>Error while fetching data, Please contact admin.</li>";	
		            	   	}	
		    				A.one("#<portlet:namespace />roleLoadingDivId").removeClass('show-loading');	
		               },	
		               error: function() {	
		            	   A.one("#<portlet:namespace />roleLoadingDivId").removeClass('show-loading');	
		            	   document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "<li>Error while fetching data, Please contact admin.</li>";	
		               }	
					}	
				});	
			});	
		}	
			
		function displaySearchUsers(users){	
			var htmlData="";	
			for(var i=0; i<users.length; i++){	
	   			console.log(users[i]);	
	   		 	htmlData +="<li>";	
	   			htmlData +="<div class=\"form-group\">";	
	   			htmlData +="<input name=\"checkbox\" type=\"checkbox\" id=\"user"+users[i].userid+"\" value=\""+users[i].userid+"\"  />";	
	   			htmlData +="<span class=\"checkmark\"></span></div>";	
	   				
	   			htmlData +="<div class=\"form-group-detail\" data-id=\"user"+users[i].userid+"\">";	
	   			htmlData +="<span class=\"avtar-profile\"><img src=\""+users[i].imgsrc+"\" alt=\"Profile\"></span>";	
	   			htmlData +="<div class=\"avtar-detail\"><input name=\"userId\" value=\""+users[i].userid+"\" type=\"hidden\"><h5>"+users[i].name+"</h5></div>";	
	   			htmlData +="<a href=\"javascript:void(0)\" class=\"delete-item\"><i class=\"ci icon-close\"></i></a>";	
	   			htmlData +="</div>";	
	   			htmlData +="</li>"	
	   		}	
				
			return htmlData;	
		}	
			
</script>	
	
	
	<portlet:actionURL name="updateCompetencyGroupId" var="addsupportedByURL">	
	<portlet:param name="redirect" value="<%=themeDisplay.getURLCurrent()%>"/>	
</portlet:actionURL>	
<%@ include file="/html/cidefinition/updatesupportedBy.jspf" %>
	
	
<script>
			function assignSupportedToOrg(organizationId, orgName)
			{	
			
					//clear current and available list 	
					document.getElementById("<portlet:namespace />assignSupportedHeaderId").innerHTML = "Assign/Unassign Supported Groups";	
					document.getElementById("<portlet:namespace />mappedRoleUserList").innerHTML = "";	
					document.getElementById("<portlet:namespace />availableRoleUserList").innerHTML = "";	
					document.getElementById("<portlet:namespace />statusRoleUserDivId").innerHTML = "";	
					document.getElementById("<portlet:namespace />searchRoleUser").value = "";	
					document.getElementById("<portlet:namespace />orgRoleId").value = "";	
					document.getElementById("<portlet:namespace />roleOrganizationId").value = organizationId;	
					document.getElementById("<portlet:namespace />basedocKey").value = orgName;
					
					document.getElementById("<portlet:namespace />docKey").value = orgName;
			}	
		
</script>
	
	
	
	
		
<%	
}
}
catch(Exception e)
{
	 System.out.println(e);
%>
<liferay-ui:error key="page-error" message="page-error">
</liferay-ui:error>
<%
}
%>
