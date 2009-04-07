From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Tue, 7 Apr 2009 10:43:53 GMT
Message-ID: <200904071043.n37AhrjE014952@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55556 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZDGKnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 06:43:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n37AhrfK014953
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 10:43:53 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





--- Comment #25 from oshida@bb-next.net  2009-04-07 10:43:50 ---
Created an attachment (id=20859)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20859)
Following up circumstances

Dear fellows,

Thank you so much about maintaining linux kernel and also releasing the version
which contains this fix.

Now I attached another patch including more features;

- returning max_hw_sectors for reading max_sectors
- to limit max_sectors by the special value for usb storage

I think these features are required.
Of course they are useful for me, I may run my code on many versions of kernel
so max_sectors should be checkable and changeable at anytime.

Please discuss about them.

For addition, my PC can send/recv 4MB block but with 8MB ioctl() will report
ENOMEM. Usually the PC is running with 1GB RAM and increasing RAM is not
effective.

I'm sorry my target is only SCSI Generic so I don't know how SCSI Tape may
behave.

Sincerely,
Teruo Oshida

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
