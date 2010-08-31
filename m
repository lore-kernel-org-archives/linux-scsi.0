From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17551] New: mpt2sas -- spurious hotplug event causes drive drop
 to drop out of JBOD array
Date: Tue, 31 Aug 2010 08:06:07 GMT
Message-ID: <bug-17551-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53569 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab0HaIHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 04:07:07 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7V86UoU003154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2010 08:07:05 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17551

           Summary: mpt2sas -- spurious hotplug event causes drive drop to
                    drop out of JBOD array
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.26 - 2.6.32rc4-scsi-misc
          Platform: All
        OS/Version: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: starlight@binnacle.cx
                CC: kashyap.desai@lsi.com
        Regression: No


At random interval of between 10 and 40 days a Seagate Momentus drive drops out
of an eight-drive JBOD array attached to a LSI 2008 SAS controller.

LSI 2008
eight Seagate Momentus ST9500420AS SATA drives, JBOD
LVM2 8x striped/RAID0 LV

CentOS 5.5 kernel 2.6.18-194.8.1.el5
MPT2BIOS 7.05.01.00 (2010.09.09)
SAS2008-IT 5.00.00.00
LSI mpt2sas 05.00.00.00

also

CentOS 5.4 kernel 2.6.18-164.10.1.el5
MPT2BIOS 7.03.00.00 (2009-10-12)
SAS2008-IR 4.00.00.00
distro mpt2sas version 01.101.00.00

-----

Striped LV is for logging and recevies moderate write activity for 6.5 hours
each day.  Additionally a 'pbzip2' job runs nightly to compress each day's log.
 Uncompressed logs run from between 250 and 500 GBs each.  Ext4 filesystem.

-----

Originally reported under bug 14831 before exact nature of problem was
identified.  See bottom of that report for initial analysis by kdesai.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
