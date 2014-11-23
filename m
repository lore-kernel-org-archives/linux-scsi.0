From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88771] New: No API to synchronize against SCSI bus scanning
Date: Sun, 23 Nov 2014 16:56:23 +0000
Message-ID: <bug-88771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaKWQ40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2014 11:56:26 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D51EE2025A
	for <linux-scsi@vger.kernel.org>; Sun, 23 Nov 2014 16:56:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A076120259
	for <linux-scsi@vger.kernel.org>; Sun, 23 Nov 2014 16:56:23 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=88771

            Bug ID: 88771
           Summary: No API to synchronize against SCSI bus scanning
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.2.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: Simon.Richter@hogyros.de
        Regression: No

With the rightful demise of the scsi_wait_scan module, there is no interface
left to find out whether any host adapter is currently scanning and synchronize
against it.

With a kernel that has asynchronous scanning disabled, modular SCSI drivers and
udev, this can be worked around by "udevadm settle", however that is not a
generic solution.

Would it make sense to provide a sysfs object that an userspace program could
use to synchronize against the end of SCSI scans?

-- 
You are receiving this mail because:
You are the assignee for the bug.
