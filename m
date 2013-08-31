From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sat, 31 Aug 2013 03:39:01 +0000
Message-ID: <bug-60758-11613-o68M7vy7MK@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57761 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab3HaDjF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Aug 2013 23:39:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7AE6720384
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 03:39:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1A65B202F0
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 03:39:02 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #5 from Jeff Zhou <jz.researcher@yahoo.com> ---
If your system fails by "module scsi_wait_scan not found", then it could be the
init script issue in your CentOS box.

The last kernel with scsi_wait_scan.ko is v3.5.7, it has been removed ever
since v3.6. Any init script for 3.10 should not use that module.


Another point is in your config, the CONFIG_SCSI_SCAN_ASYNC is not set, try to
turn it into Y and see what's happening.

-- 
You are receiving this mail because:
You are the assignee for the bug.
