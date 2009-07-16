From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] New: udev causes high cpu usage
Date: Thu, 16 Jul 2009 07:36:03 GMT
Message-ID: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55408 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbZGPHgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 03:36:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6G7a3mi008479
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 07:36:03 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783

           Summary: udev causes high cpu usage
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.31-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: AndreasFackler@web.de
        Regression: No


Created an attachment (id=22372)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22372)
Output of "udevadm monitor --environment" with udev-141-1.2 and kernel 2.6.30

Before I upgraded the udev version of Ubuntu 9.04 from 141-1 to 141-1.1 (and
141-1.2), top reported about 2% total cpu usage when idle. After the update, it
rarely drops below 35%. Though top lists udevd among the more cpu hungry
processes, it is only listed with about 3%, while system (in line 3) almost
never drops below 20%.

"udevadm monitor --environment" after the upgrade reports many additional
events with "SUBSYSTEM=scsi" and "ACTION=change".

I am using the amd64 version of Xubuntu 9.04 on a Acer Extensa 5230 laptop with
a 2 GHz Intel Celeron processor. The problem occurs with all the kernel
versions I tried: The Ubuntu kernel 2.6.28 and the mainline kernels 2.6.30 and
2.6.31-rc3.

See also the Ubuntu bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/379780

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
