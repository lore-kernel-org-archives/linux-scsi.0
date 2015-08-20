From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Thu, 20 Aug 2015 07:55:06 +0000
Message-ID: <bug-101891-11613-28ZDiLPKuy@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49902 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbbHTHzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2015 03:55:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DBAF720555
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 07:55:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 20B9D2054C
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 07:55:07 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101891

Turbo Fredriksson <turbo@bayour.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |turbo@bayour.com

--- Comment #6 from Turbo Fredriksson <turbo@bayour.com> ---
Forgive an ignoramus, but those last lines doesn't look to good

    kernel: ata11.00: device reported invalid CHS sector 0

I have a problem that is very much like yours, but my stack traces are
different so I'm unsure if we have the same problem. I'm going to rebuild my
kernel as well with your fix and see if it helps me as well.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
