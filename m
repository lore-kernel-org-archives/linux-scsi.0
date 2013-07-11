From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
 communication with XYRATEX disk shelves
Date: Thu, 11 Jul 2013 14:14:56 +0000
Message-ID: <bug-59601-11613-kSfWWUh5xA@https.bugzilla.kernel.org/>
References: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51740 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab3GKOPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jul 2013 10:15:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4DE5F201D1
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2013 14:14:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 124B6201B3
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2013 14:14:57 +0000 (UTC)
In-Reply-To: <bug-59601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601

Jack Hill <jackhill@jackhill.us> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |>2.6.38-rc2

--- Comment #10 from Jack Hill <jackhill@jackhill.us> ---
Saurav,

Yes, in my initial testing that patch does resolve the issue.

Thanks,
Jack

P.S. I set the kernel version field, becasue bugzilla was not letting me submit
this comment with it empty.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
