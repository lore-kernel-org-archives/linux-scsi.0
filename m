From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10711] New: BUG: unable to handle kernel paging request - scsi_bus_uevent
Date: Thu, 15 May 2008 15:42:25 -0700 (PDT)
Message-ID: <bug-10711-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111AbYEOWm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 18:42:56 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4FMgPIX026698
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2008 15:42:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10711

           Summary: BUG: unable to handle kernel paging request -
                    scsi_bus_uevent
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26-rc2
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


Subject    : BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter  : "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Date       : 2008-05-14 11:23
References : http://lkml.org/lkml/2008/5/14/111

This entry is being used for tracking a regression from 2.6.25.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
