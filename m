From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Wed, 29 Apr 2015 13:40:15 +0000
Message-ID: <bug-81861-11613-zXvwHJt3aC@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422935AbbD2NkT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2015 09:40:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7946C201F2
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2015 13:40:18 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8B685201E4
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2015 13:40:17 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #24 from Nathan R <nathan.renniewaldock+kernelbugs@gmail.com> ---
Created attachment 175261
  --> https://bugzilla.kernel.org/attachment.cgi?id=175261&action=edit
dmesg output after loading module

Just tested the driver from linux-stable since that patch has been merged.
After loading, I get a bunch of "failed to IDENTIFY" errors, then an oops and
insmod never returned (so far been 15mins and nothing new in dmesg).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
