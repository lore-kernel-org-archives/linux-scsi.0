From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18862] New: [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
Date: Mon, 20 Sep 2010 18:36:55 GMT
Message-ID: <bug-18862-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:50736 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab0ITSgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2010 14:36:55 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8KIatNt011029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2010 18:36:55 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18862

           Summary: [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.36-rc4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
                    jack_wang@usish.com
        Regression: Yes


Subject    : [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
Submitter  : "Jack Wang" <jack_wang@usish.com>
Date       : 2010-09-17 10:11
Message-ID : 3219F4D1734640238A632382C50F633E@usish.com.cn
References : http://marc.info/?l=linux-kernel&m=128471846828998&w=2

This entry is being used for tracking a regression from 2.6.35. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
