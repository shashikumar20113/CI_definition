<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.lti.itops.ipac.cidefinition.permission.CIDefinitionPermission"%>
<%@page import="com.arangodb.entity.BaseDocument"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>

<%@page import="com.liferay.portal.kernel.security.auth.PrincipalException"%>

<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="init.jsp" %>
<%@ include file="/html/cidefinition/navigation.jsp" %>
<liferay-ui:error exception="<%=PrincipalException.class%>" message="permission-denied" />

<%  

try{
	String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
	long organizationId = ParamUtil.getLong(request, "organizationId", 0l);
	
   // Long key = ParamUtil.getLong(request, "key", -1l);
%>


<portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/viewProjects.jsp"/>
<portlet:param name="organizationId" value="<%= String.valueOf(
					OrganizationLocalServiceUtil.getOrganization(organizationId).getParentOrganizationId())%>"/>
<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>


<portlet:renderURL var="projectBackURL">
	<portlet:param name="mvcPath" value="/html/cidefinition/view.jsp" />
	<portlet:param name="organizationId"
		value="<%=String.valueOf(
							OrganizationLocalServiceUtil.getOrganization(organizationId).getParentOrganizationId())%>" />
	<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>


<!-- breadcrum code -->
<%



if (!OrganizationLocalServiceUtil.getParentOrganizations(organizationId).isEmpty()) {
	PortalUtil.addPortletBreadcrumbEntry(request, OrganizationLocalServiceUtil
			.getOrganization(organizationId).getParentOrganization().getName(), projectBackURL);
   
	
	
	PortalUtil.addPortletBreadcrumbEntry(request,
			OrganizationLocalServiceUtil.getOrganization(organizationId).getName(),
			backURL.toString());

	PortalUtil.addPortletBreadcrumbEntry(request, "Ci Definitions",themeDisplay.getURLCurrent());


		
}
				



























