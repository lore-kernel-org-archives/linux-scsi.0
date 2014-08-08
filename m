From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Fri, 08 Aug 2014 08:24:01 +0000
Message-ID: <bug-81861-11613-PXFa89TpYC@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbaHHIYD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2014 04:24:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DF2DD201C8
	for <linux-scsi@vger.kernel.org>; Fri,  8 Aug 2014 08:24:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 62C68201BA
	for <linux-scsi@vger.kernel.org>; Fri,  8 Aug 2014 08:24:01 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

linux-ide@crashplan.pro changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|mvsas.ko v0.8.16 error      |Oops by mvsas v0.8.16: sas:
                   |messages and kernel crashes |ataX: end_device-Y:0:Z: dev
                   |attaching 4 SATA drives to  |error handler -> general
                   |specific HP SAS expander    |protection fault, RIP:
                   |ports                       |mvs_task_prep_ata+0x80/0x3a
                   |                            |0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
