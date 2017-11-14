From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] New: Processes hang on attempted access of WDC
 WD30-EZRX 3TB HDD on HP Z420 Workstation
Date: Tue, 14 Nov 2017 22:06:16 +0000
Message-ID: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35562 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752567AbdKNWGS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Nov 2017 17:06:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B3624299B0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2017 22:06:17 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

            Bug ID: 197875
           Summary: Processes hang on attempted access of WDC WD30-EZRX
                    3TB HDD on HP Z420 Workstation
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.13.x
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: chuck.burt+kernel.org@gmail.com
        Regression: No

When booted under kernel 4.13.x, processes (such as parted, boot-info, gparted,
etc) always hang when attempting to run due to a Western Digital Green
WD30-EZRX 3TB HDD. Drive works as expected under kernel 4.10.x (even when all
other things are the same about the system but only booted kernel is
different).

Full specs of the machine if useful:
https://www.support.hp.com/id-en/document/c03277050

More details on Ubuntu's LaunchPad (where they asked me to come here to file an
upstream bug): https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1730746

-- 
You are receiving this mail because:
You are the assignee for the bug.
