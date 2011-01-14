From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26692] New: Fusion MPT SPI bringup takes 80 seconds when the
 kernel is quiet
Date: Fri, 14 Jan 2011 15:40:24 GMT
Message-ID: <bug-26692-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48035 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab1ANPkZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jan 2011 10:40:25 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0EFeObW018537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2011 15:40:25 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=26692

           Summary: Fusion MPT SPI bringup takes 80 seconds when the
                    kernel is quiet
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.37
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: wferi@niif.hu
        Regression: No


Created an attachment (id=43542)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=43542)
dmesg after booting 2.6.37 quiet mtpbase.mpt_debug_level=0x8188

This is the upstream followup for
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=607906, where you can find
some basic kernel logs. Instead those I attach a log with
mpt_debug_level=0x8188 (rather arbibtary value snatched from #11045, please ask
for a better one).

In short: on an IBM x345 loading the mptspi module under 2.6.32 oopses, unless
the kernel is started with 'quiet', in which case it works all right. Under
2.6.37 the module still works all right when the 'quiet' parameter is present,
but introduces an 80-second boot delay without it (but at least manages to
avoid the oops).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
