From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27882] New: target code causes memory corruption
Date: Sun, 30 Jan 2011 14:05:21 GMT
Message-ID: <bug-27882-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50160 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1A3OFX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jan 2011 09:05:23 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0UE5LA2016615
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 30 Jan 2011 14:05:21 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=27882

           Summary: target code causes memory corruption
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.38-rc2+
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: fubo.chen@gmail.com
        Regression: No


Created an attachment (id=45562)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=45562)
Kernel log

Before I could to test my tcm_mvsas driver, kernel complained about memory
corruption.

How to reproduce:

modprobe configfs
mount -t configfs none /sys/kernel/config
modprobe target_core_file
dd if=/dev/zero of=/dev/ramdisk bs=1M count=16
tcm_node --fileio fileio_0/ramdisk /dev/ramdisk 16M

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
