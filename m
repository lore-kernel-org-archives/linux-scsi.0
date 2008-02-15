From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 8004] a likely bug in "scsi/arm/cumana_2.c"
Date: Thu, 14 Feb 2008 22:44:33 -0800 (PST)
Message-ID: <20080215064433.48EDF10806C@picon.linux-foundation.org>
References: <bug-8004-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYBOGpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 01:45:06 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1F6iXEo010398
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 22:44:34 -0800
In-Reply-To: <bug-8004-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8004


protasnb@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |protasnb@gmail.com
         AssignedTo|scsi_drivers-other@kernel-  |linux-scsi@vger.kernel.org
                   |bugs.osdl.org               |




------- Comment #4 from protasnb@gmail.com  2008-02-14 22:44 -------
Well, the offending line is still there.
Lingxiao, would you like to submit a patch to  linux-scsi@vger.kernel.org?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
