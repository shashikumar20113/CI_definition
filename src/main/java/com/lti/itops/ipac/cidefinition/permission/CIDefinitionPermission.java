/**
 * Copyright (c) 2019 LTI. All rights reserved.
 * @author Surendra K
 */

package com.lti.itops.ipac.cidefinition.permission;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.theme.ThemeDisplay;

public class CIDefinitionPermission {
	
	
	public static boolean hasCIDefinitionViewPermission(ThemeDisplay themeDisplay) throws PortalException, SystemException {
		
		return true;
	}
	
	public static boolean hasCIDefinitionManagePermission(ThemeDisplay themeDisplay) throws PortalException, SystemException {
		
		return true;
	}


}
