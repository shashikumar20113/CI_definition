<%-- Copyright (c) 2019 LTI. All rights reserved.--%>
<%--  --%>



<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@ include file="init.jsp" %>
<%@ include file="/html/cidefinition/navigation.jsp" %>
<%
final Log _log = LogFactoryUtil.getLog(this.getClass());
int[] roleTyes = { RoleConstants.TYPE_ORGANIZATION };

try {
	
	
	
	
	PortalUtil.addPortletBreadcrumbEntry(request, "Customers",themeDisplay.getURLCurrent());
	
	
	if(companyOrgID==0) {
		SessionErrors.add(renderRequest,"configure-company");
%>
		<liferay-ui:error message="configure-company" key="configure-company" />
<% 		if(permissionChecker.isOmniadmin()){ %>
			<portlet:renderURL portletMode="edit" var="settingsURL" />
			<aui:a href="<%=settingsURL%>" label="configure"></aui:a>
<%
		}
	} else {
		
	  	
		List<Country> countries =CountryServiceUtil.getCountries(true);
		HashMap<Long,Country> countryMap=new HashMap<Long,Country>();
		for(Country country:countries){
			countryMap.put(country.getCountryId(), country);
		}
			String displayStyle = ParamUtil.getString(request, "displayStyle",  CustomerConstants.DEFAULT_DISPLAY_STYLE); 
			
		PortletURL iteratorURL = renderResponse.createRenderURL(); 
		iteratorURL.setParameter("mvcPath", "/html/cidefinition/view.jsp");
		iteratorURL.setParameter("displayStyle", displayStyle);
%>
		
		<liferay-ui:error exception="<%=PrincipalException.class%>"
			message="permission-denied" />
		<liferay-ui:error message="configure-company" key="configure-company" />
		<liferay-ui:error
			exception="<%=DuplicateOrganizationException.class%>"
			message="the-customer-name-exist" />
		<liferay-ui:error exception="<%=OrganizationNameException.class%>"
			message="please-enter-a-valid-name" />

		<div class="main-content-area">
			<div class="container-fluid">
				<div class="row">
					<div class="col-sm-9 col-md-9">
					</div>
					<div class="col-sm-3 col-md-3">
						<div class="input-feild">
							<div class="form-group">
								<span class="ci icon-search"></span> <input
									class="form-control input-default pl-35" id="usr"
									placeholder="Search" type="text" />
							</div>
						</div>
					</div>
				</div>
				<!-- ends of row div -->
				<hr class="devider"/>
				<h2 class="domain-title">Customers</h2>
			</div>
			<aui:fieldset-group markupView="lexicon">
				<%@ include file="/html/cidefinition/management-bar/toolbar.jspf" %>
				<div class="customer-mgmt-table">
					<liferay-ui:search-container var="customersSearchContiner"  total="<%=customers.size()%>" delta="10" emptyResultsMessage="no-customers-found" iteratorURL="<%= iteratorURL %>" >
					
						<liferay-ui:search-container-results results="<%=ListUtil.subList(customers, customersSearchContiner.getStart(), customersSearchContiner.getEnd()) %>" ></liferay-ui:search-container-results>
							<liferay-ui:search-container-row
								className="com.liferay.portal.kernel.model.Organization" 
								cssClass="entry-display-style selectable"
								modelVar="customer">
								<c:choose>
									 <c:when test='<%= displayStyle.equals("list") %>'>
										
										<liferay-ui:search-container-column-image name="logo"
											src='<%="/image/organization_logo?img_id="+ customer.getLogoId()%>'
											toggleRowChecker="<%= false %>"
										/>
										<liferay-ui:search-container-column-text name="name">
											<h6 class="text-default">
												<%= customer.getName() %>
											</h6>
										</liferay-ui:search-container-column-text>
										<liferay-ui:search-container-column-text name="description" >
											<%=customer.getComments()%>
										</liferay-ui:search-container-column-text>
										
										<liferay-ui:search-container-column-jsp name="actions"
											path="/html/cidefinition/customerActions.jsp"
										/>
									
									 </c:when>
									 <c:otherwise>
				 						<%
										row.setCssClass("entry-card lfr-asset-item");
				 						//_log.info("icon search container");
										%>
										<liferay-ui:search-container-column-text>
											<div class="card-col">
												<div class="cust-card">
													<div class="card-body">
														<div class="card-icon">
															<img
																src='<%="/image/organization_logo?img_id="+ customer.getLogoId()%>'
																toggleRowChecker="<%= false %>"
															/>
														</div>
														<h4><%= customer.getName() %></h4>
														
														<div class="card-actions">
														</div>
													</div>
													<portlet:renderURL var="projectURL">
														<portlet:param name="mvcPath" value="/html/cidefinition/viewProjects.jsp" />
														<portlet:param name="organizationId" value="<%=String.valueOf(customer.getOrganizationId())%>" />
														<portlet:param name="displayStyle" value="<%=displayStyle%>" />
													</portlet:renderURL>
													
													<a class="card-footer" href="${projectURL}">
														<div>
															<label>View Projects</label> <i class="ci icon-arrow-right"></i>
														</div>
													</a>
													
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

<% } 
}
catch(Exception e) {
	_log.error("IPAC : :Customer Management view ::  Error while loading page:"+e.getMessage(), e);
	SessionErrors.add(renderRequest, "page-error");
%>
	<liferay-ui:error key="page-error" message="page-error"> </liferay-ui:error>	
<%}%>
	