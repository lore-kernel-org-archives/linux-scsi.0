From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12759] New: scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Mon, 23 Feb 2009 14:50:15 -0800 (PST)
Message-ID: <bug-12759-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbZBWW6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2009 17:58:02 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1NMvUan022481
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2009 14:57:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12759

           Summary: scsi: aic7xxx hang since v2.6.28-rc1 ...
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.28-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
                CC: stern@rowland.harvard.edu, mingo@elte.hu
OtherBugsDependingO 11808
             nThis:
        Regression: 1


Subject    : scsi: aic7xxx hang since v2.6.28-rc1 ...
Submitter  : Ingo Molnar <mingo@elte.hu>
Date       : 2009-02-15 11:44
References : http://marc.info/?l=linux-kernel&m=123469852817058&w=4
Handled-By : Alan Stern <stern@rowland.harvard.edu>

This entry is being used for tracking a regression from 2.6.27.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
