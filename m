From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17822] New: drivers/scsi/ipr.c implicit declaration of function
 'writeq'
Date: Sun, 5 Sep 2010 14:44:41 GMT
Message-ID: <bug-17822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48931 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0IEOom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2010 10:44:42 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o85EifDH011986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 5 Sep 2010 14:44:41 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17822

           Summary: drivers/scsi/ipr.c implicit declaration of function
                    'writeq'
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.34
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: xteejyx@googlemail.com
        Regression: No


In Gentoo, I ran "genkernel all" to compile the kernel and all modules and the
following error occurred:

  CC [M]  drivers/scsi/ipr.o
drivers/scsi/ipr.c: In function 'ipr_mask_and_clear_interrupts':
drivers/scsi/ipr.c:653: error: implicit declaration of function 'writeq'
make[2]: *** [drivers/scsi/ipr.o] Error 1
make[1]: *** [drivers/scsi] Error 2

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
