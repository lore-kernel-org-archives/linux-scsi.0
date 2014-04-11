From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Fri, 11 Apr 2014 13:15:11 +0000
Message-ID: <bug-71231-11613-USvm1veeI6@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53938 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbaDKNPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 09:15:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 91F4320824
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 13:15:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AB7D32039E
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 13:15:19 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #14 from Alex <alexandernaumann@gmx.de> ---
My Grub entry is:

title           Test
root            (hd0,0)
kernel          /boot/vmlinuz-3.10.25 root=/dev/sdb2 ro console=ttyS0
boot

Removing "console=ttyS0" will fix this problem.
But this isn't a solution for me.

-- 
You are receiving this mail because:
You are the assignee for the bug.
