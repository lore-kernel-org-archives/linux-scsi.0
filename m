From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sun, 22 Sep 2013 13:55:15 +0000
Message-ID: <bug-60758-11613-7f0j3V0bj4@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42104 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab3IVNzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Sep 2013 09:55:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2E28A204D5
	for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2013 13:55:18 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9FB7A204A3
	for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2013 13:55:15 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #31 from zakrzewskim@wp.pl ---
Standard CentOS 6 kernel got such module:

/lib/modules/2.6.32-358.18.1.el6.x86_64/kernel/drivers/scsi/scsi_wait_scan.ko
/lib/modules/2.6.32-358.el6.x86_64/kernel/drivers/scsi/scsi_wait_scan.ko

That's why it's referring to it.

-- 
You are receiving this mail because:
You are the assignee for the bug.
