From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10622] New: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Thu,  8 May 2008 11:59:03 -0700 (PDT)
Message-ID: <bug-10622-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765585AbYEHS7g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 14:59:36 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m48Ix38C009552
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2008 11:59:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10622

           Summary: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in
                    sr_probe()
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: rjw@sisk.pl
OtherBugsDependingO 10492
             nThis:
        Regression: 1


Subject    : [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Submitter  : Jeff Garzik <jeff@garzik.org>
Date       : 2008-05-04 07:22
References : http://lkml.org/lkml/2008/5/4/76
Handled-By : James Bottomley <James.Bottomley@hansenpartnership.com>

This entry is being used for tracking a regression from 2.6.25.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
