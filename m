From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60191] New: Bad flush cache
Date: Wed, 26 Jun 2013 21:45:02 +0000 (UTC)
Message-ID: <bug-60191-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47847 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab3FZVpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jun 2013 17:45:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7FB6C20398
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 21:45:09 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B11D4203B5
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 21:45:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60191

           Summary: Bad flush cache
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.8.13
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: mustelator@yahoo.es
        Regression: No


Hello to all, I'm Toni and it's my first Kernel bug. I hope help to detect
problems on kernels (I'm not developer but yes detector ;))

Ok, and now start.

When I dump image into SD card with IO operations apparently ok, and it
continue past 100% (cache flushing) I can see that the writing is not 100% busy
time on the output device. The IO monitor show this.

For example, I can show: 100% 1 second, 0% 1 second, 100% 2 seconds, 0% 0,5
seconds...

AND, in some situations, the umount on FAT32 on USB drives sometimes not really
umount well, but this is other war.

Cheers!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
