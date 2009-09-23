From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14214] New: BUG at drivers/scsi/scsi_lib.c:1108!
Date: Wed, 23 Sep 2009 11:13:27 GMT
Message-ID: <bug-14214-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55893 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZIWLNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2009 07:13:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8NBDRqj021188
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2009 11:13:27 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14214

           Summary: BUG at drivers/scsi/scsi_lib.c:1108!
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.31-07381-g7fa0772
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: pvp-lsts@fs.ru.acad.bg
        Regression: Yes


Created an attachment (id=23148)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23148)
kernel .config used

This is kernel version 2.6.31-07381-g7fa0772 (currently 2.6.31-git12),
compiled with the gcc version 4.3.3, included in Slackware 13.

I use this x86 kernel inside one Sun VirtualBox virtual machine, and one
real machine with an AMD Duron CPU.

The kernel is compiled with SMP, as you can see from the attached config,
but is run on UP machines.

I hit this BUG whenever I try to shutdown or reboot any of the machines.

The backtrace is a PNG image with the virtualbox window, but the output is
identical with the one on the real machine.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
