From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12762] New: Disk errors loop forever in 2.6.29
Date: Mon, 23 Feb 2009 15:11:13 -0800 (PST)
Message-ID: <bug-12762-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbZBWXLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2009 18:11:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1NNBDk0023559
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2009 15:11:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12762

           Summary: Disk errors loop forever in 2.6.29
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.29-rc
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: rjw@sisk.pl
OtherBugsDependingO 12398
             nThis:
        Regression: 1


Subject    : [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
Submitter  : Sitsofe Wheeler <sitsofe@yahoo.com>
Date       : 2009-02-19 13:53
References : http://marc.info/?l=linux-kernel&m=123505185407604&w=4
Handled-By : James Bottomley <James.Bottomley@hansenpartnership.com>
Patch      : http://marc.info/?l=linux-kernel&m=123508030726900&w=4

This entry is being used for tracking a regression from 2.6.28.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
