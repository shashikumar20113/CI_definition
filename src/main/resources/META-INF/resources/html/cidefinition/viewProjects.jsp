<%-- Copyright (c) 2019 LTI. All rights reserved.--%>
<%-- @author Surendra K --%>


<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.exception.NoSuchOrganizationException"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ include file="init.jsp"%>
<%@ include file="/html/cidefinition/navigation.jsp" %>

<%
final Log _log = LogFactoryUtil.getLog(this.getClass());
try {
	String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
	List<Organization> projects = new ArrayList<Organization>();

	Organization customer = null;
	long organizationId = ParamUtil.getLong(renderRequest,
			"organizationId", 0l);
	try {
		customer = OrganizationLocalServiceUtil
				.getOrganization(organizationId);
	} catch (Exception e) {
		log("IPAC : Error while fetching customer for customer id "
				+ organizationId, e);
	}
	
	%>
	
		 <portlet:renderURL var="backURL">
		 <portlet:param name="mvcPath" value="/html/cidefinition/view.jsp"/>
		 <portlet:param name="organizationId" value="<%=String.valueOf(organizationId)%>" />
		 <portlet:param name="displayStyle" value="<%=displayStyle%>" />
		 </portlet:renderURL> 
	
	<%
	if (!OrganizationLocalServiceUtil.getParentOrganizations(organizationId).isEmpty()) {
		
		PortalUtil.addPortletBreadcrumbEntry(request,
				OrganizationLocalServiceUtil.getOrganization(organizationId).getName(),
				backURL.toString());

		PortalUtil.addPortletBreadcrumbEntry(request, "Projects",themeDisplay.getURLCurrent());


			
	} %>
	
	<% 
	if (customer == null) 
	{
		SessionErrors.add(renderRequest,
			NoSuchOrganizationException.class);
    %>
		<liferay-ui:error exception="<%=NoSuchOrganizationException.class%>" message="invalid-customer" />
		<aui:button icon="left-arrow" href="<%=homeURL%>" value="back"></aui:button>
		

<%
	} else {
	
		if (CustomerPermission.isManager(themeDisplay,customer)) {
			DynamicQuery dq=DynamicQueryFactoryUtil.forClass(Organization.class);
			dq.add(PropertyFactoryUtil.forName("parentOrganizationId").eq(customer.getOrganizationId()));
			dq.add(PropertyFactoryUtil.forName("type").eq(CustomerConstants.TYPE_PROJECT));
			dq.add(PropertyFactoryUtil.forName("companyId").eq(themeDisplay.getCompanyId()));
			projects = OrganizationLocalServiceUtil.dynamicQuery(dq);
		} else {
			projects = CustomerUtil.getUserCustomerProjects(user.getUserId(),organizationId,themeDisplay);
		}	
		
		 
		
		PortletURL iteratorURL = renderResponse.createRenderURL(); 
		iteratorURL.setParameter("mvcPath", "/html/cidefinition/viewProjects.jsp");
		iteratorURL.setParameter("organizationId",String.valueOf(organizationId));
		iteratorURL.setParameter("displayStyle", displayStyle);
		
%>
		<liferay-ui:error exception="<%=PrincipalException.class%>" message="permission-denied" />
	
		<div class="main-content-area">
			
			<div class="container-fluid">
				<div class="row">
				   <div class="col-md-6">
				      <a href="${backURL}"><i aria-hidden="true"
					   class="ci icon-arrow-left " title="Back"></i>View Customers</a>
				    </div> 
					<div class="col-md-3">&nbsp;</div>
					<div class="col-md-3">
						<div class="input-feild">
							<div class="form-group">
								<span class="ci icon-search"></span> 
								<input
									class="form-control input-default pl-35" id="usr"
									placeholder="Search" type="text" />
							</div>
						</div>
					</div>
				</div>
				<hr class="devider" />
				<h2 class="domain-title">Projects</h2>
			</div>
			
			<aui:fieldset-group markupView="lexicon">
				<%@ include file="/html/cidefinition/management-bar/toolbar.jspf" %>
				<div class="customer-mgmt-table">
					<liferay-ui:search-container var="customersSearchContiner"  total="<%=projects.size()%>" delta="5" emptyResultsMessage="no-projects-found" iteratorURL="<%= iteratorURL %>">
						<liferay-ui:search-container-results results="<%=ListUtil.subList(projects, customersSearchContiner.getStart(), customersSearchContiner.getEnd()) %>" ></liferay-ui:search-container-results>
							<liferay-ui:search-container-row
								className="com.liferay.portal.kernel.model.Organization"
								cssClass="entry-display-style selectable"
								modelVar="project"
							>
								<c:choose>
									<c:when test='<%= displayStyle.equals("list") %>'>
										<liferay-ui:search-container-column-image name="logo"
											src='<%="/image/organization_logo?img_id="+ project.getLogoId()%>'
											toggleRowChecker="<%= false %>"
										/>
										<liferay-ui:search-container-column-text name="name">
											<h6 class="text-default">
												<%= project.getName() %>
											</h6>
										</liferay-ui:search-container-column-text>
										<liferay-ui:search-container-column-text name="description" >
											<%=project.getComments()%>
										</liferay-ui:search-container-column-text>
										<liferay-ui:search-container-column-jsp name="actions"
											path="/html/cidefinition/projectActions.jsp"
										/>
									</c:when>
									<c:otherwise>
				 						<%
										row.setCssClass("entry-card lfr-asset-item");
										%>
										<liferay-ui:search-container-column-text>
											<div class="card-col">
												<div class="cust-card">
													<div class="card-body">
														<div class="card-icon">
															<img
																src='<%="/image/organization_logo?img_id="+ project.getLogoId()%>'
																toggleRowChecker="<%= false %>"
															/>
														</div>
														<h4><%= project.getName() %></h4>
														<div class="card-actions">
															<div class="actions">
																<portlet:renderURL var="viewciDefinitionClassjsp">
																		<portlet:param name="mvcPath"
																			value="/html/cidefinition/viewciDefinitionClass.jsp" />
																		 <portlet:param name="organizationId"
																			value="<%=String.valueOf(project.getOrganizationId())%>" /> 
																		<portlet:param name="displayStyle"
																			value="<%=displayStyle%>" />	
																 </portlet:renderURL>
																<a 	href="${viewciDefinitionClassjsp}" id="" class="btn-" data-toggle="tooltip" title="" data-original-title="View CI Definitions">
																	<i class="ci icon-catalog-group"></i> 
																</a>
																
															</div>
															
														</div>
													</div>
													
												</div>
											</div>
										</liferay-ui:search-container-column-text>
									</c:otherwise>
								</c:choose>
						 </liferay-ui:search-container-row>
						 <liferay-ui:search-iterator
							displayStyle="<%= displayStyle %>"
							markupView="lexicon"
						/>
					</liferay-ui:search-container>
				</div>
			</aui:fieldset-group>
		</div>

<% 	} 
}
catch(Exception e) {
	_log.error("IPAC : :Customer Management view project ::  Error while loading page:"+e.getMessage(), e);
	SessionErrors.add(renderRequest, "page-error");
%>
	<liferay-ui:error key="page-error" message="page-error"> </liferay-ui:error>	
<%}%>