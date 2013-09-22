From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sun, 22 Sep 2013 13:38:22 +0000
Message-ID: <bug-60758-11613-1rd3ms6ich@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41881 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab3IVNi1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Sep 2013 09:38:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4922020520
	for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2013 13:38:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 731EF20387
	for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2013 13:38:23 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #30 from zakrzewskim@wp.pl ---
(In reply to Alan Bartlett from comment #24)
> (3) Grep'ing the standard RHEL 6 /etc/rc.d/rc.sysinit file shows something
> interesting on line 165 but, once again, I do not think it is relevant.

Nice find. I will try booting with this line commented ;)

-- 
You are receiving this mail because:
You are the assignee for the bug.
