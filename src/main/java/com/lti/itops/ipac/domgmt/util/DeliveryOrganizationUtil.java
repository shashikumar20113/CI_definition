/**
 * Copyright (c) 2018 LTI. All rights reserved.
 */

/**
 * @author Abhishek Sharma
 */

package com.lti.itops.ipac.domgmt.util;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.model.Organization;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.service.OrganizationLocalServiceUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.lti.itops.ipac.domgmt.permissions.CompetencyPermissions;
import com.lti.itops.ipac.domgmt.permissions.OrganizationPermissions;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * Util class for User Organizations.
 */

public class DeliveryOrganizationUtil {
	/**
	 * Returns all Organization unit to which the user belong
	 * 
	 */
	public static List<Organization> getUserOrganizationUnit(long userId,
			long companyOrgID, ThemeDisplay themeDisplay)
			throws SystemException, PortalException {
		HashMap<String, Organization> organizationUnitMap = new HashMap<String, Organization>();
		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {
			if (org.getType().equals(DeliveryOrganizationConstants.TYPE_OU)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					organizationUnitMap = getOrganizationMap(org, companyOrgID,
							organizationUnitMap);
				} else if (OrganizationPermissions.isManager(themeDisplay,
						org.getParentOrganization())) {
					organizationUnitMap = getOrganizationMap(org, companyOrgID,
							organizationUnitMap);
				}
			} else if (org.getType().equals(
					DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					Organization parent = org.getParentOrganization();

					if (parent.getType().equals(
							DeliveryOrganizationConstants.TYPE_OU)) {
						if (parent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
							organizationUnitMap = getOrganizationMap(parent,
									companyOrgID, organizationUnitMap);
						} else if (OrganizationPermissions.isManager(
								themeDisplay, parent)) {
							organizationUnitMap = getOrganizationMap(parent,
									companyOrgID, organizationUnitMap);
						}
					}
				} else if (OrganizationPermissions.isManager(themeDisplay,
						org.getParentOrganization())) {
					Organization parent = org.getParentOrganization();
					if (parent.getType().equals(
							DeliveryOrganizationConstants.TYPE_OU)) {
						if (parent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
							organizationUnitMap = getOrganizationMap(parent,
									companyOrgID, organizationUnitMap);
						} else if (OrganizationPermissions.isManager(
								themeDisplay, parent.getParentOrganization())) {
							organizationUnitMap = getOrganizationMap(parent,
									companyOrgID, organizationUnitMap);
						}
					}
				}
			} else if (org.getType().equals(
					DeliveryOrganizationConstants.TYPE_GROUP)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					Organization groupParent = org.getParentOrganization();
					if (groupParent.getType().equals(
							DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
						if (groupParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
							Organization competencyParent = groupParent
									.getParentOrganization();
							if (competencyParent.getType().equals(
									DeliveryOrganizationConstants.TYPE_OU)) {
								if (competencyParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								} else if (OrganizationPermissions.isManager(
										themeDisplay, competencyParent)) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								}

							}
						} else if (CompetencyPermissions.isManager(
								themeDisplay, groupParent)) {
							Organization competencyParent = groupParent
									.getParentOrganization();
							if (competencyParent.getType().equals(
									DeliveryOrganizationConstants.TYPE_OU)) {
								if (competencyParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								} else if (OrganizationPermissions.isManager(
										themeDisplay, competencyParent)) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								}

							}
						}
					}
				} else if (CompetencyPermissions.isManager(themeDisplay,
						org.getParentOrganization())) {
					Organization groupParent = org.getParentOrganization();
					if (groupParent.getType().equals(
							DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
						if (groupParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
							Organization competencyParent = groupParent
									.getParentOrganization();
							if (competencyParent.getType().equals(
									DeliveryOrganizationConstants.TYPE_OU)) {
								if (competencyParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								} else if (OrganizationPermissions.isManager(
										themeDisplay, competencyParent
												.getParentOrganization())) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								}

							}
						} else if (OrganizationPermissions.isManager(
								themeDisplay,
								groupParent.getParentOrganization())) {
							Organization competencyParent = groupParent
									.getParentOrganization();
							if (competencyParent.getType().equals(
									DeliveryOrganizationConstants.TYPE_OU)) {
								if (competencyParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								} else if (OrganizationPermissions.isManager(
										themeDisplay, competencyParent
												.getParentOrganization())) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								}

							}
						}
					}
				}

			}

		}
		return new ArrayList<Organization>(organizationUnitMap.values());
	}

	
	/**
	 * Returns all active Organization unit to which the user belong
	 * 
	 */
	public static List<Organization> getUserActiveOrganizationUnits(long userId,
			long companyOrgID)
			throws SystemException, PortalException {
		HashMap<String, Organization> organizationUnitMap = new HashMap<String, Organization>();
		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {
			if (org.getType().equals(DeliveryOrganizationConstants.TYPE_OU)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					organizationUnitMap = getOrganizationMap(org, companyOrgID,
							organizationUnitMap);
				}
			} else if (org.getType().equals(
					DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					Organization parent = org.getParentOrganization();

					if (parent.getType().equals(
							DeliveryOrganizationConstants.TYPE_OU)) {
						if (parent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
							organizationUnitMap = getOrganizationMap(parent,
									companyOrgID, organizationUnitMap);
						} 
					}
				}
			} else if (org.getType().equals(
					DeliveryOrganizationConstants.TYPE_GROUP)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					Organization groupParent = org.getParentOrganization();
					if (groupParent.getType().equals(
							DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
						if (groupParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
							Organization competencyParent = groupParent
									.getParentOrganization();
							if (competencyParent.getType().equals(
									DeliveryOrganizationConstants.TYPE_OU)) {
								if (competencyParent.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
									organizationUnitMap = getOrganizationMap(
											competencyParent, companyOrgID,
											organizationUnitMap);
								} 

							}
						} 
					}
				} 

			}

		}
		return new ArrayList<Organization>(organizationUnitMap.values());
	}

	
	/* Method to get all competencies of user. */
	public static List<Organization> getUsersCompetency(long userId,
			long parentOrganizationId, ThemeDisplay themeDisplay)
			throws SystemException, PortalException {
		HashMap<String, Organization> organizationUnitMap = new HashMap<String, Organization>();

		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {

			if (org.getType().equals(
					DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					if (org.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(org.getName(), org);
					}
				} else if (OrganizationPermissions.isManager(themeDisplay,
						org.getParentOrganization())) {
					if (org.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(org.getName(), org);
					}
				}
			} else if (org.getType().equalsIgnoreCase(
					DeliveryOrganizationConstants.TYPE_GROUP)) {
				Organization parentOrganization = org.getParentOrganization();
				if (parentOrganization.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					if (parentOrganization.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(parentOrganization.getName(),
								parentOrganization);
					}
				} else if (OrganizationPermissions.isManager(themeDisplay,
						parentOrganization.getParentOrganization())) {
					if (parentOrganization.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(parentOrganization.getName(),
								parentOrganization);
					}
				}

			}
		}
		return new ArrayList<Organization>(organizationUnitMap.values());
	}

	/* Method to get all active competencies of user. */
	public static List<Organization> getUserActiveCompetencies(long userId,
			long parentOrganizationId)
			throws SystemException, PortalException {
		HashMap<String, Organization> organizationUnitMap = new HashMap<String, Organization>();

		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {

			if (org.getType().equals(
					DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					if (org.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(org.getName(), org);
					}
				}
			} else if (org.getType().equalsIgnoreCase(
					DeliveryOrganizationConstants.TYPE_GROUP)) {
				Organization parentOrganization = org.getParentOrganization();
				if (parentOrganization.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					if (parentOrganization.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(parentOrganization.getName(),
								parentOrganization);
					}
				} 

			}
		}
		return new ArrayList<Organization>(organizationUnitMap.values());
	}
	
	/* Method to get all groups of user. */
	public static List<Organization> getUsersGroup(long userId,
			long parentOrganizationId, ThemeDisplay themeDisplay)
			throws SystemException, PortalException {

		HashMap<String, Organization> organizationUnitMap = new HashMap<String, Organization>();
		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {

			if (org.getType().equals(DeliveryOrganizationConstants.TYPE_GROUP)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					if (org.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(org.getName(), org);
					}
				} else if (CompetencyPermissions.isManager(themeDisplay,
						org.getParentOrganization())) {
					if (org.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(org.getName(), org);
					}
				}
			}
		}
		return new ArrayList<Organization>(organizationUnitMap.values());
	}
	
	/* Method to get all active groups of user. */
	public static List<Organization> getUserActiveGroups(long userId,
			long parentOrganizationId)
			throws SystemException, PortalException {

		HashMap<String, Organization> organizationUnitMap = new HashMap<String, Organization>();
		for (Organization org : OrganizationLocalServiceUtil
				.getUserOrganizations(userId)) {

			if (org.getType().equals(DeliveryOrganizationConstants.TYPE_GROUP)) {
				if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					if (org.getParentOrganizationId() == parentOrganizationId) {
						organizationUnitMap.put(org.getName(), org);
					}
				} 
			}
		}
		return new ArrayList<Organization>(organizationUnitMap.values());
	}

	/* Method to get organization map. */
	public static HashMap<String, Organization> getOrganizationMap(
			Organization org, long companyOrgID,
			HashMap<String, Organization> organizationUnitMap) {
		if (org.getParentOrganizationId() == companyOrgID) {
			organizationUnitMap.put(org.getName(), org);
		} else {
			Organization parentOrg = null;
			try {
				parentOrg = org.getParentOrganization();

			} catch (PortalException e) {

				e.printStackTrace();
			} catch (SystemException e) {

				e.printStackTrace();
			}
			while (true) {
				if (parentOrg.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
					if (parentOrg.getOrganizationId() == companyOrgID) {
						if (org.getStatusId() != DeliveryOrganizationConstants.Organizaion_Unit_DEACTIVATE_STATUS) {
							organizationUnitMap.put(org.getName(), org);
							break;
						} else {
							break;
						}
					} else {
						if (parentOrg.getType().equalsIgnoreCase(
								DeliveryOrganizationConstants.TYPE_OU)) {
							org = parentOrg;
							try {
								parentOrg = parentOrg.getParentOrganization();
							} catch (PortalException e) {

								e.printStackTrace();
							} catch (SystemException e) {

								e.printStackTrace();
							}
						} else {
							break;
						}
					}
				} else {
					break;
				}
			}
		}
		return organizationUnitMap;
	}

	/* Method to get organization units for breadcrumb. */
	public static List<Organization> getBreadCrubOrganizationUnit(
			long compOrgId, Organization organizationUnit)
			throws SystemException, PortalException {

		HashMap<String, Organization> organizationUnitMap = new LinkedHashMap<String, Organization>();
		List<Organization> orgList = new ArrayList<Organization>();

		while (organizationUnit.getParentOrganizationId() != compOrgId) {
			organizationUnitMap.put(organizationUnit.getName(),
					organizationUnit);
			organizationUnit = organizationUnit.getParentOrganization();

		}

		orgList.addAll(organizationUnitMap.values());
		Collections.reverse(orgList);
		return orgList;
	}
	
	
	public static JSONArray getUserOrgMap(User user,Organization companyOrg) throws SystemException, PortalException
	{
		JSONArray orgMap=JSONFactoryUtil.createJSONArray();
		JSONObject compOrgObj=JSONFactoryUtil.createJSONObject();
		compOrgObj.put("label", "<i class='icon-globe'></i>" + companyOrg.getName());
		compOrgObj.put("expanded", true);
		JSONArray childArr=JSONFactoryUtil.createJSONArray();
		for(Organization org:getUserActiveOrganizationUnits(user.getUserId(), companyOrg.getOrganizationId()))
		{
			JSONObject childObj=JSONFactoryUtil.createJSONObject();
			childObj.put("label", "<i class='icon-sitemap'></i>"+org.getName());
			childObj.put("children",getUserOrgChildren(user, org));
			childObj.put("expanded", true);
			childArr.put(childObj);
		}
		compOrgObj.put("children",childArr);
		orgMap.put(compOrgObj);
		return orgMap;
	}
	public static JSONArray getUserOrgChildren(User user,Organization parentOrg) throws SystemException, PortalException
	{
		JSONArray orgChildren=JSONFactoryUtil.createJSONArray();
		for(Organization org:getUserActiveOrganizationUnits(user.getUserId(), parentOrg.getOrganizationId()))
		{
			
			JSONObject ouObject=JSONFactoryUtil.createJSONObject();
			ouObject.put("label","<i class='icon-sitemap'></i>"+ org.getName());
			ouObject.put("expanded", true);
			ouObject.put("children", getUserOrgChildren(user, org));
			orgChildren.put(ouObject);
	
			
		}
		
		for(Organization comp:getUserActiveCompetencies(user.getUserId(), parentOrg.getOrganizationId()))
		{
			JSONObject compObject=JSONFactoryUtil.createJSONObject();
			compObject.put("label", "<i class='icon-th-large'></i>" + comp.getName());
			compObject.put("expanded", true);
			JSONArray compChildren=JSONFactoryUtil.createJSONArray();
			for(Organization group:getUserActiveGroups(user.getUserId(),comp.getOrganizationId()))
			{
				JSONObject groupObj=JSONFactoryUtil.createJSONObject();
				groupObj.put("label","<i class='icon-group'></i>"+ group.getName());
				groupObj.put("expanded", true);
				JSONArray groupChildren=JSONFactoryUtil.createJSONArray();
				if(OrganizationLocalServiceUtil.hasUserOrganization(user.getUserId(), group.getOrganizationId()))
				{
					JSONObject userObject=JSONFactoryUtil.createJSONObject();
					userObject.put("label","<i class='icon-user icon-user-highlighted'></i>" + user.getFullName());
					userObject.put("type","leaf");
					userObject.put("doType","user");
					groupChildren.put(userObject);
				}
				groupObj.put("children",groupChildren);
				compChildren.put(groupObj);
			}
			if(OrganizationLocalServiceUtil.hasUserOrganization(user.getUserId(), comp.getOrganizationId()))
			{
				JSONObject userObject=JSONFactoryUtil.createJSONObject();
				userObject.put("label", "<i class='icon-user icon-user-highlighted'></i>" + user.getFullName());
				userObject.put("type","leaf");
				compChildren.put(userObject);
			}
			compObject.put("children",compChildren);
			orgChildren.put(compObject);
		}
		
		if(OrganizationLocalServiceUtil.hasUserOrganization(user.getUserId(), parentOrg.getOrganizationId()))
		{
			JSONObject userObject=JSONFactoryUtil.createJSONObject();
			userObject.put("label", "<i class='icon-user icon-user-highlighted'></i>"+user.getFullName());
			userObject.put("type","leaf");
			orgChildren.put(userObject);
		}
		
		return orgChildren;
	}
	

	public static List<Long> getSubOUids(long ouid)
			throws SystemException, PortalException
			{
		     
		List<Long> subOUids= new ArrayList<Long>();
		
		List<Organization> suborganizationList = new ArrayList<Organization>();
		
		suborganizationList = (List<Organization>) OrganizationLocalServiceUtil.getOrganization(ouid);
		for(Organization organization: suborganizationList)
		{
			subOUids.add(organization.getOrganizationId());
			
		}
		
		
		       return subOUids;
			}
	
}
