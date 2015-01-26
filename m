From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Mon, 26 Jan 2015 23:21:21 +0000
Message-ID: <bug-81861-11613-hMyjFKmfJt@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbbAZXVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2015 18:21:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 34E7E201D3
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2015 23:21:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8991D201C8
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2015 23:21:23 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #22 from Nathan R <nathan.renniewaldock+kernelbugs@gmail.com> ---
Created attachment 164841
  --> https://bugzilla.kernel.org/attachment.cgi?id=164841&action=edit
Patched mvsas dmesg in kernel 3.18.3

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
