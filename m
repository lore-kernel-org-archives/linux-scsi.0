From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Wed, 29 Apr 2015 13:41:15 +0000
Message-ID: <bug-81861-11613-lyBaesgd4M@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422935AbbD2NlT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2015 09:41:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 32AE8201F4
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2015 13:41:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6E4E4201EC
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2015 13:41:17 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

Nathan R <nathan.renniewaldock+kernelbugs@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #175261|application/octet-stream    |text/plain
          mime type|                            |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
