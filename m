From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Mon, 02 Sep 2013 19:45:13 +0000
Message-ID: <bug-60758-11613-6ptxWZBw4r@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47924 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab3IBTpR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 15:45:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B0DF820176
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2013 19:45:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E13482018A
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2013 19:45:13 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #20 from Jeff Zhou <jz.researcher@yahoo.com> ---
Yes, there could be extra bugs.

Since this bug is about "scsi_wait_scan not found" in v3.10.5 and above, we can
try to work on this one first.

As suggested by Alan, the lsinitrd is available, it can be used to list out the
modules of a initramfs file.
Would you like to run lsinitrd for a working version (v.3.10.4-1) and the first
version with issue (v.3.10.5-1) to show the modules in the initramfs file?

lsinitrd initrd_v.xxx.img > v.xxx.lst

-- 
You are receiving this mail because:
You are the assignee for the bug.
