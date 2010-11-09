From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22512] New: no disks are found at driver start after upgrate
 from 2.6.35.8 to 2.6.36
Date: Tue, 9 Nov 2010 19:53:21 GMT
Message-ID: <bug-22512-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50825 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0KITxX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 14:53:23 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA9JrMEI014424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 9 Nov 2010 19:53:22 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=22512

           Summary: no disks are found at driver start after upgrate from
                    2.6.35.8 to 2.6.36
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.36
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: QLOGIC QLA2XXX
        AssignedTo: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
        ReportedBy: cunio@agora.pl
        Regression: Yes


Driver loads without errors but after messages:
[  993.976622] qla2xxx 0000:0c:00.0: LIP reset occurred (f700).
[  993.996537] qla2xxx 0000:0c:00.0: LIP occurred (f700).
[  993.996690] qla2xxx 0000:0c:00.0: LIP reset occurred (f7f7).
[  995.027739] qla2xxx 0000:0c:00.0: LOOP UP detected (4 Gbps).
[  995.620024] qla2xxx 0000:0c:00.0:
[  995.620026]  QLogic Fibre Channel HBA Driver: 8.03.04-k0
[  995.620027]   QLogic QLE2460 - PCI-Express Single Channel 4Gb Fibre Channel
HBA
[  995.620028]   ISP2432: PCIe (2.5GT/s x4) @ 0000:0c:00.0 hdma+, host#=14,
fw=5.03.07 (496)

No disks are detected

Previous kernel detects:
[    4.017172] scsi 1:0:0:0: Direct-Access     IBM      1814      FAStT  0916
PQ: 0 ANSI: 5
[    4.017576] sd 1:0:0:0: Attached scsi generic sg3 type 0
[    4.017702] sd 1:0:0:0: Embedded Enclosure Device
[    4.018413] sd 1:0:0:0: [sdb] 838860800 512-byte logical blocks: (429 GB/400
GiB)
[    4.019311] sd 1:0:0:0: [sdb] Write Protect is off
[    4.019444] sd 1:0:0:0: [sdb] Mode Sense: 77 00 10 08
[    4.019842] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
supports DPO and FUA

and many others

driver is compiled as module

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
