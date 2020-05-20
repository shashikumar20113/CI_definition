<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.arangodb.entity.BaseDocument"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>

<%@page import="com.liferay.portal.kernel.security.auth.PrincipalException"%>
<%@page import="com.lti.itops.ipac.cidefinition.portlet.CIDefinitionPortlet"%>
<%@page import="com.lti.itops.ipac.cidefinition.permission.CIDefinitionPermission"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="init.jsp" %>
<%@ include file="/html/cidefinition/navigation.jsp" %>
<liferay-ui:error exception="<%=PrincipalException.class%>" message="permission-denied" />

<%  

try{
	String displayStyle = ParamUtil.getString(request, "displayStyle", "icon");
		
%>
<portlet:renderURL var="addcidefinition">
<portlet:param name="mvcPath" value="/html/cidefinition/addCiDefinition.jsp"/>

<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>


 <%-- <portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/viewciDefinitionClass.jsp"/>

<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL> 
 --%>
 
 
 
 <%
 PortalUtil.addPortletBreadcrumbEntry(request, "Ci Definitions",themeDisplay.getURLCurrent());
 
 
 %>
<%if (CIDefinitionPermission.hasCIDefinitionViewPermission(themeDisplay)) {

	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath", "/html/cidefinition/displayciDefinition.jsp");

	iteratorURL.setParameter("displayStyle", displayStyle); %>

<liferay-ui:error exception="<%=PrincipalException.class%>"
	message="permission-denied" />
	
	<div class="main-content-area">
	  <div class="container-fluid">
	   <div class="row">
			<div class="col-md-6">
	                 <c:if
					test="<%=CIDefinitionPermission.hasCIDefinitionManagePermission(themeDisplay)%>">
					<a class="btn btn-primary" href="${addcidefinition}">
						<i class="ci icon-add-1"></i>Add CI Definition
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
	                    
	                    <%boolean check = (boolean)basedoc.getProperties().get(CIDefinitionPortletKeys.STATUS);%>
	                   
	                     <c:choose>
	                         <c:when test='<%=displayStyle.equals("list")%>'>
	                         <liferay-ui:search-container-column-text name="CI Definition Name">
	                         <h6 class="text-default">
	                         <%=basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME) %> 
	                         </h6>
	                         </liferay-ui:search-container-column-text>
	                         
	                          <liferay-ui:search-container-column-text name="Description">
	                         <h6 class="text-default">
	                         <%=basedoc.getProperties().get(CIDefinitionPortletKeys.DESCRIPTION)%>
	                         </h6>
	                         </liferay-ui:search-container-column-text>
	                         
	                         
	                         <liferay-ui:search-container-column-text name="Status">
					
						<aui:input name="toggler" type="toggle-switch" value="0" checked="<%=check%>" label=""  />
	
					</liferay-ui:search-container-column-text>
					
	                         
	                         <liferay-ui:search-container-column-jsp
								path="/html/cidefinition/ciDefinitionaction.jsp"
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
							              <h4><%=basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME)%></h4>
							              <div class="head-row-right"><aui:input name="toggler" type="toggle-switch" value="1" checked="<%=check%>" label=""  />
	                                      </div>
	                                      </div>
							              <div class="card-icon">
															
															
										   </div>
							                 
							                 
							                   <div class="action-row mt-15">
							                   
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
