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
import com.liferay.portal.kernel.model.Role;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.service.UserGroupRoleLocalServiceUtil;

import javax.portlet.PortletResponse;

/*Class organization role checker..*/
public class OrganizationRoleUserChecker extends RowChecker {

	private Organization _organization = null;
	private Role _role = null;

	public OrganizationRoleUserChecker(PortletResponse portletResponse,
			Organization organization, Role role) {
		super(portletResponse);

		_organization = organization;
		_role = role;

	}

	@Override
	public boolean isChecked(Object obj) {

		User user = (User) obj;
		try {
			return UserGroupRoleLocalServiceUtil.hasUserGroupRole(
					user.getUserId(), _organization.getGroupId(),
					_role.getRoleId());
		} catch (SystemException e) {
			return false;
		}
	}

}
