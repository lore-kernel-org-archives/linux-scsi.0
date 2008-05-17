From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10730] New: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined reference to `request_firmware'
Date: Sat, 17 May 2008 03:06:12 -0700 (PDT)
Message-ID: <bug-10730-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbYEQKGp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2008 06:06:45 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4HA6Cnb024252
	for <linux-scsi@vger.kernel.org>; Sat, 17 May 2008 03:06:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D10730

           Summary: build issue #503 for v2.6.26-rc2-433-gf26a398 :
                    undefined reference to `request_firmware'
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.26-rc2-433-gf26a398
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
OtherBugsDependingO 10492
             nThis:
        Regression: 1


Subject    : build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
reference to `request_firmware'
Submitter  : Toralf F=C3=B6rster <toralf.foerster@gmx.de>
Date       : 2008-05-16 17:06
References : http://marc.info/?l=3Dlinux-kernel&m=3D121095777616792&w=3D=
4

This entry is being used for tracking a regression from 2.6.25.  Please=
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
