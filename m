From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69441] WARNING: CPU: 0 PID: 4992 at fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Sat, 22 Feb 2014 14:00:41 +0000
Message-ID: <bug-69441-11613-10r8F1WxG0@https.bugzilla.kernel.org/>
References: <bug-69441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54219 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaBVOAp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Feb 2014 09:00:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 62593201DD
	for <linux-scsi@vger.kernel.org>; Sat, 22 Feb 2014 14:00:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4BB11201EF
	for <linux-scsi@vger.kernel.org>; Sat, 22 Feb 2014 14:00:42 +0000 (UTC)
In-Reply-To: <bug-69441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=69441

Igor Gnatenko <i.gnatenko.brain@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #4 from Igor Gnatenko <i.gnatenko.brain@gmail.com> ---
I can't reproduce this bug on master branch, so close it as FIXED.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
