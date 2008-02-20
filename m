From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10050] New: message/fusion/mptbase.c: fix use-after-free's
Date: Tue, 19 Feb 2008 16:44:41 -0800 (PST)
Message-ID: <bug-10050-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762786AbYBTAor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 19:44:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1K0ifif011006
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 16:44:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10050

           Summary: message/fusion/mptbase.c: fix use-after-free's
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.25-rc2-git
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: bunk@kernel.org
OtherBugsDependingO 9832
             nThis:
        Regression: 1


Subject         : message/fusion/mptbase.c: fix use-after-free's
Submitter       : Adrian Bunk <bunk@kernel.org>
References      : http://lkml.org/lkml/2008/2/19/562
Caused-By       : Sathya Prakash <sathya.prakash@lsi.com>
                  commit e78d5b8f1e73ab82f3fd041d05824cfee7d83a2c
Handled-By      : Adrian Bunk <bunk@kernel.org>
Patch           : http://lkml.org/lkml/2008/2/19/562


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
