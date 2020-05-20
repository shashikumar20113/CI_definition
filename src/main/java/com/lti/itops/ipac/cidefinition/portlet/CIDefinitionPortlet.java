/**
 * Copyright (c) 2019 LTI. All rights reserved.
 * @author Madhukara Patel
 */



package com.lti.itops.ipac.cidefinition.portlet;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSON;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.ListTypeConstants;
import com.liferay.portal.kernel.model.Organization;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.service.CompanyLocalServiceUtil;
import com.liferay.portal.kernel.service.OrganizationLocalServiceUtil;
import com.liferay.portal.kernel.service.RoleLocalServiceUtil;
import com.liferay.portal.kernel.service.UserGroupRoleServiceUtil;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.UnicodeProperties;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.lti.itops.ipac.cidefinition.constants.CIDefinitionPortletKeys;
import com.lti.itops.ipac.cidefinition.permission.CustomerPermission;
import com.lti.itops.ipac.cidefinition.permission.ProjectPermission;
import com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil;
import com.lti.itops.ipac.cidefinition.util.CustomerConstants;
import com.lti.itops.ipac.cidefinition.util.CustomerUtil;
import com.lti.itops.ipac.pwd.vault.server.model.Secret;
import com.lti.itops.ipac.pwd.vault.server.service.SecretEngineLocalServiceUtil;
import com.lti.itops.ipac.pwd.vault.server.service.SecretLocalServiceUtil;

import java.io.IOException;
import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.ProcessAction;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;

