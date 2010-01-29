From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15171] New: smartd crashing recent 2.6.32 kernel
Date: Fri, 29 Jan 2010 20:55:38 GMT
Message-ID: <bug-15171-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53081 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0A2Uzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2010 15:55:38 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0TKtcNj018284
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2010 20:55:38 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15171

           Summary: smartd crashing recent 2.6.32 kernel
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: devzero@web.de
        Regression: No


This bugticket is used to track an issue already opened in novell-bugzilla
(https://bugzilla.novell.com/show_bug.cgi?id=573244) and reported on linux-scsi
and smartmontools-support
(http://marc.info/?l=smartmontools-support&m=126462075603274&w=2)

as it appears to be an upstream issue, i`m additionally adding it here. i only
have that box for another week or two so it`s a small timeslot to test fixes on
that box.

short description:
linux kernel crashes (system freeze) at late installation stage when smartd
being started. seems smartd sends an ioctl which the driver (megaraid_mbox)
doesn`t like.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
