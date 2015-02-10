From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93051] New: Oops in kmem_cache_alloc / scsi_host_alloc_command
Date: Tue, 10 Feb 2015 16:56:06 +0000
Message-ID: <bug-93051-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41501 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbbBJQ4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2015 11:56:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0321120120
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2015 16:56:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4BFEE2013A
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2015 16:56:07 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=93051

            Bug ID: 93051
           Summary: Oops in kmem_cache_alloc / scsi_host_alloc_command
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.16.0-29-generic #39-Ubuntu
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: nathan.renniewaldock+kernelbugs@gmail.com
        Regression: No

Created attachment 166341
  --> https://bugzilla.kernel.org/attachment.cgi?id=166341&action=edit
oops 2015-01-30

Read errors on SCSI controllers appear to cause an oops.
Since I changed to an SAS controller, I was getting an oops immediately after a
read error. I've now moved the offending drive back to SATA and not had an oops
since.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
