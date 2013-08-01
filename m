From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Thu, 01 Aug 2013 14:24:57 +0000
Message-ID: <bug-60644-11613-NquaKOIe2F@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44372 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab3HAOZF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 10:25:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C86072021F
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2013 14:25:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0A1AB20240
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2013 14:24:58 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #15 from Sreekanth Reddy <sreekanth.reddy@lsi.com> ---
(In reply to liveaxle from comment #14)
> Hi .

> Any updates regarding this bug ?

I tried to reproduce this issue locally, but for me this issue is not
reproduced.

Here are the steps which I followed to reproduce the issue

1. I have created RAID0 vloume on two 500 GB SAS drives.
2. Created the EXT4 file system.
3. Mounted this FS to /mnt
4. And run the IO's using cmd 'dd if=/dev/zero of=/mnt/dd.img bs=1G count=300'

Result:
IO's run successfully with out any issue.

Please let me know whether I have missed any steps while reproducing this
issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
