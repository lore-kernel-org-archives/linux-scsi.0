From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111341] New: Firmware loader
Date: Tue, 26 Jan 2016 23:17:35 +0000
Message-ID: <bug-111341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57583 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbcAZXRj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 18:17:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9015B2027D
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2016 23:17:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F1C022026D
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2016 23:17:35 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111341

            Bug ID: 111341
           Summary: Firmware loader
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.5_rc1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: walter.moeller@moeller-it.net
        Regression: No

Intel driver HDD ahci c600 /sas /sata build in kernel does not build in
firmware.

kernel 4.4.0 ist ok

regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
