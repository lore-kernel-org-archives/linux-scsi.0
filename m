From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10186] New: SCSI_AIC94XX must depend on SCSI
Date: Thu,  6 Mar 2008 15:08:16 -0800 (PST)
Message-ID: <bug-10186-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605AbYCFXIq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2008 18:08:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m26N8cLe015827
	for <linux-scsi@vger.kernel.org>; Thu, 6 Mar 2008 15:08:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D10186

           Summary: SCSI_AIC94XX must depend on SCSI
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.25-rc4-56-gd7fe321
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
OtherBugsDependingO 9832
             nThis:
        Regression: 1


Submitter       : Toralf F=C3=B6rster <toralf.foerster@gmx.de>
Date            : 2008-03-06 19:09
References      : http://marc.info/?l=3Dlinux-kernel&m=3D12048307361723=
2&w=3D2
Handled-By      : Adrian Bunk <bunk@kernel.org>
Patch           : http://marc.info/?l=3Dlinux-kernel&m=3D12048349972592=
8&w=3D2

This entry is being used for tracking a regression from 2.6.24.  Please=
 don't
close it until the problem is fixed in the mainline.


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
