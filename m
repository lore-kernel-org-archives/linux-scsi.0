From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Sat, 23 Aug 2014 20:06:31 +0000
Message-ID: <bug-81861-11613-r6YvNhvG6d@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35398 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaHWUGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 16:06:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 412EF20131
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 20:06:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 86AED2018A
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 20:06:31 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #14 from linux-ide@crashplan.pro ---
By the way:

printk("%d", mvi->tx_prod]);

was changed to:

printk("%d", mvi->tx_prod);

The square bracket after tx_prod was removed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
