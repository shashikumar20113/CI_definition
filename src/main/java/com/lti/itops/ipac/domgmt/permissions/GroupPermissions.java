/**
 * Copyright (c) 2018 LTI. All rights reserved.
 */

/**
 * @author Abhishek Sharma
 */

package com.lti.itops.ipac.domgmt.permissions;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.model.Organization;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.lti.itops.ipac.domgmt.util.DeliveryOrganizationConstants;

/**
 * Permission util class for Group Organizations.
 */
public class GroupPermissions {
	/**
	 * Checks if the user has manage permission for the Group or it's parent
	 * company
	 * 
	 * @throws SystemException
	 * @throws PortalException
	 */
	public static boolean isManager(ThemeDisplay themeDisplay,
			Organization organization) throws PortalException, SystemException {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();
		if (organization.getType().equalsIgnoreCase(
				DeliveryOrganizationConstants.TYPE_GROUP)) {
			if (permissionChecker.hasPermission(organization.getGroupId(),
					Organization.class.getName(),
					organization.getOrganizationId(), ActionKeys.MANAGE)) {
				return true;
			} else if (organization
					.getParentOrganization()
					.getType()
					.equalsIgnoreCase(
							DeliveryOrganizationConstants.TYPE_COMPETENCY)) {
				return CompetencyPermissions.isManager(themeDisplay,
						organization.getParentOrganization());
			}
		}
		return false;
	}

	/**
	 * Checks if the user has permission to manage permission for the Group or
	 * it's parent company
	 * 
	 * @throws SystemException
	 * @throws PortalException
	 */
	public static boolean isPermissionAdmin(ThemeDisplay themeDisplay,
			Organization organization) throws PortalException, SystemException {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();

		if (permissionChecker.hasPermission(organization.getGroupId(),
				Organization.class.getName(), organization.getOrganizationId(),
				ActionKeys.PERMISSIONS)) {
			return true;
		} else {
			return false;
		}

	}
}
