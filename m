From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16971] New: qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
Date: Tue, 24 Aug 2010 19:07:49 GMT
Message-ID: <bug-16971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60421 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0HXTHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 15:07:50 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7OJ7nHW003452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2010 19:07:49 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16971

           Summary: qla4xxx compile failure on 32-bit PowerPC: missing
                    readq and writeq
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.36-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: mroos@linux.ee, rjw@sisk.pl, maciej.rutecki@gmail.com
        Regression: Yes


Subject    : qla4xxx compile failure on 32-bit PowerPC: missing readq and
writeq
Submitter  : Meelis Roos <mroos@linux.ee>
Date       : 2010-08-19 21:03
Message-ID : alpine.SOC.1.00.1008192359310.19654@math.ut.ee
References : http://marc.info/?l=linux-kernel&m=128225184900892&w=2

This entry is being used for tracking a regression from 2.6.35. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
