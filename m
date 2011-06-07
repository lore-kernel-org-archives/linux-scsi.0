From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36822] New: Slow boot with dc395x compiled into the kernel.
Date: Tue, 7 Jun 2011 09:29:45 GMT
Message-ID: <bug-36822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:56190 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1FGJ3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2011 05:29:46 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p579TjlX026682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jun 2011 09:29:45 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=36822

           Summary: Slow boot with dc395x compiled into the kernel.
           Product: SCSI Drivers
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: DC395X
        AssignedTo: scsi_drivers-dc395x@kernel-bugs.osdl.org
        ReportedBy: taxi@a-city.de
        Regression: No


I'm using a Tekram TRM-S1040 Card with a HP Scanner connected to it.
When I compile the driver directly into the kernel the kernel needs about 7
secounds to boot with a noticabe delay here:
[    3.107686] scsi 7:0:0:3: Direct-Access     Generic  USB MS Reader    1.03
PQ: 0 ANSI: 0
[    6.130981] scsi 0:0:0:0: Attached scsi generic sg0 type 3
(where sg0 is the scanner)

Also my internal drives correlate with the USB Card-Reader, so my drives are:
sda: card reader
sdb: fist harddrive
sdc-sde: card reader
sdf: secound harddrive

But if I compile the driver as a Module (so it's loaded by udev) the kernel
boot time is only about 2.5 secounds, my drives are:
sda: first or secound harddrive
sdb: first or secound harddrive
sdc-sdf: card reader

also the boot-time of the whole machine (kernel + init) is reduced by around 6
to 8 secounds.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
