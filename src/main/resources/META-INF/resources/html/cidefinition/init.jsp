<%@page import="com.lti.itops.ipac.cidefinition.permission.CustomerActionKeys"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CustomerUtil"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CustomerConstants"%>
<%@page import="com.liferay.portal.kernel.dao.orm.QueryUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.kernel.service.OrganizationLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.model.Organization"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>


<%@ taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %>

<%@page import="com.lti.itops.ipac.cidefinition.constants.CIDefinitionPortletKeys"%>


<%@page import="com.lti.itops.ipac.cidefinition.permission.CustomerPermission"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.kernel.security.permission.ActionKeys"%>
<%@page import="com.liferay.portal.kernel.model.Company"%>
<%@page import="com.liferay.portal.kernel.exception.OrganizationNameException"%>
<%@page import="com.liferay.portal.kernel.exception.DuplicateOrganizationException"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>
<%@page import="com.liferay.portal.kernel.model.Country"%>
<%@page import="com.liferay.portal.kernel.service.CountryServiceUtil"%>
<%@page import="com.liferay.portal.kernel.model.RoleConstants"%>
<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>


<liferay-theme:defineObjects />

<portlet:defineObjects />


<%@page import="com.liferay.portal.kernel.security.auth.PrincipalException"%>
<%@page import="com.liferay.portal.kernel.servlet.SessionErrors"%>

<%@page import="javax.portlet.PortletPreferences"%>
<%@page import="com.liferay.portal.kernel.util.PortletKeys"%>
<%@page import="com.liferay.portal.kernel.service.PortalPreferencesLocalServiceUtil"%>



<portlet:renderURL var="homeURL" portletMode="view"></portlet:renderURL>

<%
PortletPreferences prefs = PortalPreferencesLocalServiceUtil.getPreferences(company.getCompanyId(),PortletKeys.PREFS_OWNER_TYPE_COMPANY);
	long companyOrgID = Long.parseLong(prefs.getValue(CustomerConstants.COMPANY_ORG_ID, "0"));
	Organization companyOrg = null;
	if (companyOrgID != 0) {
		companyOrg = OrganizationLocalServiceUtil.getOrganization(companyOrgID);
	} 
	
	
	//get all customers , for showing in navigation
	
	List<Organization> customers = new ArrayList<Organization>();
	
			
	if(companyOrg!=null){
		
		if(permissionChecker.hasPermission(
				companyOrg.getGroupId(), Organization.class.getName(),
				companyOrgID,
				CustomerActionKeys.MANAGE_CUSTOMERS)) {  
			customers = OrganizationLocalServiceUtil.search(
				themeDisplay.getCompanyId(),
				companyOrgID,
				"", CustomerConstants.TYPE_CUSTOMER, 0L, null, null,
			QueryUtil.ALL_POS, QueryUtil.ALL_POS);
		}  else {
			customers = CustomerUtil.getUserCustomers(user.getUserId(),themeDisplay); 
		} 
		
	}
	
	
	
	/* 
	else {
		companyOrg=OrganizationLocalServiceUtil.getOrganizations(-1, -1).get(0);
	}
	 */
	
%>  