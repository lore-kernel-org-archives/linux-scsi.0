From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69441] WARNING: CPU: 0 PID: 4992 at fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Mon, 27 Jan 2014 15:19:59 +0000
Message-ID: <bug-69441-11613-adxUYO1K6q@https.bugzilla.kernel.org/>
References: <bug-69441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41800 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbaA0PUD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jan 2014 10:20:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D8E5720121
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2014 15:20:01 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 71E8C200DC
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2014 15:19:59 +0000 (UTC)
In-Reply-To: <bug-69441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=69441

Joe Lawrence <joe.lawrence@stratus.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |joe.lawrence@stratus.com

--- Comment #3 from Joe Lawrence <joe.lawrence@stratus.com> ---
Hi Igor,

Does James' latest "target refcounting infrastructure fixes for usb" [1]
patchset take care of this for you?

[1] http://www.spinics.net/lists/linux-scsi/msg71631.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
