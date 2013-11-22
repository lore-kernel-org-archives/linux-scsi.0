From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65411] New: compille error message
Date: Fri, 22 Nov 2013 01:45:45 +0000
Message-ID: <bug-65411-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60552 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3KVBps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Nov 2013 20:45:48 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 76DFF2045A
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2013 01:45:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 445B020726
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2013 01:45:45 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=65411

            Bug ID: 65411
           Summary: compille error message
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.12
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ADVANSYS
          Assignee: scsi_drivers-advansys@kernel-bugs.osdl.org
          Reporter: cattybaby75@gmail.com
        Regression: No

drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not
properly converted to the DMA API [-Wcpp]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
