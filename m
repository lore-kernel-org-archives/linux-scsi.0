From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] SG_FLAG_LUN_INHIBIT is no longer implemented and there's
 not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Mon, 21 Jul 2014 09:05:04 +0000
Message-ID: <bug-80711-11613-K93vbWd0lq@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60370 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbaGUJFG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2014 05:05:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C266C20149
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2014 09:05:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0C49D2012B
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2014 09:05:05 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

Tiziano Bacocco <tiziano.bacocco@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #143541|0                           |1
        is obsolete|                            |

--- Comment #2 from Tiziano Bacocco <tiziano.bacocco@gmail.com> ---
Created attachment 143611
  --> https://bugzilla.kernel.org/attachment.cgi?id=143611&action=edit
This patch allows using SG_FLAG_LUN_INHIBIT

Removed useless patch to blkdev.h

-- 
You are receiving this mail because:
You are the assignee for the bug.
