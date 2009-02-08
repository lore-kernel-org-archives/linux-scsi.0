From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12662] New: linux 2.6.29-rc3 kernel failure with mptsas
Date: Sun,  8 Feb 2009 11:44:25 -0800 (PST)
Message-ID: <bug-12662-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZBHTo4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 14:44:56 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n18JiRc4022144
	for <linux-scsi@vger.kernel.org>; Sun, 8 Feb 2009 11:44:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12662

           Summary: linux 2.6.29-rc3 kernel failure with mptsas
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.29-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
OtherBugsDependingO 12398
             nThis:
        Regression: 1


Subject    : linux 2.6.29-rc3 kernel failure with mptsas
Submitter  : "Morten P.D. Stevens" <mstevens@win-professional.com>
Date       : 2009-02-05 22:29
References : http://marc.info/?l=linux-kernel&m=123387302729741&w=4
Handled-By : Andrew Morton <akpm@linux-foundation.org>
Patch      : http://marc.info/?l=linux-kernel&m=123396429501103&w=4

This entry is being used for tracking a regression from 2.6.28.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
