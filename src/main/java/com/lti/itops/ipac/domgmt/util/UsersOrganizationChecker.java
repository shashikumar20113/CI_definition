/**
 * Copyright (c) 2018 LTI. All rights reserved.
 */

/**
 * @author Abhishek Sharma
 */

package com.lti.itops.ipac.domgmt.util;

import com.liferay.portal.kernel.dao.search.RowChecker;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.model.Organization;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;

import javax.portlet.PortletResponse;

/*Class to check users organization.*/
public class UsersOrganizationChecker extends RowChecker {
	private Organization _organization = null;

	public UsersOrganizationChecker(PortletResponse portletResponse,
			Organization organization) {
		super(portletResponse);
		_organization = organization;

	}

	@Override
	public boolean isChecked(Object obj) {
		User user = (User) obj;
		try {
			return UserLocalServiceUtil.hasOrganizationUser(
					_organization.getOrganizationId(), user.getUserId());
		} catch (SystemException e) {
			return false;
		}

	}

}
