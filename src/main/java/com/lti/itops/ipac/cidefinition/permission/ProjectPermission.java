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
import com.lti.itops.ipac.cidefinition.permission.CustomerPermission;

/**
 * Permission util class for projects
 */

/**
 * @author Raj Kumar Kulasekaran
 */   

public class ProjectPermission {
	/**
	 * Checks if the user has manage permission for the project organization or it's
	 * parent organizations
	 * @throws SystemException 
	 * @throws PortalException 
	 */
	public static boolean isManager(ThemeDisplay themeDisplay,
			Organization project) throws PortalException, SystemException {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();
		Organization customer=project.getParentOrganization();
		if (permissionChecker.hasPermission(
						project.getGroupId(),
						Organization.class.getName(), project.getOrganizationId(),
						ActionKeys.MANAGE) || CustomerPermission.isManager(themeDisplay, customer)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Checks if the user has permission permission for the organization
	 */
	public static boolean isPermissionAdmin(ThemeDisplay themeDisplay,
			Organization project) {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();
		if (permissionChecker.hasPermission(
						project.getGroupId(),
						Organization.class.getName(), project.getOrganizationId(),
						ActionKeys.PERMISSIONS)) {
			return true;
		} else {
			return false;
		}
	}

	
	/**
	 * Checks if the user has WLA manage permission for the project organization or it's
	 * parent organizations
	 * @throws SystemException 
	 * @throws PortalException 
	 */
	public static boolean hasWLAManagerPermission(ThemeDisplay themeDisplay,
			Organization project) throws PortalException, SystemException {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();
		
		
		Organization customer=project.getParentOrganization();
		/*if (permissionChecker.hasPermission(
						project.getGroupId(),
						Organization.class.getName(), project.getOrganizationId(),
						CustomerActionKeys.MANAGE_WLA) || CustomerPermission.isManager(themeDisplay, customer))*/ 
		
		if (permissionChecker.hasPermission(project.getGroupId(),
				Organization.class.getName(), project.getOrganizationId(), CustomerActionKeys.MANAGE_WLA)){
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * Checks if the user has View WLA permission for the project organization or it's
	 * parent organizations
	 * @throws SystemException 
	 * @throws PortalException 
	 */
	public static boolean hasViewWLAPermission(ThemeDisplay themeDisplay,
			Organization project) throws PortalException, SystemException {
		PermissionChecker permissionChecker = themeDisplay
				.getPermissionChecker();
		Organization customer=project.getParentOrganization();
		/*if (permissionChecker.hasPermission(
						project.getGroupId(),
						Organization.class.getName(), project.getOrganizationId(),
						CustomerActionKeys.MANAGE_WLA) || CustomerPermission.isManager(themeDisplay, customer))*/ 
		
		if (permissionChecker.hasPermission(project.getGroupId(),
				Organization.class.getName(), project.getOrganizationId(), CustomerActionKeys.VIEW_WLA)){
			return true;
		} else {
			return false;
		}
	}
	
	
	/**
	 * Checks if the user has any level WLA permission for the project organization or it's
	 * parent organizations
	 * @throws SystemException 
	 * @throws PortalException 
	 */
	
	public static boolean hasWLAPermission(ThemeDisplay themeDisplay,
			Organization project) {
		
		boolean validWLA = false;
		
		try {
			if(hasViewWLAPermission(themeDisplay, project)||hasWLAManagerPermission(themeDisplay, project)) {
				
				validWLA = true;
				
			}else {
				validWLA = false;
			}
			
		} catch (SystemException | PortalException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return validWLA;
		
		
	}
	
	
}