<%-- Copyright (c) 2019 lti. All rights reserved.--%>

<%--  @author Madhukara Patel --%>

<%@page import="com.lti.itops.ipac.cidefinition.constants.CIDefinitionPortletKeys"%>
<%@ include file="init.jsp" %>

<portlet:renderURL var="backURL" portletMode="view"/>

<div class="main-content-area">

	<div class="container-fluid border-bottom m-15-w-100">
		<div class="mapping-sub-head inner-btn-bar pb-0">
			<div>
				<a href="<%=backURL%>"><i aria-hidden="true"
					class="ci icon-arrow-left"></i></a>
				<h2><liferay-ui:message key="ci-configuration"></liferay-ui:message></h2>
			</div>
		</div>
	</div>
	
	<c:choose>
	
		<c:when test="<%=themeDisplay.getPermissionChecker().isOmniadmin()%>">
		
		<% 
		
		String hostName = prefs.getValue(CIDefinitionPortletKeys.CI_HOST_IP,"127.0.0.1");
		String portNumber = prefs.getValue(CIDefinitionPortletKeys.CI_PORT_NUMBER,"8529");
		String userName = prefs.getValue(CIDefinitionPortletKeys.CI_USER_NAME,"root");
		String password = prefs.getValue(CIDefinitionPortletKeys.CI_PASSWORD,"root");
		String dbName = prefs.getValue(CIDefinitionPortletKeys.CI_DATABASE_NAME,"CMDB");
		String ciClass = prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class");
		String ciObject = prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object");
		String ciRelationship = prefs.getValue(CIDefinitionPortletKeys.CI_RELATION_NAME,"isObjectOf");
		
		
		%>
		
			<portlet:actionURL var="updateConfigurationURL" name="updateConfiguration">
			
			</portlet:actionURL>
			
			<div class="mt-30 user-wrapper-form">
			
			<aui:form action="<%=updateConfigurationURL%>" method="post" name="ci-configuration">
				
				<aui:input name="hostName" label="host-name" value="<%=hostName%>" cssClass="input-feild" required="true"/>
				
				<aui:input name="portnumber" label="port-number" value="<%=portNumber%>" cssClass="input-feild">
					<aui:validator name="required"/>
					<aui:validator name="number"/>
				</aui:input>
				
				<aui:input name="userName" label="user-name" value="<%=userName%>" cssClass="input-feild" required="true"/>
				
				<aui:input name="password" label="password" type="password" value="<%=password%>" cssClass="input-feild" required="true"/>
				
				<aui:input name="dbname" label="db_name" value="<%=dbName%>" cssClass="input-feild" required="true"/>
				
				<aui:input name="ciclass" label="ci-class" value="<%=ciClass%>" cssClass="input-feild" required="true"/>
				
				<aui:input name="ciobject" label="ci-object" value="<%=ciObject%>" cssClass="input-feild" required="true"/>
				
				<aui:input name="cirelation" label="ci-relation" value="<%=ciRelationship%>" cssClass="input-feild" required="true"/>
				
				<div class="form-action">
					<aui:button type="submit" value="save" cssClass="btn-custom mr-10 btn-custom-small"/>
					<aui:button type="cancel" value="cancel" cssClass="btn-custom btn-custom-2 btn-custom-small"/>
				</div>
				
			</aui:form>
				
			</div>
		
		</c:when>
		
		<c:otherwise>
		
			<%SessionErrors.add(renderRequest,PrincipalException.class);%>
			
			<liferay-ui:error exception="<%=PrincipalException.class%>" message="permission-denied" />
		
		</c:otherwise>
	
	</c:choose>
	
</div>
