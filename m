From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] New: System unresponsable after a lot of LUNs have been
 added to the system
Date: Thu, 27 Feb 2014 17:45:40 +0000
Message-ID: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaB0Rpo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Feb 2014 12:45:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6408420240
	for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2014 17:45:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2F98220251
	for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2014 17:45:41 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

            Bug ID: 71231
           Summary: System unresponsable after a lot of LUNs have been
                    added to the system
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.10.32
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: alexandernaumann@gmx.de
        Regression: No

Created attachment 127581
  --> https://bugzilla.kernel.org/attachment.cgi?id=127581&action=edit
Kernel config

This Kernel crash is reproducable on my system.
Right now I could get it with 3.10.25 and 3.10.32.
I works fine with 3.1.

The system (Dell R910, nut it also happens with other servers) has a QLogic
FC-HBA (qla2xxx driver).
After connection about 30 LUNs the system is working fine, but if I increase
the amount of FC-LUNs to for example 40 the system hangs afetr some seconds.

Maybe this bug has been already fixed by Suse:
http://kernel.suse.com/cgit/kernel-source/tree/patches.fixes/mm-resched-to-avoid-rcu-stall-during-boot-large-machines.patch?h=SLE11-SP3&id=6780159bba20e9f99dd5ac8a4e18f98f9c93adf7

If it is the case I think this patch should be put into current kernel lines.

-- 
You are receiving this mail because:
You are the assignee for the bug.
