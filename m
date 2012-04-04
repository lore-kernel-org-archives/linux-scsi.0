From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42918] fcoe: Enabling VN2VN mode triggers a circular locking
 complaint
Date: Wed, 4 Apr 2012 14:56:52 GMT
Message-ID: <201204041456.q34EuqDM007555@bugzilla.kernel.org>
References: <bug-42918-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41416 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab2DDO4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2012 10:56:52 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q34Euq1h007556
	for <linux-scsi@vger.kernel.org>; Wed, 4 Apr 2012 14:56:52 GMT
In-Reply-To: <bug-42918-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42918


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #2 from Florian Mickler <florian@mickler.org>  2012-04-04 14:56:51 ---
A patch referencing this bug report has been merged in Linux v3.4-rc1:

commit 2280512342ead9a2858b1490b21e5bcaf4f4cfc7
Author: Robert Love <robert.w.love@intel.com>
Date:   Tue Mar 13 18:22:12 2012 -0700

    [SCSI] fcoe: Drop the rtnl_mutex before calling fcoe_ctlr_link_up

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
