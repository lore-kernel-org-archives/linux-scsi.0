From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14644] New: PROBLEM: system locking when burning dvd with an
 externel usb dvd writer
Date: Fri, 20 Nov 2009 11:11:47 GMT
Message-ID: <bug-14644-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54944 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZKTLLl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 06:11:41 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAKBBltX011998
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 11:11:47 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14644

           Summary: PROBLEM: system locking when burning dvd with an
                    externel usb dvd writer
           Product: IO/Storage
           Version: 2.5
    Kernel Version: Linux version 2.6.32-rc8-00011-ga8a8a66-dirty
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: lordheavym@gmail.com
        Regression: No


Created an attachment (id=23840)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23840)
dmesg output

When i try to burn a dvd with an externel dvd writer (usb), i've got system
freeze during sometime then burning dvd fail.

System : archlinux x86_64
Cpu : AMD Athlon(tm) II X4 630 Processor

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
