From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194341] New: drivers/scsi/mpt3sas/mpt3sas_scsih.c
 _scsih_ir_fastpath ambiguous path structures
Date: Tue, 07 Feb 2017 06:04:35 +0000
Message-ID: <bug-194341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbdBGGEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 01:04:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5317220263
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2017 06:04:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 4FD61202BE
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2017 06:04:35 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194341

            Bug ID: 194341
           Summary: drivers/scsi/mpt3sas/mpt3sas_scsih.c
                    _scsih_ir_fastpath ambiguous path structures
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: michael_allen_bond@hotmail.com
        Regression: No

Given the number of error checks and intermittent conditional branches all
ending with the same error code, it may be worth restructuring this path to
optimistically execute the fast path and then have a single set of error checks
at the end, since all of the errors immediately exit the function with a error
code anyways.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
