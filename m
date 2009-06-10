From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13499] New: Write cache: disabled, read cache: enabled,
 supports DPO and FUA? it's  bug???
Date: Wed, 10 Jun 2009 13:59:47 GMT
Message-ID: <bug-13499-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41798 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZFJN7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 09:59:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5ADxlo1002856
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 13:59:47 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13499

           Summary: Write cache: disabled, read cache: enabled, supports
                    DPO and FUA? it's  bug???
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.22 - 2.6.30
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: lxy9805287@163.com
        Regression: No


scsi0 : LSI Logic SAS based MegaRAID driver
scsi 0:0:0:0: Direct-Access     SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
done.
Begin: Running /scripts/init-premount ... scsi 0:0:1:0: Direct-Access    
SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
scsi 0:0:2:0: Direct-Access     SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
scsi 0:0:3:0: Direct-Access     SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
scsi 0:0:4:0: Direct-Access     SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
scsi 0:0:5:0: Direct-Access     SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
scsi 0:0:6:0: Direct-Access     SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
scsi 0:0:7:0: Direct-Access     SEAGATE  ST9146852SS      HT03 PQ: 0 ANSI: 5
scsi 0:0:32:0: Enclosure         DP       BACKPLANE        1.07 PQ: 0 ANSI: 5
scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         1.21 PQ: 0 ANSI: 5
scsi 0:0:32:0: Attached scsi generic sg0 type 13
sd 0:2:0:0: [sda] 1998323712 512-byte hardware sectors (1023142 MB)
sd 0:2:0:0: [sda] Write Protect is off
sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and
FUA
sd 0:2:0:0: [sda] 1998323712 512-byte hardware sectors (1023142 MB)
sd 0:2:0:0: [sda] Write Protect is off
sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and
FUA
 sda: sda1 sda4 < sda5 sda6 sda7 sda8 sda9 >

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
