From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13716] New: The AIC-7892P controller does not work any more
Date: Sun, 5 Jul 2009 19:23:18 GMT
Message-ID: <bug-13716-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58302 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZGETXP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2009 15:23:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n65JNI7b018017
	for <linux-scsi@vger.kernel.org>; Sun, 5 Jul 2009 19:23:18 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13716

           Summary: The AIC-7892P controller does not work any more
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.31-rc1. 2.6.31-rc1-git10
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: andrej@podzimek.org
        Regression: Yes


The usual probe fails with an error message saying that no IRQ could be
assigned to the controller, possibly due to a corrupt MP table.

The controller works fine with 2.6.30.1 and below.

This is how the adapter is normally initialized (messages from 2.6.29.6):
    aic7xxx 0000:01:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
    scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
    <Adaptec aic7892 Ultra160 SCSI adapter>
    aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

With 2.6.31-rc1, the kernel freezes with an error message and tries to restart
the controller periodically, which always fails.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
