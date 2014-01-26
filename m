From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69441] WARNING: CPU: 0 PID: 4992 at fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Sun, 26 Jan 2014 15:47:39 +0000
Message-ID: <bug-69441-11613-VbIBJedWVn@https.bugzilla.kernel.org/>
References: <bug-69441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39167 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaAZPrq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jan 2014 10:47:46 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 97F2920142
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jan 2014 15:47:45 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2A82020127
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jan 2014 15:47:40 +0000 (UTC)
In-Reply-To: <bug-69441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=69441

Greg Kroah-Hartman <greg@kroah.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|SysFS                       |Other
           Assignee|greg@kroah.com              |scsi_drivers-other@kernel-b
                   |                            |ugs.osdl.org
            Product|File System                 |SCSI Drivers

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
