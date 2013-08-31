From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sat, 31 Aug 2013 17:03:08 +0000
Message-ID: <bug-60758-11613-vcljTz6Gi7@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41205 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab3HaRDL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Aug 2013 13:03:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 95CDB202C6
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 17:03:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 76AA1202DB
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 17:03:08 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #10 from zakrzewskim@wp.pl ---
Made a mistake, so once again:

timeout 0
default 0

title CentOS (3.10.10-1.el6.elrepo.x86_64)
root (hd0,1)
kernel /vmlinuz-3.10.10-1.el6.elrepo.x86_64 ro root=/dev/md2 rd_NO_LUKS
rd_NO_DM nomodeset crashkernel=auto SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8
KEYTABLE=de scsi_mod.scan=async
initrd /initramfs-3.10.10-1.el6.elrepo.x86_64.img

-- 
You are receiving this mail because:
You are the assignee for the bug.
