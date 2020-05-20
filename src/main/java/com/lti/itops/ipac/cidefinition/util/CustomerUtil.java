/**
 * Copyright (c) 2016 lti. All rights reserved.
 */

package com.lti.itops.ipac.cidefinition.util;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.model.Organization;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.service.OrganizationLocalServiceUtil;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.kernel.workflow.WorkflowConstants;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Raj Kumar Kulasekaran
 */
/*
 * Utility class for customer management
 * 
 */
public class CustomerUtil {

	/**
	 * Returns all Customers to which the user belong ( User can be member of the
	 * customer itself or member of an active project under a customer)
	 */
	public static List<Organization> getUserCustomers(long userId,ThemeDisplay themeDisplay)
			throws SystemException, PortalException {

		HashMap<String, Organization> customerMap = new HashMap<String, Organization>();
		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {
			if (org.getType().equals(CustomerConstants.TYPE_CUSTOMER)) {
				customerMap.put(org.getName(), org);
			} else if (org.getType().equals(CustomerConstants.TYPE_PROJECT)
					&& ((org.getStatusId() != CustomerConstants.ORG_DEACTIVATE_STATUS  )/*|| CustomerPermission.isManager(themeDisplay, org.getParentOrganization())*/)) {
				Organization parent = org.getParentOrganization();
				customerMap.put(parent.getName(), parent);
			}
		}
		return new ArrayList<Organization>(customerMap.values());
	}

	/**
	 * Returns all active projects to which the user belongs based on the
	 * customer ID
	 */
	public static List<Organization> getUserCustomerProjects(long userId,
			long customerId,ThemeDisplay themeDisplay) throws SystemException, PortalException {

		List<Organization> projects = new ArrayList<Organization>();
		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {
			if (org.getType().equals(CustomerConstants.TYPE_PROJECT)
					&& org.getParentOrganizationId() == customerId
					&& (org.getStatusId() != CustomerConstants.ORG_DEACTIVATE_STATUS/*||CustomerPermission.isManager(themeDisplay, org.getParentOrganization())*/) ) {
				projects.add(org);
			}
		}
		return projects;
	}
	
	//Shashi changes
		/**
		 * Returns all active projects to which the user belongs based on the
		 * customer ID
		 */
		public static List<Organization> getCustomerProjects(long customerId,
				long companyId) {
			
			List<Organization> projects = new ArrayList<Organization>();
			
			DynamicQuery dq=OrganizationLocalServiceUtil.dynamicQuery();//  DynamicQueryFactoryUtil.forClass(Organization.class);
			dq.add(PropertyFactoryUtil.forName("parentOrganizationId").eq(customerId));
			dq.add(PropertyFactoryUtil.forName("type").eq(CustomerConstants.TYPE_PROJECT));
			dq.add(PropertyFactoryUtil.forName("companyId").eq(companyId));
			projects = OrganizationLocalServiceUtil.dynamicQuery(dq);
			
			
			return projects;
		}
		
		
		/**
		 * Get organization user list
		 * @param organizationId
		 * @return
		 */
		public static List<User> getOrganizationUsers(long organizationId) {
			
			return UserLocalServiceUtil.getOrganizationUsers(organizationId);
		}
		
		
		/**
		 * Get user list which are not assigned to organization
		 * @param organizationId
		 * @param companyId
		 * @return
		 */
		public static List<User> getUsersNotMappedToOrganization(long organizationId, long companyId) {
			
			List<User> usersNotMappedToOrg=new ArrayList<User>();
			
			List<User> assignedOrgUsers=getOrganizationUsers(organizationId);
			List<Long> mappedUserIds = getUserIds(assignedOrgUsers);
			
			//_log.info("assignedOrgUsers::"+assignedOrgUsers);
			//OrderByComparatorFactoryUtil.create(UserI, columns)
			
			OrderByComparator<User> comparator=null;
			List<User> portalUsers=UserLocalServiceUtil.
					search(companyId, "", WorkflowConstants.STATUS_APPROVED, new LinkedHashMap<>(), QueryUtil.ALL_POS, 
							QueryUtil.ALL_POS, comparator);
			//_log.info("portalUsers::"+portalUsers);
			
			usersNotMappedToOrg= portalUsers.stream()
			        .filter(user -> !mappedUserIds.contains(user.getUserId()))
			        .collect(Collectors.toList());
			
			//_log.info("usersNotMappedToOrg::"+usersNotMappedToOrg);
			
			return usersNotMappedToOrg;
		}
		
		
		public static List<Long> getUserIds(List<User> users){
			
			return users.stream()
	                .map(User::getUserId)
	                .collect(Collectors.toList());
		}
		
		public static List<User> getPortalUsers(long companyId, String keyword) {
			
			OrderByComparator<User> comparator=null;
			List<User> portalUsers=UserLocalServiceUtil.
					search(companyId, keyword, WorkflowConstants.STATUS_APPROVED, new LinkedHashMap<>(), QueryUtil.ALL_POS, 
							QueryUtil.ALL_POS, comparator);
			return portalUsers;
		}
		
		
		
		/**
		 * 
		 * @param users
		 * @return
		 */
		public static List<Organization> searchOrganizationByName(List<Organization> organizations, String keyword){
			
			if(keyword==null || "".equalsIgnoreCase(keyword.trim())) {
				return organizations;
			} else {
				List<Organization> filterOrganizations=new ArrayList<Organization>();
				filterOrganizations=organizations.stream()
			        .filter(org -> org.getName().toLowerCase().indexOf(keyword.toLowerCase()) != -1)
			        .collect(Collectors.toCollection(ArrayList::new));
				return filterOrganizations;
			}
			
		}







}
