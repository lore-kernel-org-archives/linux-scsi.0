From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69441] WARNING: CPU: 0 PID: 4992 at fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Mon, 12 May 2014 15:42:12 +0000
Message-ID: <bug-69441-11613-Kwb2SIqKQ6@https.bugzilla.kernel.org/>
References: <bug-69441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48293 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaELPmR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2014 11:42:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 32E1F200CF
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2014 15:42:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6754120165
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2014 15:42:14 +0000 (UTC)
In-Reply-To: <bug-69441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=69441

Alan Stern <stern@rowland.harvard.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |stern@rowland.harvard.edu

--- Comment #6 from Alan Stern <stern@rowland.harvard.edu> ---
This problem has been fixed by commit e63ed0d7a980 ([SCSI] fix our current
target reap infrastructure), which is part of 3.15-rc1.  It will not be ported
to earlier stable kernels until James Bottomley is satisfied that it does not
introduce any new bugs.  That is why you still see reports of this problem on
the distribution Bugzillas from users running 3.13.y and 3.14.y.

The bug report should be closed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
