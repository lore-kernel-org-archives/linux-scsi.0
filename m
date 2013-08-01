From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Thu, 01 Aug 2013 14:30:11 +0000
Message-ID: <bug-60644-11613-Y8nW9bx76V@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44631 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab3HAOaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 10:30:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9319D201BE
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2013 14:30:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1739520233
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2013 14:30:12 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #16 from liveaxle@live.com ---
Hello .

The thing is that I'm using SATA drives and not SAS drives . The motherboard
exposes the LSI controller as 8 SATA ports .

This wasn't an issue under Windows 2012 , so I think that hardware issues are
pretty much not the cause in here .

Sorry if I'm demanding too much , but can you try to create a BTRFS RAID1 ,
fill it with data and then run :

btrfs scrub start /MOUNTPOINT

It always produces the issue in less than 2 minutes .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
