From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Sat, 23 Aug 2014 22:12:23 +0000
Message-ID: <bug-81861-11613-9Wht0K3xCa@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37152 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaHWWM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 18:12:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 44199201D3
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 22:12:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id DE037201BC
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 22:12:23 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #15 from linux-ide@crashplan.pro ---
Created attachment 147881
  --> https://bugzilla.kernel.org/attachment.cgi?id=147881&action=edit
Ubuntu Linux/x86_64 3.13.0-35-generic Kernel Configuration

This kernel configuration was used to build both the patched and unpatched
mvsas.ko

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
