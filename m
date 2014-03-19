From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69441] WARNING: CPU: 0 PID: 4992 at fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Wed, 19 Mar 2014 13:02:38 +0000
Message-ID: <bug-69441-11613-TwYjLIFCov@https.bugzilla.kernel.org/>
References: <bug-69441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34872 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaCSRs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2014 13:48:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1611A203B8
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2014 13:02:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id EA0EA203DF
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2014 13:02:39 +0000 (UTC)
In-Reply-To: <bug-69441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=69441

Igor Gnatenko <i.gnatenko.brain@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|CODE_FIX                    |---

--- Comment #5 from Igor Gnatenko <i.gnatenko.brain@gmail.com> ---
We can again reproduce this problem.

>From RHBZ.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
