From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 73621] New: Kernel exception loading sym53c8xx on dual AMD
 Athlon Tyan S2460 motherboard
Date: Sun, 06 Apr 2014 14:53:56 +0000
Message-ID: <bug-73621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44132 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbaDFOx6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Apr 2014 10:53:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E5B0320398
	for <linux-scsi@vger.kernel.org>; Sun,  6 Apr 2014 14:53:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F03202037D
	for <linux-scsi@vger.kernel.org>; Sun,  6 Apr 2014 14:53:56 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=73621

            Bug ID: 73621
           Summary: Kernel exception loading sym53c8xx on dual AMD Athlon
                    Tyan S2460 motherboard
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.10.36
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: sym53c8xx
          Assignee: scsi_drivers-sym53c8xx@kernel-bugs.osdl.org
          Reporter: sk8tesgre8t@gmail.com
        Regression: No

Created attachment 131551
  --> https://bugzilla.kernel.org/attachment.cgi?id=131551&action=edit
dmesg output from boot on Tyan S2460 using kernel version 3.10.36,
Slackware-Current

Kernel raises an exception when loading sym53c8xx module.  See dmesg output in
attached file.

Regards,

Fred

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
