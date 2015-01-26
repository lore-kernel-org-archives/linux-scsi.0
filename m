From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Mon, 26 Jan 2015 23:19:03 +0000
Message-ID: <bug-81861-11613-loYLUPhOgf@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38704 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbbAZXTH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2015 18:19:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 465222011D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2015 23:19:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8E1D4201C8
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2015 23:19:04 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

nathan.renniewaldock+kernelbugs@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nathan.renniewaldock+kernel
                   |                            |bugs@gmail.com

--- Comment #20 from nathan.renniewaldock+kernelbugs@gmail.com ---
There seems to be various issues with this driver. After reverting that commit,
I can load the driver, but insmod takes a long time to return. One time was
about 3mins, the other times I gave up waiting and rebooted after 5mins. I'm
using an Areca ARC-1320, so I've ended up downgrading my kernel and using the
proprietary driver just so that it works.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
