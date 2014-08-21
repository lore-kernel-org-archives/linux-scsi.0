From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Thu, 21 Aug 2014 18:35:45 +0000
Message-ID: <bug-81861-11613-96Dv6g9KK2@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50933 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaHUSfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2014 14:35:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B59932018A
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2014 18:35:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5DF7A201B9
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2014 18:35:46 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|3.16.0-031600rc6.x86_64     |3.16.0

--- Comment #5 from Alan <alan@lxorguk.ukuu.org.uk> ---
Thats not a sensible resolution, it can't be faulting on that line.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
