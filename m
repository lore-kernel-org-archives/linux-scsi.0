From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 8908] 3ware 9650SE -8LPML not recognized by 3w-9xxx driver
Date: Tue, 12 Feb 2008 11:30:34 -0800 (PST)
Message-ID: <20080212193035.048B5108069@picon.linux-foundation.org>
References: <bug-8908-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbYBLTaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 14:30:39 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1CJUZBl002913
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2008 11:30:36 -0800
In-Reply-To: <bug-8908-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8908





------- Comment #6 from aradford@gmail.com  2008-02-12 11:30 -------
The 9650SE (vendor:0x13c1, device id: 0x1004) controller series has been 
supported by the in-kernel 3w-9xxx driver since 2.6.19 kernel.

The user did not properly configure 'single disk' support through the 3ware
BIOS, tw_cli or 3dm2 tool.

Please close this bug.

-Adam Radford


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
