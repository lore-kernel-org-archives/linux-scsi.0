From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] New: 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sat, 18 Dec 2010 23:56:34 GMT
Message-ID: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47806 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0LRX4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Dec 2010 18:56:35 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBINuY5e024551
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 18 Dec 2010 23:56:34 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192

           Summary: 3w-{9,x}xxx don't work on big-endian MIPS
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
        ReportedBy: mattst88@gmail.com
                CC: ralf@linux-mips.org
        Regression: No


Created an attachment (id=40762)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=40762)
3ware-8006: lspci, dmesg, /proc/io{mem,ports}

Using the linux-mips tree,

commit 1c334766ddc8ae7b12f3a12e0d06fe3895c5a5a7
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Wed Dec 1 17:33:17 2010 +0000

I've been trying to use either a 3ware 8006 (3w-xxxx driver) or 3ware 9500s
(3w-9xxx driver) in my Broadcom BCM91250a big-endian MIPS system.

I see commits 75913d9bb8328c4eca54cad39a5fb665b48383eb which added big-endian
support.

Please tell me what I can do to help debug this.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
