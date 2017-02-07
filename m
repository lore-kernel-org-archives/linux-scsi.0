From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194321] New: drivers/scsi/mpt3sas/mpt3sas_base.c
 mpt3sas_base_put_smid_fast_path structure
 descriptor.Default.DescriptorTypeDependent is not used in fast path
Date: Tue, 07 Feb 2017 06:00:55 +0000
Message-ID: <bug-194321-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbdBGGA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 01:00:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 7638F202BE
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2017 06:00:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 75F802026F
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2017 06:00:55 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194321

            Bug ID: 194321
           Summary: drivers/scsi/mpt3sas/mpt3sas_base.c
                    mpt3sas_base_put_smid_fast_path structure
                    descriptor.Default.DescriptorTypeDependent is not used
                    in fast path
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

Our tool gave us a warning regarding this field being unused, I'm not sure if
it bears fixing or changing

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
