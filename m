From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11404] New: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Fri, 22 Aug 2008 14:51:14 -0700 (PDT)
Message-ID: <bug-11404-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757921AbYHVVvo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 17:51:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7MLpEpP005410
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2008 14:51:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11404

           Summary: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.23-rc3-git7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
OtherBugsDependingO 11167
             nThis:
        Regression: 1


Subject    : BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Submitter  : rdunlap <randy.dunlap@oracle.com>
Date       : 2008-08-21 5:52
References : http://marc.info/?l=linux-kernel&m=121929819616273&w=4
References : http://marc.info/?l=linux-kernel&m=121932889105368&w=4
Handled-By : "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Handled-By : James Bottomley <James.Bottomley@hansenpartnership.com>

This entry is being used for tracking a regression from 2.6.26.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
