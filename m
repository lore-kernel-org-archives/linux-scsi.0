From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Sun, 19 Feb 2012 12:48:25 GMT
Message-ID: <201202191248.q1JCmPXX014260@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41044 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2BSMsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Feb 2012 07:48:25 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1JCmPnu014261
	for <linux-scsi@vger.kernel.org>; Sun, 19 Feb 2012 12:48:25 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783


Stefan Richter <stefanr@s5r6.in-berlin.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |stefanr@s5r6.in-berlin.de




--- Comment #6 from Stefan Richter <stefanr@s5r6.in-berlin.de>  2012-02-19 12:48:23 ---
Whether you have hal or not does not really matter.  More recent userland
without hal but with udisks-daemon triggers an oops at unplug of
removable-media drives too.  This is meant to be addressed by the patch from
comment 4.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
