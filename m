From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Wed, 28 Aug 2013 13:33:30 +0000
Message-ID: <bug-60644-11613-Wt3kiaxyYZ@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54096 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab3H1Nde (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Aug 2013 09:33:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 58CA82041C
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 13:33:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4402420516
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 13:33:32 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #26 from liveaxle@live.com ---
Hi .

Thanks for your kind help , Bernd .

setting /sys/block/sdX(c~j)/device/queue_depth to 1 unfortuantely didn't solve
the issue .

I put the following in the end of the boot line :

mpt2sas.disable_watchdog=1 mpt2sas.max_queue_depth=1 mpt2sas.max_sgl_entries=64
mpt2sas.max_sectors=64

However , the OS doesn't see the controllers anymore . So I had to remove these
entries from the boot line .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
