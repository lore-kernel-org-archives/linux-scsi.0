From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Thu, 29 Aug 2013 10:09:58 +0000
Message-ID: <bug-60644-11613-XXJYyLl9xh@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35416 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab3H2KKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 06:10:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 132CA2042A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 10:10:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F28D220420
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 10:09:59 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #28 from liveaxle@live.com ---
PS . :

To summerize what I have in my server :

1 - BTRFS RAID1 (5 disks) : FAILS

2 - BTRFS Single Data Profile (2 disks) : FAILS 

3 - BTRFS Single disk FS (No RAID) : FAILS (But recovers without rebooting -
Doesn't drop or Unmount)

4 - BTRFS Single disk FS (No RAID) : WORKS .


I'll run one test , this time I'll use a leafsize of 64k , I have a doubt that
it helps .

THank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
