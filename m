From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19642] New: 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: Sun, 3 Oct 2010 18:37:04 GMT
Message-ID: <bug-19642-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:52829 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0JCShF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2010 14:37:05 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o93Ib4T6001312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 3 Oct 2010 18:37:04 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=19642

           Summary: 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.36-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
                    linux@horizon.com
        Regression: Yes


Subject    : 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Submitter  : "George Spelvin" <linux@horizon.com>
Date       : 2010-09-30 21:10
Message-ID : 20100930211006.27449.qmail@science.horizon.com
References : http://marc.info/?l=linux-kernel&m=128588102620299&w=2

This entry is being used for tracking a regression from 2.6.35. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
