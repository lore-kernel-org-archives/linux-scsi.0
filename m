From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Thu, 29 Aug 2013 05:51:54 +0000
Message-ID: <bug-60644-11613-5xhjHvyrfj@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56382 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3H2Fv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 01:51:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C84BA202F6
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 05:51:56 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id EFA7520314
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 05:51:55 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #27 from liveaxle@live.com ---
Hi again .

I set up two disks as two seperate BTRFS volumes (No RAID) , and did some tests
.

One of the disks failed to complete the process given to it , but it wasn't
dropped , and checking the mountpoint shows that it still mounted . The error
it gives is "Stale file handle" .

The other drive , completed all the processes successfully .

It seems that RAID is indeed a problem if not THE problem .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
