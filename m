From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15950] New: Hang in dc395x driver
Date: Sun, 9 May 2010 21:19:37 GMT
Message-ID: <bug-15950-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46331 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab0EIVTl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2010 17:19:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o49LJcbd018429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 9 May 2010 21:19:38 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15950

           Summary: Hang in dc395x driver
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: DC395X
        AssignedTo: scsi_drivers-dc395x@kernel-bugs.osdl.org
        ReportedBy: ltskinol@gmail.com
        Regression: Yes


Kernel 2.6.31 and at least some earlier kernels.

I'm using an old Microtek ScanMaker flatbed scanner connected to a DC395x SCSI
card.

dc395x 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x57
dc395x:                AdaptMode=0x0f, Tags=4(16), DelayReset=1s
dc395x: Connectors: ext50  Termination: Auto Low High 
dc395x: Performing initial SCSI bus reset
scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
scsi 0:0:6:0: Scanner                    Scanner          1.80 PQ: 0 ANSI: 4
CCS
scsi 0:0:6:0: Attached scsi generic sg0 type 6
sata_nv 0000:00:05.0: version 3.5

When scanning with xsane, after a few minutes I often get a hang in xsane and
if I forcibly kill xsane, the scanner is no longer there.  When the xsane hang
occurs, I see this:

dc395x: reselect: w/o disconnected cmds <06-0>
dc395x: disconnect: Unexpected reselection <06-0>

I'm not sure when this problem started, but it's somewhere in the 2.6.2x
region.

I'd be happy to recompile, test and debug if needed.

Thanks,
Tom

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
