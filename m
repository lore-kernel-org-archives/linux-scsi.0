From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10411] New: [PATCH] scsi: fix sense_slab/bio swapping livelock
Date: Mon,  7 Apr 2008 02:15:40 -0700 (PDT)
Message-ID: <bug-10411-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488AbYDGJQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 05:16:12 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m379Ffx3026418
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2008 02:15:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10411

           Summary: [PATCH] scsi: fix sense_slab/bio swapping livelock
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.25-rc7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: rjw@sisk.pl
OtherBugsDependingO 9832
             nThis:
        Regression: 1


Subject    : [PATCH] scsi: fix sense_slab/bio swapping livelock
Submitter  : Hugh Dickins <hugh@veritas.com>
Date       : 2008-04-06 23:56
References : http://lkml.org/lkml/2008/4/6/99
Handled-By : James Bottomley <James.Bottomley@hansenpartnership.com>
Patch      : http://lkml.org/lkml/2008/4/6/99

This entry is being used for tracking a regression from 2.6.24.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