if (CIDefinitionPermission.hasCIDefinitionViewPermission(themeDisplay)) {

	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath", "/html/cidefinition/viewciDefinitionClass.jsp");
	iteratorURL.setParameter("organizationId", String.valueOf(organizationId));
	iteratorURL.setParameter("displayStyle", displayStyle); %>

<liferay-ui:error exception="<%=PrincipalException.class%>"
	message="permission-denied" />
	
	<div class="main-content-area">
	  <div class="container-fluid">
	   <div class="row">
			<div class="col-md-6">
	                 <a href="<%=backURL.toString()%>"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i>View Projects</a>
	                
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
		    <h2 class="domain-title">CI Definition</h2>  
		</div>   
		
	   <aui:fieldset-group markupView="lexicon">
	   <%@ include file="/html/cidefinition/management-bar/toolbar.jspf"%>
	        <div class="customer-mgmt-table">
	             <liferay-ui:search-container var="cidefinitionSearchContiner"
				total="<%=CIDefinitionUtil.getCIDefinitionCount(themeDisplay.getCompanyId())%>" delta="10"
				emptyResultsMessage="no-cidefinition-found"
				iteratorURL="<%=iteratorURL%>">
	                  <liferay-ui:search-container-results  results="<%=CIDefinitionUtil.getCIDefinitiones(themeDisplay.getCompanyId(), cidefinitionSearchContiner.getStart(),cidefinitionSearchContiner.getEnd()) %>" >
	                  </liferay-ui:search-container-results> 
	                    <liferay-ui:search-container-row className="com.arangodb.entity.BaseDocument" modelVar="basedoc"> 
	                    
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
	                    
	                    <portlet:renderURL var="editCIdefinition">
																<portlet:param name="mvcPath"
																	value="/html/cidefinition/updateCiDefinition.jsp" />
																<portlet:param name="key"
																	value="<%=String.valueOf(basedoc.getKey())%>" />
																<portlet:param name="displayStyle"
																	value="<%=displayStyle%>" />
						</portlet:renderURL>
						
						<portlet:renderURL var="addciobject">
								<portlet:param name="mvcPath" value="/html/cidefinition/addCiObject.jsp"/>
								<portlet:param name="cidefinitionkey" value="<%=String.valueOf(basedoc.getKey())%>" />
								<portlet:param name="cidefinitionid" value="<%=String.valueOf(basedoc.getId())%>" />
								<portlet:param name="displayStyle" value="<%=displayStyle%>" />
								<portlet:param name="organizationId" value="<%=String.valueOf(organizationId)%>" />
						</portlet:renderURL>
						
	                    
	                    <%boolean check = (boolean)basedoc.getProperties().get(CIDefinitionPortletKeys.STATUS);%>
	                   
	                     <c:choose>
	                         <c:when test='<%=displayStyle.equals("list")%>'>
	                         
	                         <liferay-ui:search-container-column-text name="CI Name">
	                         <h6 class="text-default">
	                         <%=basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME) %>
	                         </h6>
	                         </liferay-ui:search-container-column-text>
	                         
	                         <liferay-ui:search-container-column-text name="CI Definition">
	                         <h6 class="text-default">
	                         <%=basedoc.getProperties().get(CIDefinitionPortletKeys.DESCRIPTION) %> 
	                         </h6>
	                         </liferay-ui:search-container-column-text>
	                         
	                          
	                         
	                         
	                         <liferay-ui:search-container-column-text name="Status">
					
						<aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  />
	
					</liferay-ui:search-container-column-text>
					
	                         
	                         <liferay-ui:search-container-column-jsp
								path="/html/cidefinition/viewciDefClassActions.jsp"
								name="actions" />
	                         
	                         </c:when>
	                         <c:otherwise>
	                           <%
								row.setCssClass("entry-card lfr-asset-item");
							  %>
							    <liferay-ui:search-container-column-text>
							    
							  <div class="cust-card">
								<div class="card-body">
									<h4><%=basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME)%></h4>
									  <div class="head-row-right">
							             <aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  />
							          </div>
									     
									      <div class="card-icon">
															
															
										   </div>
									
									 <!-- <p class="path-text"></p>  -->
									 <div class="action-row mt-15">
										
										<a href="${editCIdefinition}" id="add-cidefinition"
																class="btn-" data-toggle="tooltip" title=""
																data-original-title="Edit"><i class="ci icon-edit"></i>
										</a>
										
										<a  href="${addciobject}" class="btn-" data-toggle="tooltip" data-original-title="Add CI Object">
											<i class="ci icon-add-1"></i>
										</a>
									</div>  
								</div>		
									<a class="card-footer" href="${CIObjects}">
										<div>
											<label>Manage CIObjects</label> <i class="ci icon-arrow-right"></i>
										</div>																							
									</a>				
							</div>
							    
							    
							    
							    
							    
							    <%-- <div class="card-layout">
							      <div class="head-row">
							      
							      <span><%= basedoc.getProperties().get("CI_Name") %></span>
							      
							        <div class="head-row-right">
							             <aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  />
							          </div>
							      </div>
							      
							      
							      <div class="action-row">
							      </div>
							      <div class="cust-card">
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
													
													<a class="card-footer" href="${CIObjects}">
														<div>
															<label>Manage CIObjects</label> <i class="ci icon-arrow-right"></i>
														</div>
													</a>
							      </div>
							      
							    
							    </div>
							     --%>
							    
							    
							      <%--  <div class="card-col">
							         <div class="cust-card">
							            <div class="card-body">
							            <div class="head-row">
							              <h4><%=basedoc.getProperties().get("CI_Name")%></h4>
							              <div class="head-row-right"><aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  />
	                                      </div>
	                                      </div>
							              <div class="card-icon ">
							              </div>
							                 
							                 <div class="card-actions">
							                   <div class="actions">									
							                   </div>
							                 </div>        
							            </div>
							            
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
													
													<a class="card-footer" href="${CIObjects}">
														<div>
															<label>Manage CIObjects</label> <i class="ci icon-arrow-right"></i>
														</div>
													</a>
							            
							         </div>
							       </div> --%> 
							    </liferay-ui:search-container-column-text>
	                         </c:otherwise>
	                     </c:choose>
	                    
	                  </liferay-ui:search-container-row> 
	                   <liferay-ui:search-iterator displayStyle="<%= displayStyle %>" markupView="lexicon" />
	             </liferay-ui:search-container>
	        </div>
	   </aui:fieldset-group>   
	</div>	
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
