From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Sun, 19 Oct 2014 15:56:21 +0000
Message-ID: <bug-81861-11613-dQYuysJZDP@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45584 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaJSP4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2014 11:56:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 48F6D201F7
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 15:56:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C81A22020F
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 15:56:22 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

linux-ide@crashplan.pro changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|3.16.0                      |3.17.1

--- Comment #18 from linux-ide@crashplan.pro ---
Even after flashing the SAS2LP-MV8 its firmware from version 4.0.0.1800 to
version 4.0.0.1812 the mvs_task_prep_ata+0x80/0x3a0 [mvsas] kernel oops issue
persists on kernel:

1. "Linux ubuntu25 3.17.1-031701-generic #201410150735 SMP Wed Oct 15 11:36:31
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux" and
2. "Linux ubuntu25 3.17.0-999-generic #201410182205 SMP Sun Oct 19 02:06:22 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
