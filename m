From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88591] New: SCSI_IOCTL_GET_IDLUN only returns 8 bits for the
 SCSI Target value
Date: Thu, 20 Nov 2014 17:55:41 +0000
Message-ID: <bug-88591-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858AbaKTRzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2014 12:55:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 12AF620225
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2014 17:55:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B719E20221
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2014 17:55:41 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=88591

            Bug ID: 88591
           Summary: SCSI_IOCTL_GET_IDLUN only returns 8 bits for the SCSI
                    Target value
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.14.22
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: kg6esx@gmail.com
        Regression: No

However, very large configurations can have target ids that exceed 255.
Or, in the process of devices dropping offline and being rediscovered, they can
be assigned target ids greater than 255.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
