/**
 * Copyright (c) 2019 LTI. All rights reserved.
 */

package com.lti.itops.ipac.cidefinition.permission;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.model.Organization;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.theme.ThemeDisplay;


/**
 * Permission util class for customers
 */

/**
 * @author Raj Kumar Kulasekaran
 */   

public class CustomerPermission {
	/**
	 * Checks if the user has manage permission for the customer organization or it's
	 * parent company organization
	 * @throws SystemException 
	 * @throws PortalException 
	 */
	public static boolean isManager(ThemeDisplay themeDisplay,
			Organization customer) throws PortalException, SystemException {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();
		Organization companyOrg=customer.getParentOrganization();
		if (permissionChecker.hasPermission(companyOrg.getGroupId(),
				Organization.class.getName(),companyOrg.getOrganizationId(),
				CustomerActionKeys.MANAGE_CUSTOMERS)
				|| permissionChecker.hasPermission(
						customer.getGroupId(),
						Organization.class.getName(), customer.getOrganizationId(),
						ActionKeys.MANAGE)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Checks if the user has permission permission for the organization
	 */
	public static boolean isPermissionAdmin(ThemeDisplay themeDisplay,
			Organization customer) {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();
		if (permissionChecker.hasPermission(
						customer.getGroupId(),
						Organization.class.getName(), customer.getOrganizationId(),
						ActionKeys.PERMISSIONS)) {
			return true;
		} else {
			return false;
		}
	}

}