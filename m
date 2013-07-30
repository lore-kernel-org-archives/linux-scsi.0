From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 30 Jul 2013 10:11:23 +0000
Message-ID: <bug-60644-11613-G3lyWvWhdR@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40319 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3G3KLb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jul 2013 06:11:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 564582046B
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 10:11:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9C9BE20462
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 10:11:23 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #12 from liveaxle@live.com ---
Hi .

I can easily reproduce this issue in a second by running :

btrfs scrub start /MOUNTPOINT

The btrfs system is a RAID1 that consists of 5 drives .


Also in an MD-RAID0 that consists of 3 drives by running a little harsh
commands like :

dd if=/dev/zero of=/MOUNTPOINT/dd.img bs=1G count=300

and/or :

md5deep -r /MOUNTPOINT


My CPU is an Ivy-Bridge i5 , with 32GB of RAM . (Watching htop , the CPU never
reaches 30% of load)

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