/**
 * @author 10658294
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.ipac",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.portlet-mode=text/html;view,edit",
		"javax.portlet.init-param.view-template=/html/cidefinition/view.jsp",
		"javax.portlet.init-param.edit-template=/html/cidefinition/edit.jsp",
		"javax.portlet.name=" + CIDefinitionPortletKeys.CIDefinition,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class CIDefinitionPortlet extends MVCPortlet {
	
	
	final static Log _log = LogFactoryUtil.getLog(CIDefinitionPortlet.class);
	
	@Override
	public void serveResource(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws IOException,
			PortletException {
		
		ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		
		String cmd=ParamUtil.getString(resourceRequest, Constants.CMD,"");
		
		try {
			
			if (cmd.equals("getUserList")) {
				getUserList(resourceRequest, resourceResponse);
			} else if(cmd.equals("getOrgRoleUserList")) {
				getOrgRoleUserList(resourceRequest, resourceResponse); 
			} else if(cmd.equals("searchPortalUsers")) {
				searchPortalUsers(resourceRequest, resourceResponse); 
			} else if(cmd.equals("searchOrganizationUsers")) {
				searchOrganizationUsers(resourceRequest, resourceResponse); 
			}
			
			else if(cmd.equalsIgnoreCase("getOUChildren"))
			{
				long ouID=ParamUtil.getLong(resourceRequest, "ouId",0);
				
				try {
					List<Organization> ous=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), ouID, null, CustomerConstants.TYPE_OU, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);
					List<Organization> competencies=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), ouID, null, CustomerConstants.TYPE_COMPETENCY, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);
					JSONObject ouObj=JSONFactoryUtil.createJSONObject();
					JSONArray ouArr=JSONFactoryUtil.createJSONArray();
					JSONArray compArr=JSONFactoryUtil.createJSONArray();
					for(Organization ou:ous)
					{
						if(ou.getStatusId()== ListTypeConstants.ORGANIZATION_STATUS_DEFAULT)
						{
							JSONObject obj=JSONFactoryUtil.createJSONObject();
							obj.put("id", ou.getOrganizationId());
							obj.put("name",ou.getName());
							ouArr.put(obj);
							
						}
					}
					for(Organization competency:competencies)
					{
						if(competency.getStatusId()== ListTypeConstants.ORGANIZATION_STATUS_DEFAULT)
						{
							JSONObject obj=JSONFactoryUtil.createJSONObject();
							obj.put("id", competency.getOrganizationId());
							obj.put("name",competency.getName());
							compArr.put(obj);
							
						}
					}
					ouObj.put("ous", ouArr);
					ouObj.put("competencies", compArr);
				
					resourceResponse.getWriter().write(ouObj.toString());
				} catch (SystemException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(cmd.equalsIgnoreCase("getGroups"))
			{

				long competencyID=ParamUtil.getLong(resourceRequest, "competencyId",0);
				
				long objectID=ParamUtil.getLong(resourceRequest, "selectedval",0);
				
				_log.info(objectID);
				try {
					List<Organization> groups=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), competencyID, null, CustomerConstants.TYPE_GROUP, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);
					
					JSONObject compObj=JSONFactoryUtil.createJSONObject();
					JSONArray grpArr=JSONFactoryUtil.createJSONArray();
					JSONArray ciArr=JSONFactoryUtil.createJSONArray();
					for(Organization group:groups)
					{
						if(group.getStatusId()== ListTypeConstants.ORGANIZATION_STATUS_DEFAULT)
						{
							JSONObject obj=JSONFactoryUtil.createJSONObject();
							obj.put("id", group.getOrganizationId());
							obj.put("name",group.getName());
							grpArr.put(obj);
							
						}
					}
					
				JSONObject ciobject= CIDefinitionUtil.getCIObjectAsJSON(themeDisplay.getCompanyId(), String.valueOf(objectID));
							
				
			JSONArray supportedby=	  ciobject.getJSONArray(CIDefinitionPortletKeys.SUPPORTEDBY);
			    
			        if(supportedby!=null)
			        {
					for(int i=0; i<supportedby.length();i++)
					{    
						JSONObject obj=JSONFactoryUtil.createJSONObject();
						
						String competencygroupid = supportedby.getString(i);
					  		
				  		 long competencygroupmapid = Long. parseLong(competencygroupid);
				 
				  		
				  		Organization CompetencyGroupList= OrganizationLocalServiceUtil.fetchOrganization(competencygroupmapid);
	
				  								  			
				  		String competecygrpName=CompetencyGroupList.getName().toString();
				  		      _log.info("id:"+competencygroupid);
				  		      
				  		    _log.info("name:"+competecygrpName);
						
						obj.put("id", competencygroupid);
						obj.put("name", competecygrpName);
						ciArr.put(obj);
					}
				   }
			        
			        else
			        {
			        	ciArr.put(supportedby);
			        }
			        
			        compObj.put("competencies", grpArr);
			        compObj.put("supported", ciArr);
			        
			        _log.info("main object:"+compObj);
					resourceResponse.getWriter().write(compObj.toString());
				} catch (SystemException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			
				
			}

			else if(cmd.equalsIgnoreCase("getsupportedGroups"))
			{

				long competencyID=ParamUtil.getLong(resourceRequest, "competencyId",0);
				
				try {
					List<Organization> groups=OrganizationLocalServiceUtil.search(themeDisplay.getCompanyId(), competencyID, null, CustomerConstants.TYPE_GROUP, null, null, null, QueryUtil.ALL_POS,QueryUtil.ALL_POS);
					JSONArray grpArr=JSONFactoryUtil.createJSONArray();
					for(Organization group:groups)
					{
						if(group.getStatusId()== ListTypeConstants.ORGANIZATION_STATUS_DEFAULT)
						{
							JSONObject obj=JSONFactoryUtil.createJSONObject();
							obj.put("id", group.getOrganizationId());
							obj.put("name",group.getName());
							grpArr.put(obj);
							
						}
					}
					
					
					resourceResponse.getWriter().write(grpArr.toString());
				} catch (SystemException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			
				
			}
			
			
			
		}  catch (Exception e) {
			_log.error("ipac customer management resource method: Error while fetching data ",e);
		}
		
	}
	
	public void updateConfiguration(ActionRequest actionRequest, ActionResponse actionResponse)
			throws IOException, PortletException {
		
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		PermissionChecker permissionChecker = themeDisplay.getPermissionChecker();
		
		if (permissionChecker.isOmniadmin()) {
			
			try {
					
				String hostName = ParamUtil.getString(actionRequest,"hostName");
				
				String portnumber = ParamUtil.getString(actionRequest,"portnumber");
				
				String userName = ParamUtil.getString(actionRequest,"userName");
				
				String password = ParamUtil.getString(actionRequest,"password");
				
				String dbname = ParamUtil.getString(actionRequest,"dbname");
				
				String ciclass = ParamUtil.getString(actionRequest,"ciclass");
				
				String ciobject = ParamUtil.getString(actionRequest,"ciobject");
				
				String cirelation = ParamUtil.getString(actionRequest,"cirelation");
				
				UnicodeProperties properties = new UnicodeProperties();
	            
				properties.setProperty(CIDefinitionPortletKeys.CI_HOST_IP,hostName);
				
				properties.setProperty(CIDefinitionPortletKeys.CI_PORT_NUMBER,portnumber);
				
				properties.setProperty(CIDefinitionPortletKeys.CI_USER_NAME,userName);
				
				properties.setProperty(CIDefinitionPortletKeys.CI_PASSWORD,password);
				
				properties.setProperty(CIDefinitionPortletKeys.CI_DATABASE_NAME,dbname);
				
				properties.setProperty(CIDefinitionPortletKeys.CI_CLASS_NAME,ciclass);
				
				properties.setProperty(CIDefinitionPortletKeys.CI_OBJECT_NAME,ciobject);
				
				properties.setProperty(CIDefinitionPortletKeys.CI_RELATION_NAME,cirelation);
				
				
				CompanyLocalServiceUtil.updatePreferences(themeDisplay.getCompanyId(), properties);
				
				actionResponse.setRenderParameter("mvcPath","/html/cidefinition/edit.jsp");
			
			}catch(Exception e) {
				
				_log.error("Error while updating CI updateConfiguration :::" +e.getMessage());
				
				actionResponse.setRenderParameter("mvcPath","/html/cidefinition/view.jsp");
				
			}
		
		} else {
			
			_log.error("IPAC : Error while updating CI Configuation . User '"
					+ themeDisplay.getUserId()
					+ "' does not have permission to update CI Configuartion settings.");
			SessionErrors.add(actionRequest, PrincipalException.class);
			
			actionResponse.setRenderParameter("mvcPath","/html/cidefinition/view.jsp");
		}
	}
	
	
	//Shashi changes
		@ProcessAction(name = "updateOrganizationUsers")
		public void updateOrganizationUsers(ActionRequest actionRequest,
				ActionResponse actionResponse) throws IOException, PortletException {
			long organizationId = ParamUtil
					.getLong(actionRequest, "userOrganizationId");
			long[] addUserIds = StringUtil.split(
					ParamUtil.getString(actionRequest, "addUserIds"), 0L);
			//long[] removeUserIds = StringUtil.split(
			//		ParamUtil.getString(actionRequest, "removeUserIds"), 0L);
			_log.info("organizationId::"+organizationId);
			_log.info("new user ids::"+Arrays.toString(addUserIds));
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest
					.getAttribute(WebKeys.THEME_DISPLAY);
			try {
				Organization organization = OrganizationLocalServiceUtil
						.getOrganization(organizationId);
				if ((organization.getType().equalsIgnoreCase(
						CustomerConstants.TYPE_CUSTOMER) && CustomerPermission
						.isManager(themeDisplay, organization))
						|| (organization.getType().equalsIgnoreCase(
								CustomerConstants.TYPE_PROJECT) && ProjectPermission
								.isManager(themeDisplay, organization))
						|| (organization.getType().equalsIgnoreCase(
								CustomerConstants.TYPE_COMPANY) && themeDisplay
								.getPermissionChecker().hasPermission(
										organization.getGroupId(),
										Organization.class.getName(),
										organizationId, ActionKeys.MANAGE))) {
					UserLocalServiceUtil.addOrganizationUsers(organizationId,
							addUserIds);
					//unset organization users
					List<User> assignedOrgUsers=CustomerUtil.getOrganizationUsers(organizationId);
					if(assignedOrgUsers.size()>0){
						List<Long> mappedUserIds = assignedOrgUsers.stream()
				                .map(User::getUserId)
				                .collect(Collectors.toList());
						_log.info("mappedUserIds::"+mappedUserIds);
						List<Long> newUserIds = Arrays.stream(addUserIds)
								.boxed()  
								.collect(Collectors.toList());
						List<Long>  removeUserIds = new ArrayList<Long>(); 
						for(Long userId : mappedUserIds) {
							if(!newUserIds.contains(userId)) {
								removeUserIds.add(userId);
							}
						}
						if(removeUserIds.size()>0) {
							long[] userIdArray=removeUserIds.stream().mapToLong(l -> l).toArray();
							UserLocalServiceUtil.unsetOrganizationUsers(organizationId,
									userIdArray);
						}
					}
					
				} else {
					_log.error("IPAC : Error while updating user assignments. User '"
							+ themeDisplay.getUserId()
							+ "' does not have permission to update  '"
							+ organizationId + "' user assignments.");
					SessionErrors.add(actionRequest, PrincipalException.class);
				}
				actionResponse.sendRedirect(ParamUtil.getString(actionRequest, "redirect"));
			} catch (Exception e) {
				_log.error(
						"IPAC : Error while updating user assignments for organization :"
								+ organizationId, e);
				SessionErrors.add(actionRequest, e.getClass());
				actionResponse.sendRedirect(ParamUtil.getString(actionRequest, "redirect"));
			}
		}
		
		@ProcessAction(name = "updateOrganizationRoleUsers")
		public void updateOrganizationRoleUsers(ActionRequest actionRequest,
				ActionResponse actionResponse) throws IOException, PortletException {
			long organizationId = ParamUtil
					.getLong(actionRequest, "organizationId");
			long roleId = ParamUtil.getLong(actionRequest, "orgRoleId");
			long[] addUserIds = StringUtil.split(
					ParamUtil.getString(actionRequest, "addRoleUserIds"), 0L);
			
			_log.info("updateOrganizationRoleUsers:: organizationId::"+organizationId+" roleId::"+roleId+" addUserIds::"+Arrays.toString(addUserIds));
			
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest
					.getAttribute(WebKeys.THEME_DISPLAY);
			try {
				Organization organization = OrganizationLocalServiceUtil
						.getOrganization(organizationId);
				RoleLocalServiceUtil.getRole(roleId);
				if ((organization.getType().equalsIgnoreCase(
						CustomerConstants.TYPE_CUSTOMER) && CustomerPermission
						.isManager(themeDisplay, organization))
						|| (organization.getType().equalsIgnoreCase(
								CustomerConstants.TYPE_PROJECT) && ProjectPermission
								.isManager(themeDisplay, organization))
						|| (organization.getType().equalsIgnoreCase(
								CustomerConstants.TYPE_COMPANY) && themeDisplay
								.getPermissionChecker().hasPermission(
										organization.getGroupId(),
										Organization.class.getName(),
										organizationId, ActionKeys.MANAGE))) {

					UserGroupRoleServiceUtil.addUserGroupRoles(addUserIds,
							organization.getGroupId(), roleId);
					
					
					//unset organization users
					//get all mapped users to organization role
					LinkedHashMap<String, Object> userParams = new LinkedHashMap<String, Object>();
					userParams.put("userGroupRole", new Long[] {new Long(organization.getGroupId()), new Long(roleId)});
					OrderByComparator<User> comparator=null;
					List<User> orgRoleUsers = UserLocalServiceUtil.search(themeDisplay.getCompanyId(), "", WorkflowConstants.STATUS_APPROVED, 
							userParams, QueryUtil.ALL_POS, QueryUtil.ALL_POS, comparator);
					if(orgRoleUsers.size()>0){
						List<Long> mappedUserIds = orgRoleUsers.stream()
				                .map(User::getUserId)
				                .collect(Collectors.toList());
						_log.info("existing users:::"+mappedUserIds);
						List<Long> newUserIds = Arrays.stream(addUserIds)
								.boxed()  
								.collect(Collectors.toList());
						List<Long>  removeUserIds = new ArrayList<Long>(); 
						for(Long userId : mappedUserIds) {
							if(!newUserIds.contains(userId)) {
								removeUserIds.add(userId);
							}
						}
						if(removeUserIds.size()>0) {
							long[] userIdArray=removeUserIds.stream().mapToLong(l -> l).toArray();
							_log.info("removed users ids:::"+Arrays.toString(userIdArray));
							UserGroupRoleServiceUtil.deleteUserGroupRoles(userIdArray,
									organization.getGroupId(), roleId);
						}
					}
					

				} else {
					_log.error("IPAC : Error while updating user role assignments. User '"
							+ themeDisplay.getUserId()
							+ "' does not have permission to update  '"
							+ organizationId + "' user role assignments.");
					SessionErrors.add(actionRequest, PrincipalException.class);
				}
				actionResponse.sendRedirect(ParamUtil.getString(actionRequest, "redirect"));
			} catch (Exception e) {
				_log.error(
						"IPAC : Error while updating user role assignments for organization :"
								+ organizationId + " Role: " + roleId, e);
				SessionErrors.add(actionRequest, e.getClass());
				actionResponse.sendRedirect(ParamUtil.getString(actionRequest, "redirect"));
			}
		}
		
		@ProcessAction(name = "searchPortalUsers")
		private void searchPortalUsers(ResourceRequest resourceRequest,ResourceResponse resourceResponse)  {
				
			ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest
					.getAttribute(WebKeys.THEME_DISPLAY);
			
			JSONObject finalObj=JSONFactoryUtil.createJSONObject();
			try {
				String keyword=ParamUtil.getString(resourceRequest, "keyword","");
				List<User> portalUsers=CustomerUtil.getPortalUsers(themeDisplay.getCompanyId(),keyword.trim());
				
				JSONArray userArray=JSONFactoryUtil.createJSONArray();
				for(User user : portalUsers) {
					JSONObject object=JSONFactoryUtil.createJSONObject();
					object.put("name", user.getFullName());
					object.put("userid", user.getUserId());
					object.put("imgsrc", user.getPortraitURL(themeDisplay));
					
					userArray.put(object);
					
				}
				finalObj.put("users", userArray);
				finalObj.put("status", true);
				resourceResponse.getWriter().write(finalObj.toString());
				
			} catch (Exception e) {
				
				_log.error("ipac customer management resource method cmd- searchPortalUsers: Error while fetching data ",e);
				
				finalObj.put("status", false);
				try {
					resourceResponse.getWriter().write(finalObj.toString());
				} catch (IOException e1) {
				}
			}
				
				
		}
		
		@ProcessAction(name = "searchOrganizationUsers")
		private void searchOrganizationUsers(ResourceRequest resourceRequest,ResourceResponse resourceResponse)  {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest
					.getAttribute(WebKeys.THEME_DISPLAY);
			
			JSONObject finalObj=JSONFactoryUtil.createJSONObject();
			try {
				String keyword=ParamUtil.getString(resourceRequest, "keyword","");
				long organizationId=ParamUtil.getLong(resourceRequest, "organizationId");
				
				List<User> serachedUsers=new ArrayList<User>();
				
				//get all organization assigned users
				List<User> assignedOrgUsers=CustomerUtil.getOrganizationUsers(organizationId);
				
				if("".equalsIgnoreCase(keyword.trim())) {
					serachedUsers.addAll(assignedOrgUsers);
				} else {
					serachedUsers= assignedOrgUsers.stream()
					        .filter(user -> user.getFullName().indexOf(keyword) !=-1 ? true: false )
					        .collect(Collectors.toList());
				}
				
				JSONArray userArray=JSONFactoryUtil.createJSONArray();
				for(User user : serachedUsers) {
					JSONObject object=JSONFactoryUtil.createJSONObject();
					object.put("name", user.getFullName());
					object.put("userid", user.getUserId());
					object.put("imgsrc", user.getPortraitURL(themeDisplay));
					
					userArray.put(object);
					
				}
				finalObj.put("users", userArray);
				finalObj.put("status", true);
				resourceResponse.getWriter().write(finalObj.toString());
				
			} catch (Exception e) {
				
				_log.error("ipac customer management resource method cmd- searchOrganizationUsers: Error while fetching data ",e);
				
				finalObj.put("status", false);
				try {
					resourceResponse.getWriter().write(finalObj.toString());
				} catch (IOException e1) {
				}
			}
				
			
		}
		
		
		
		private void getUserList(ResourceRequest resourceRequest,ResourceResponse resourceResponse)  {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest
					.getAttribute(WebKeys.THEME_DISPLAY);
			
			long organizationId = ParamUtil.getLong(resourceRequest, "organizationId");
			JSONObject object=JSONFactoryUtil.createJSONObject();
			try {
				
				List<User> assignedOrgUsers=CustomerUtil.getOrganizationUsers(organizationId);
				List<Long> mappedUserIds = CustomerUtil.getUserIds(assignedOrgUsers);
				_log.info("mappedUserIds::"+mappedUserIds+" organizationId::"+organizationId);
				String keyword="";
				List<User> portalUsers=CustomerUtil.getPortalUsers(themeDisplay.getCompanyId(),keyword);
				
				StringBuilder sb=new StringBuilder();
				
				for(User user : assignedOrgUsers) {
					sb.append("<li data-id=\"user"+user.getUserId()+"\">");
					sb.append("<span class=\"avtar-profile\">");
					sb.append("\t<img src=\""+user.getPortraitURL(themeDisplay)+"\" alt=\"Profile\" /></span>");
					sb.append("<div class=\"avtar-detail\">");
					sb.append("\t<input name=\"userId\" value=\""+user.getUserId()+"\" type=\"hidden\" />");
					sb.append("\t<h5>"+user.getFullName()+"</h5></div>");
					sb.append("<a href=\"javascript:void(0)\" class=\"delete-item\">");
					sb.append("\t<i class=\"ci icon-close\"></i></a>");
					sb.append("</li>");
				}
				object.put("mappedUsers", sb.toString());
				
				sb.setLength(0);
				for(User user : portalUsers) {
					sb.append("<li>");
					sb.append("<div class=\"form-group\">");
					sb.append("\t<input name=\"checkbox\" type=\"checkbox\" id='user"+user.getUserId()+"' value=\""+user.getUserId()+"\"");
					if(mappedUserIds.contains(user.getUserId())) {
						sb.append(" checked=\"checked\" />");
					} else {
						sb.append(" />");
					}
					sb.append("\t<span class=\"checkmark\"></span>");
					sb.append("</div>");
					sb.append("<div class=\"form-group-detail\" data-id='user"+user.getUserId()+"'>");
					sb.append("<span class=\"avtar-profile\">");
					sb.append("\t<img src=\""+user.getPortraitURL(themeDisplay)+"\" alt=\"Profile\" /></span>");
					sb.append("<div class=\"avtar-detail\">");
					sb.append("\t<input name=\"userId\" value=\""+user.getUserId()+"\" type=\"hidden\" />");
					sb.append("\t<h5>"+user.getFullName()+"</h5></div>");
					sb.append("<a href=\"javascript:void(0)\" class=\"delete-item\">");
					sb.append("\t<i class=\"ci icon-close\"></i></a>");
					sb.append("</div>");
					sb.append("</li>");
				}
				object.put("portalUsers", sb.toString());
				object.put("status", true);
				
				resourceResponse.getWriter().write(object.toString());
				
			} catch (Exception e) {
				object.put("msg", "Error while loading page, Please contact admin.");
				object.put("status", false);
				try {
					resourceResponse.getWriter().write(object.toString());
				} catch (IOException e1) {
				}
				_log.error("Error: getUserList::",e);
			}
			
		}
		
		
		@ProcessAction(name = "getOrgRoleUserList")
		private void getOrgRoleUserList(ResourceRequest resourceRequest,ResourceResponse resourceResponse)  {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest
					.getAttribute(WebKeys.THEME_DISPLAY);
			
			long organizationId = ParamUtil.getLong(resourceRequest, "organizationId");
			long roleId = ParamUtil.getLong(resourceRequest, "roleId");
			JSONObject object=JSONFactoryUtil.createJSONObject();
			try {
				
				Organization organization = OrganizationLocalServiceUtil
						.getOrganization(organizationId);
				
				List<User> assignedOrgUsers=CustomerUtil.getOrganizationUsers(organizationId);
				
				
				LinkedHashMap<String, Object> userParams = new LinkedHashMap<String, Object>();
				userParams.put("userGroupRole", new Long[] {new Long(organization.getGroupId()), new Long(roleId)});
				OrderByComparator<User> comparator=null;
				List<User> orgRoleUsers = UserLocalServiceUtil.search(themeDisplay.getCompanyId(), "", WorkflowConstants.STATUS_APPROVED, 
						userParams, QueryUtil.ALL_POS, QueryUtil.ALL_POS, comparator);
				
				List<Long> mappedRoleUserIds = CustomerUtil.getUserIds(orgRoleUsers);
				
				_log.info("mappedRoleUserIds::"+mappedRoleUserIds+" organizationId::"+organizationId+" roleId::"+roleId);
				
				StringBuilder sb=new StringBuilder();
				
				for(User user : orgRoleUsers) {
					sb.append("<li data-id=\"user"+user.getUserId()+"\">");
					sb.append("<span class=\"avtar-profile\">");
					sb.append("\t<img src=\""+user.getPortraitURL(themeDisplay)+"\" alt=\"Profile\" /></span>");
					sb.append("<div class=\"avtar-detail\">");
					sb.append("\t<input name=\"userId\" value=\""+user.getUserId()+"\" type=\"hidden\" />");
					sb.append("\t<h5>"+user.getFullName()+"</h5></div>");
					sb.append("<a href=\"javascript:void(0)\" class=\"delete-item\">");
					sb.append("\t<i class=\"ci icon-close\"></i></a>");
					sb.append("</li>");
				}
				object.put("mappedOrgRoleUsers", sb.toString());
				
				sb.setLength(0);
				for(User user : assignedOrgUsers) {
					sb.append("<li>");
					sb.append("<div class=\"form-group\">");
					sb.append("\t<input name=\"checkbox\" type=\"checkbox\" id='user"+user.getUserId()+"' value=\""+user.getUserId()+"\"");
					if(mappedRoleUserIds.contains(user.getUserId())) {
						sb.append(" checked=\"checked\" />");
					} else {
						sb.append(" />");
					}
					sb.append("\t<span class=\"checkmark\"></span>");
					sb.append("</div>");
					sb.append("<div class=\"form-group-detail\" data-id='user"+user.getUserId()+"'>");
					sb.append("<span class=\"avtar-profile\">");
					sb.append("\t<img src=\""+user.getPortraitURL(themeDisplay)+"\" alt=\"Profile\" /></span>");
					sb.append("<div class=\"avtar-detail\">");
					sb.append("\t<input name=\"userId\" value=\""+user.getUserId()+"\" type=\"hidden\" />");
					sb.append("\t<h5>"+user.getFullName()+"</h5></div>");
					sb.append("<a href=\"javascript:void(0)\" class=\"delete-item\">");
					sb.append("\t<i class=\"ci icon-close\"></i></a>");
					sb.append("</div>");
					sb.append("</li>");
				}
				object.put("mappedOrgUsers", sb.toString());
				object.put("status", true);
				
				resourceResponse.getWriter().write(object.toString());
				
			} catch (Exception e) {
				object.put("msg", "Error while loading page, Please contact admin.");
				object.put("status", false);
				try {
					resourceResponse.getWriter().write(object.toString());
				} catch (IOException e1) {
				}
				_log.error("Error: getUserList::",e);
			}
			
		}
		
		

	
	/* Method to Add CI Definitions */
	
	@ProcessAction(name = "addCidefinition")
	public void addCidefinition(ActionRequest actionRequest, ActionResponse actionResponse)
	{
		
		try {
			   ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			
			   JSONObject jsonObject =  JSONFactoryUtil.createJSONObject();
			   
			   boolean status=true;
			   
			   
			   
			   String CIdef= ParamUtil.getString(actionRequest,"cidef");
			  
			   String CIname =ParamUtil.getString(actionRequest, "ciname");
			   
			   jsonObject.put(CIDefinitionPortletKeys.STATUS, status);
			   jsonObject.put(CIDefinitionPortletKeys.DESCRIPTION, CIdef);
			   jsonObject.put(CIDefinitionPortletKeys.CI_NAME, CIname);
			   
			   String Property = actionRequest.getParameter("configIndexes");
			  
			   String[] indexOfRows = Property.split(",");
			   
			          for (int i = 0; i < indexOfRows.length; i++) 
			          {	
			        	 
				         String key = actionRequest.getParameter("propertyname" + indexOfRows[i]);	
				         
				         String val = actionRequest.getParameter("propertytype" + indexOfRows[i]);
				         	
				         boolean checkbox = ParamUtil.getBoolean(actionRequest, "mendatory" + indexOfRows[i]);
				        	
				         JSONObject subjsonObject =  JSONFactoryUtil.createJSONObject();
				                subjsonObject.put("type", val);
				                subjsonObject.put("isMandatory" ,checkbox);	
				                String atrributename = key;
				                jsonObject.put(atrributename, subjsonObject);	
 
			           }	
			          
			    String[] Inheritance = actionRequest.getParameterValues("classname");	
			     
			    JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
			     
			           for(int i=1; i<Inheritance.length; i++)
			           {
				              String classids= Inheritance[i];
				              jsonArray.put(classids);
				              
			            }
			           
			    jsonObject.put(CIDefinitionPortletKeys.INHERITED_CLASS, jsonArray);	
			    JSONArray historyArray = JSONFactoryUtil.createJSONArray();
			    
			    JSONObject ChangeHistoryObject =  JSONFactoryUtil.createJSONObject();
			    ChangeHistoryObject.put("attributeChanged", "String");
			    ChangeHistoryObject.put("oldValue", "String");
			    ChangeHistoryObject.put("newValue", "String");
			    ChangeHistoryObject.put("changeTimeStamp", "Datetime");
			    ChangeHistoryObject.put("changedBy", themeDisplay.getUserId());
			    ChangeHistoryObject.put("affectedAttributes", "String");
		
			    historyArray.put(ChangeHistoryObject);
			    
			    jsonObject.put(CIDefinitionPortletKeys.CHANGEHISTORY, historyArray);
			    
			   CIDefinitionUtil.addCIDefinition(themeDisplay.getCompanyId(), jsonObject);
		  }
		catch(Exception ex)
		  {
			   _log.error("IPAC_CIDefinition: Exception in adding CIDefinition"+ ex.getMessage());
		  }	
	}


	/* Method to Update CI Definitions*/
	
	@ProcessAction(name = "updateCidefinition")
	public void updateCidefinition(ActionRequest actionRequest, ActionResponse actionResponse) {
		
		try {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			
			String Key = ParamUtil.getString(actionRequest, "key");
			
			String CIdef= ParamUtil.getString(actionRequest,"cidef");
			  
		    String CIname =ParamUtil.getString(actionRequest, "ciname");
			
		    JSONObject jsonobject = JSONFactoryUtil.createJSONObject();
		    
			jsonobject.put(CIDefinitionPortletKeys.DESCRIPTION, CIdef);
			
			jsonobject.put(CIDefinitionPortletKeys.CI_NAME, CIname);
			
			String Property = actionRequest.getParameter("configIndexes");
						
			String[] indexofRows = Property.split(",");
			
			for(int i=0; i<indexofRows.length; i++)
			{   				
				
				String key = actionRequest.getParameter("propertyname" + indexofRows[i]);
				
				String val= actionRequest.getParameter("propertytype" + indexofRows[i]);
				
				boolean checkbox = ParamUtil.getBoolean(actionRequest, "mendatory" + indexofRows[i]);
				
				JSONObject subjsnobject = JSONFactoryUtil.createJSONObject();
				           
				          subjsnobject.put("type", val);
				          
				          subjsnobject.put("isMandatory", checkbox);
				          
				          String attributename = key;
				          
		                 jsonobject.put(attributename, subjsnobject);     				
			}
			
			String[] Inheritance = actionRequest.getParameterValues("classname");
			
			JSONArray jsnarray = JSONFactoryUtil.createJSONArray();
			
			for(int i=1; i<Inheritance.length; i++)
			{
				String classids= Inheritance[i];
				jsnarray.put(classids);
				
			}
			
			jsonobject.put(CIDefinitionPortletKeys.INHERITED_CLASS, jsnarray);
			
			CIDefinitionUtil.updateCIDefinition(themeDisplay.getCompanyId(),Key, jsonobject);
			
		    }
		catch(Exception ex)
		   {
			
			  _log.error("IPAC_CIDefinition: Exception in updating CIDefinition"+ ex);
		   }	
		
	}


    
	/* Method to set CI Definitions status as deactive */
	
	@ProcessAction(name = "updateCIdefinitionstatus")
	public void updateCIdefinitionstatus(ActionRequest actionRequest, ActionResponse actionResponse)
	
	{
			
	    try {
				
				ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
				
				String Key = ParamUtil.getString(actionRequest, "key");
				
				boolean status=false;
				
				CIDefinitionUtil.updatedefinitionStatus(themeDisplay.getCompanyId(), Key, status);
				
				
			}
	    catch(Exception ex)
			{
				_log.error("IPAC_CIDefinition: Exception in updating CIDefinition Status"+ ex);
				
			}
			
   }

	/* Method to set CI Definitions status as Active */
	
	@ProcessAction(name = "updateCIdefinitionstatusasactive")
	public void updateCIdefinitionstatusasactive(ActionRequest actionRequest, ActionResponse actionResponse) 
	{
		   try {
				
					ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
					
					String Key = ParamUtil.getString(actionRequest, "key");
					
					boolean status=true;
					
					CIDefinitionUtil.updatedefinitionStatus(themeDisplay.getCompanyId(), Key, status);
					
			   }
			catch(Exception ex)
			   {
				   _log.error("IPAC_CIDefinition: Exception in updating CIDefinition Status"+ ex);
				
			   }
	}

	/* Method to Add CI Objects */
	
	@ProcessAction(name = "addCiobject")
	public void addCiobject(ActionRequest actionRequest, ActionResponse actionResponse) {
		
		try {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY); 
			
			JSONObject jsnobjct = JSONFactoryUtil.createJSONObject();
			
			JSONArray jsnarray = JSONFactoryUtil.createJSONArray();
			
			boolean status=true;
			
			jsnobjct.put(CIDefinitionPortletKeys.STATUS, status);
			
			String organizationId = ParamUtil.getString(actionRequest, "organizationId");
			
			
			
			jsnobjct.put(CIDefinitionPortletKeys.ORGANIZATION_ID, organizationId);
			
			
			String Ciobjectname = ParamUtil.getString(actionRequest, "ciobjectname");
			
			String Ciname = ParamUtil.getString(actionRequest, "ciname");
			
			
			String technology = ParamUtil.getString(actionRequest, "technology");
			
			jsnobjct.put(CIDefinitionPortletKeys.TECHNOLOGY_ID, technology);
		
			String[] competencygroupids = actionRequest.getParameterValues("classname");
			
			 
		     
			JSONArray competencyarray = JSONFactoryUtil.createJSONArray();
			     
			if(competencygroupids!=null) 
			{
			           for(int i=1; i<competencygroupids.length; i++)
			           {
				              String competencygroupid= competencygroupids[i];
				              competencyarray.put(competencygroupid);
				              
			            }
			}
			else
			{
				String empty ="";
				
				competencyarray.put(competencygroupids);
			}
			
			
			           
			jsnobjct.put(CIDefinitionPortletKeys.SUPPORTEDBY, competencyarray);
			
			
			
			String[] SecretNameLists = actionRequest.getParameterValues("secretNames");	
			
			
			
			JSONArray secretarray = JSONFactoryUtil.createJSONArray();
			
            if(SecretNameLists!=null) {
			for(int i=0; i<SecretNameLists.length; i++)
	           {
		              String classids= SecretNameLists[i];
		      		DynamicQuery orgQuery = SecretLocalServiceUtil.dynamicQuery();

		              orgQuery.add(PropertyFactoryUtil.forName("secretName").eq(new String(classids)));
		      		List<Secret> secretList=SecretEngineLocalServiceUtil.dynamicQuery(orgQuery);
		    		
		      	
		      		for(Secret secret:secretList){
		      			secretarray.put(secret.getSecretId());
		    			
		    			
		    		}
		              
		              
	            }
            }
            
            else {
            	String empty ="";
            	secretarray.put(SecretNameLists);
            }
				
			
			jsnobjct.put(CIDefinitionPortletKeys.SECRET_ID, secretarray);
			
			String assignOwner = ParamUtil.getString(actionRequest, "assignOwner");
			
			jsnobjct.put(CIDefinitionPortletKeys.ASSIGN_OWNER, assignOwner);
			
            String assignOwnergroup = ParamUtil.getString(actionRequest, "assignOwnergroup");
			
			jsnobjct.put(CIDefinitionPortletKeys.ASSIGN_OWNER_GROUP, assignOwnergroup);
			
			
            String Inbound = ParamUtil.getString(actionRequest, "inbound");
			
			jsnobjct.put(CIDefinitionPortletKeys.INBOUND, Inbound);
			
            String Outbound = ParamUtil.getString(actionRequest, "Outbound");
			
			jsnobjct.put(CIDefinitionPortletKeys.OUTBOUND, Outbound);
			
			
            jsnobjct.put(CIDefinitionPortletKeys.CI_NAME, Ciname);
			
			jsnobjct.put(CIDefinitionPortletKeys.CI_OBJECT, Ciobjectname);
			
			int Cicount =ParamUtil.getInteger(actionRequest, "cicount");
			 
			int Count = ParamUtil.getInteger(actionRequest, "count");
		
			for(int i=1; i<Count; i++)
			{
				String propname= ParamUtil.getString(actionRequest, "propertyname"+i);
				
				
				String propvalue= ParamUtil.getString(actionRequest, "propertyvalue"+i);
				
				
				jsnobjct.put(propname, propvalue);
				
			}
			
			String Propcount =ParamUtil.getString(actionRequest,"propcount");
				if(!Propcount.isEmpty()) {
					
				
			String [] prpcount= Propcount.split(",");
						
		        int counter=0;
		        int newcount=1;
				for(int z=1; z<prpcount.length; z++)
				{
					counter++;
					int prptycount=Integer.parseInt(prpcount[z]);
				     
				     
				 	for( int k=counter; k<Cicount; k++)
					{
				 		
						String inhertciclasskey= ParamUtil.getString(actionRequest, "inhertciclasskey"+k);
											   
							if(z>0) 
							{
								JSONObject subjsnobjct = JSONFactoryUtil.createJSONObject();
								subjsnobjct.put("id", inhertciclasskey);
								
								
								for(int j=newcount; j<prptycount; j++)
								{
																
									String inheritpropname = ParamUtil.getString(actionRequest, "propname"+j);
									String inheritpropvalue= ParamUtil.getString(actionRequest, "propvalue"+j);
																
									subjsnobjct.put(inheritpropname, inheritpropvalue);
									
									newcount++;
								}	
								
								jsnarray.put(subjsnobjct);
								jsnobjct.put(CIDefinitionPortletKeys.INHERITED,jsnarray);
								
								break;
							 }
				
				      
				     }
				
				
				
			 }	
				}
				
				else {
					jsnobjct.put(CIDefinitionPortletKeys.INHERITED,jsnarray);
				}

			String cidefinitionid = ParamUtil.getString(actionRequest, "cidefinitionid");
			
			_log.info(cidefinitionid);
			
			JSONArray historyArray = JSONFactoryUtil.createJSONArray();
		    
		    JSONObject ChangeHistoryObject =  JSONFactoryUtil.createJSONObject();
		    ChangeHistoryObject.put("attributeChanged", "String");
		    ChangeHistoryObject.put("oldValue", "String");
		    ChangeHistoryObject.put("newValue", "String");
		    ChangeHistoryObject.put("changeTimeStamp", "Datetime");
		    ChangeHistoryObject.put("changedBy", themeDisplay.getUserId());
		    ChangeHistoryObject.put("affectedAttributes", "String");
	
		    historyArray.put(ChangeHistoryObject);
		    
		    jsnobjct.put(CIDefinitionPortletKeys.CHANGEHISTORY, historyArray);
		    
		    _log.info(jsnobjct);
			
			CIDefinitionUtil.insertCIObject(themeDisplay.getCompanyId(), cidefinitionid, jsnobjct);
		    }
		
		catch(Exception ex)
		   {
			_log.error("IPAC_CIDefinition: Exception in Inserting CIObject "+ ex);
		   }
		}

	/*Method to update CI object status as deactive*/
	
	@ProcessAction(name = "updateCIobjectstatus")
	public void updateCIobjectstatus(ActionRequest actionRequest, ActionResponse actionResponse) {
		
		 try {
				
				ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
				
				String Key = ParamUtil.getString(actionRequest, "key");
				
				boolean status=false;
				
				CIDefinitionUtil.updateObjectStatus(themeDisplay.getCompanyId(), Key, status);
				
			}
	    catch(Exception ex)
			{
				_log.error("IPAC_CIDefinition: Exception in updating CIObject Status"+ ex);
				
			}
		
		
	}
	
	/*Method to update CI object status as active*/

	@ProcessAction(name = "updateCIobjectstatusasactive")
	public void updateCIobjectstatusasactive(ActionRequest actionRequest, ActionResponse actionResponse) {
		
	    try {
			
				ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
				
				String Key = ParamUtil.getString(actionRequest, "key");
				
				boolean status=true;
				
				CIDefinitionUtil.updateObjectStatus(themeDisplay.getCompanyId(), Key, status);
			
	        }
	   catch(Exception ex)
	        {
		        _log.error("IPAC_CIDefinition: Exception in updating CIObject Status"+ ex);
		
	        }
		
		
	}

	/*Method to update CI objects*/
	
	@ProcessAction(name = "updateCiobject")
	public void updateCiobject(ActionRequest actionRequest, ActionResponse actionResponse) {
		
		try {
		
					ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
					
					JSONObject jsnobject =JSONFactoryUtil.createJSONObject();
					JSONArray jsnarray = JSONFactoryUtil.createJSONArray();
					
					String Key = ParamUtil.getString(actionRequest, "key");
					
					_log.info(Key);
					
					String Ciname = ParamUtil.getString(actionRequest,"ciname");
					
					_log.info(Ciname);
					
					String CiObject = ParamUtil.getString(actionRequest, "ciobjectname");
					
					jsnobject.put(CIDefinitionPortletKeys.CI_NAME, Ciname);
					jsnobject.put(CIDefinitionPortletKeys.CI_OBJECT, CiObject);
					
					String technology = ParamUtil.getString(actionRequest, "technology");
					
					jsnobject.put(CIDefinitionPortletKeys.TECHNOLOGY_ID, technology);
					
					/*int Count = ParamUtil.getInteger(actionRequest, "count");
					
					for(int i=1; i<Count; i++)
					{
						String propname= ParamUtil.getString(actionRequest, "propertyname"+i);
						_log.info(propname);
						
						String propvalue= ParamUtil.getString(actionRequest, "propertyvalue"+i);
						_log.info(propvalue);
						
						jsnobject.put(propname, propvalue);
						
					}
					
					int ciCount = ParamUtil.getInteger(actionRequest, "cicount");
					
					_log.info("cicount"+" "+ciCount);
					
					JSONArray inheritedCinamearray = JSONFactoryUtil.createJSONArray();
					
					for(int j=1; j<=ciCount; j++)
					{
						String inheritedciname = ParamUtil.getString(actionRequest, "inheritciname"+j);
						_log.info("ciname"+" "+inheritedciname);
						inheritedCinamearray.put( inheritedciname);
						
					}
					
					jsnobject.put("inheritedciname", inheritedCinamearray);
					
					_log.info(jsnobject);
							          */ 
					
					/*int Count = ParamUtil.getInteger(actionRequest, "count");
					
					for(int i=1; i<Count; i++)
					{
						String propname= ParamUtil.getString(actionRequest, "propertyname"+i);
						_log.info(propname);
						
						String propvalue= ParamUtil.getString(actionRequest, "propertyvalue"+i);
						_log.info(propvalue);
						
						jsnobject.put(propname, propvalue);
						
					}
					
					int Cicount =ParamUtil.getInteger(actionRequest, "cicount");
					
					String Propcount =ParamUtil.getString(actionRequest,"propcount");
					
					_log.info(Propcount);
					
					String [] prpcount= Propcount.split(",");
					
					_log.info(prpcount);
					
			        int counter=0;
			        int newcount=1;
					for(int z=1; z<prpcount.length; z++)
					{
						counter++;
						int prptycount=Integer.parseInt(prpcount[z]);
					     _log.info(prptycount);
					      
					 	for( int k=counter; k<Cicount; k++)
						{
					 		
							String inhertciclasskey= ParamUtil.getString(actionRequest, "inherciclasskey"+k);
							
							
							_log.info(inhertciclasskey);
							   
								if(z>0) 
								{
									JSONObject subjsnobjct = JSONFactoryUtil.createJSONObject();
									_log.info("inside if 1");
									for(int j=newcount; j<prptycount; j++)
									{
										
										
										String inheritpropname = ParamUtil.getString(actionRequest, "prptyname"+j);
										String inheritpropvalue= ParamUtil.getString(actionRequest, "prpval"+j);
										
										_log.info(inheritpropname+"for,z=1");
										subjsnobjct.put(inheritpropname, inheritpropvalue);
										
										_log.info(subjsnobjct);
										newcount++;
									}	
									jsnobject.put(inhertciclasskey, subjsnobjct);
									
									_log.info(jsnobject);
									break;
								 }
					*/
								/*if(z>1)
								{
									JSONObject subjsnobjct = JSONFactoryUtil.createJSONObject();
									_log.info("inside if 2");
									
									int val=(Integer.parseInt(prpcount[z])-Integer.parseInt(prpcount[z-1]));
									
									_log.info(val);
									for(int y=val; y<prptycount; y++)
									{
										String inheritpropname = ParamUtil.getString(actionRequest, "prptyname"+y);
										String inheritpropvalue= ParamUtil.getString(actionRequest, "prpval"+y);
										subjsnobjct.put(inheritpropname, inheritpropvalue);
										
										
									}
									
									_log.info(subjsnobjct);
									jsnobject.put(inhertciclasskey, subjsnobjct);
									_log.info(jsnobject);
									break;
									
								}*/
					    /*  
					     }
					
					
					
				 }	
					*/
					int Cicount =ParamUtil.getInteger(actionRequest, "cicount");
					 
					int Count = ParamUtil.getInteger(actionRequest, "count");
				
					for(int i=1; i<Count; i++)
					{
						String propname= ParamUtil.getString(actionRequest, "propertyname"+i);
						
						
						String propvalue= ParamUtil.getString(actionRequest, "propertyvalue"+i);
						
						
						jsnobject.put(propname, propvalue);
						
					}
					
					String Propcount =ParamUtil.getString(actionRequest,"propcount");
							
					
					String [] prpcount= Propcount.split(",");
								
				        int counter=0;
				        int newcount=1;
						for(int z=1; z<prpcount.length; z++)
						{
							counter++;
							int prptycount=Integer.parseInt(prpcount[z]);
						     
						     
						 	for( int k=counter; k<Cicount; k++)
							{
						 		
								String inhertciclasskey= ParamUtil.getString(actionRequest, "inhertciclasskey"+k);
													   
									if(z>0) 
									{
										JSONObject subjsnobjct = JSONFactoryUtil.createJSONObject();
										subjsnobjct.put("id", inhertciclasskey);
										
										
										for(int j=newcount; j<prptycount; j++)
										{
																		
											String inheritpropname = ParamUtil.getString(actionRequest, "propname"+j);
											String inheritpropvalue= ParamUtil.getString(actionRequest, "propvalue"+j);
																		
											subjsnobjct.put(inheritpropname, inheritpropvalue);
											
											newcount++;
										}	
										
										jsnarray.put(subjsnobjct);
										jsnobject.put(CIDefinitionPortletKeys.INHERITED,jsnarray);
										
										break;
									 }
						
						      
						     }
						
						
						
					 }	

					
					CIDefinitionUtil.updateCIObject(themeDisplay.getCompanyId(), Key, jsnobject);
		            
		     }
		catch(Exception ex)
		    {
			      _log.error("IPAC_CIDefinition: Exception in updating CIObject "+ ex);
		    }
		
	}
	
	
	@ProcessAction(name = "updateAssignOwner")
	public void updateAssignOwner(ActionRequest actionRequest, ActionResponse actionResponse) 
	{
		try {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			
			JSONObject jsnobject =JSONFactoryUtil.createJSONObject();
			
			String Key = ParamUtil.getString(actionRequest, "Key");
			
			
			
			_log.info(Key);
			JSONArray jsonArray=JSONFactoryUtil.createJSONArray();
			String[] addUserids=ParamUtil.getParameterValues(actionRequest, "addUserIds");

			if(addUserids!=null) {
			for(int i=0;i<addUserids.length;i++) {
				String userid=addUserids[i];
				jsonArray.put(userid);
			}
			_log.info("json object "+jsnobject);
			}
			else {
				jsonArray.put(addUserids);
			}
			
			jsnobject.put(CIDefinitionPortletKeys.ASSIGN_OWNER, jsonArray);

			CIDefinitionUtil.updateCIObject(themeDisplay.getCompanyId(), Key, jsnobject);
            
     }
catch(Exception ex)
    {
	      _log.error("IPAC_CIDefinition: Exception in Adding Onwer to CIObject "+ ex);
    }
} 
	
	
	@ProcessAction(name = "updateAssignOwnerGroup")
	public void updateAssignOwnerGroup(ActionRequest actionRequest, ActionResponse actionResponse) 
	{
		try {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			
			JSONObject jsnobject =JSONFactoryUtil.createJSONObject();
			
			String Key = ParamUtil.getString(actionRequest, "ciObjectKey");
			
			
			
			_log.info("Key Shashi"+Key);
			JSONArray jsonArray=JSONFactoryUtil.createJSONArray();
			String[] addRoleUserIds=ParamUtil.getParameterValues(actionRequest, "addRoleUserIds");

			if(addRoleUserIds!=null) {
			for(int i=0;i<addRoleUserIds.length;i++) {
				String userid=addRoleUserIds[i];
				jsonArray.put(userid);
			}
			}
			else
			{
				jsonArray.put(addRoleUserIds);
			}
			_log.info("json object "+jsnobject);
			
			
			jsnobject.put(CIDefinitionPortletKeys.ASSIGN_OWNER_GROUP, jsonArray);

			CIDefinitionUtil.updateCIObject(themeDisplay.getCompanyId(), Key, jsnobject);
            
     }
catch(Exception ex)
    {
	      _log.error("IPAC_CIDefinition: Exception in Adding Owner Group to CIObject "+ ex);
    }
	}

	@ProcessAction(name = "updateCompetencyGroupId")
	public void updateCompetencyGroupId(ActionRequest actionRequest, ActionResponse actionResponse) {
		
		
try {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			
			JSONObject jsnobject =JSONFactoryUtil.createJSONObject();
			
			String Key = ParamUtil.getString(actionRequest, "key");
			
			
			
			_log.info("Key Shashi"+Key);
			JSONArray jsonArray=JSONFactoryUtil.createJSONArray();
			String[] competencygrpids=ParamUtil.getParameterValues(actionRequest, "classname");

			if(competencygrpids!=null) {
			for(int i=1;i<competencygrpids.length;i++) {
				String competencygrpid=competencygrpids[i];
				jsonArray.put(competencygrpid);
			}
			}
			else
			{
				String empty="";
				jsonArray.put(competencygrpids);
			}
			_log.info("json object "+jsnobject);
			
			
			jsnobject.put(CIDefinitionPortletKeys.SUPPORTEDBY, jsonArray);

			CIDefinitionUtil.updateCIObject(themeDisplay.getCompanyId(), Key, jsnobject);
            
     }
catch(Exception ex)
    {
	      _log.error("IPAC_CIDefinition: Exception in Adding Owner Group to CIObject "+ ex);
    }

		
	}
	
	
	@ProcessAction(name = "getChangeHistory")
	public void getChangeHistory(ActionRequest actionRequest, ActionResponse actionResponse) {
		
		
try {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			
			String key = ParamUtil.getString(actionRequest, "key");
						
			DateFormat format = new SimpleDateFormat("MM/dd/yyyy");
			
			java.util.Date date=ParamUtil.getDate(actionRequest, "date", format);
			
			JSONObject ciObj=CIDefinitionUtil.getCIObjectAsJSON(themeDisplay.getCompanyId(), key);
	   		JSONArray ciobjectArray = ciObj.getJSONArray(CIDefinitionPortletKeys.CHANGEHISTORY);
	   		
	   		System.out.print("ciobjectArray.get(1) =="+ciobjectArray.get(1));
			 for (int i=0;i<ciobjectArray.length();i++){
				 JSONObject jsonObject=ciobjectArray.getJSONObject(i);
				 String v=jsonObject.getString("changeTimeStamp");
				 
				 if(!v.equalsIgnoreCase("Datetime")){
			  		 long va = Long.parseLong(v);
					 Date date1=new Date(va);
					 DateFormat dateFormat=new SimpleDateFormat("dd/MM/yyyy");
					String formatted =dateFormat.format(date1);
					System.out.println("formatted shashi date"+formatted);
				 }
			 }
			 
			 

					
//			String s=date.toString();
//			String[] a=s.split(" ");
//			System.out.println("a[2] Shashi"+a[2]);
			
			_log.info("Shashi key"+key);
            
			_log.info("Shashi date selected"+date);
			
			_log.info("Shashi String get date"+date.getDate());
			_log.info("Shashi String"+date.getMonth());
			_log.info("Shashi String"+date.getYear());


			_log.info("Shashi String to instant"+date.toInstant());


			
			DateFormat dateConvert=new SimpleDateFormat();
			
            
     }
catch(Exception ex)
    {
	      _log.error("IPAC_CIDefinition: Exception "+ ex);
    }

		
	}
}