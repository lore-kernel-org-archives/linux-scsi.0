From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15278] New: lockdep warning for iscsi in 2.6.33-rc6
Date: Thu, 11 Feb 2010 20:05:54 GMT
Message-ID: <bug-15278-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53197 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab0BKUFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 15:05:55 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1BK5s6M027970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2010 20:05:54 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15278

           Summary: lockdep warning for iscsi in 2.6.33-rc6
           Product: SCSI Drivers
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com
        Regression: Yes


Subject    : lockdep warning for iscsi in 2.6.33-rc6
Submitter  : Tao Ma <tao.ma@oracle.com>
Date       : 2010-02-09 6:59
Message-ID : 4B7107CF.3060703@oracle.com
References : http://marc.info/?l=linux-kernel&m=126569884330200&w=2

This entry is being used for tracking a regression from 2.6.32.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
