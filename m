From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40182] New: Cannot compile kernel 3.0.0+
Date: Wed, 27 Jul 2011 15:46:12 GMT
Message-ID: <bug-40182-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59591 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1G0PqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 11:46:14 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6RFkDV3015460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 15:46:13 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=40182

           Summary: Cannot compile kernel 3.0.0+
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.0.0+
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: hilld@binarystorm.net
        Regression: No


ERROR: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!
WARNING: modpost: Found 3 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
Making modules failed!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
