From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] New: 2.6.26-rc4-git2 - long pause during boot
Date: Thu,  5 Jun 2008 14:25:43 -0700 (PDT)
Message-ID: <bug-10861-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbYFEV0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 17:26:13 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m55LPhc4017563
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 14:25:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861

           Summary: 2.6.26-rc4-git2 - long pause during boot
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26-rc4-git2
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


Subject    : 2.6.26-rc4-git2 - long pause during boot
Submitter  : Chris Clayton <chris2553@googlemail.com>
Date       : 2008-06-01 4:15
References : http://marc.info/?l=linux-kernel&m=121229382917834&w=4

This entry is being used for tracking a regression from 2.6.25.  Please don't
close it until the problem is fixed in the mainline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
