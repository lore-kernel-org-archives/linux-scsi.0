From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] New: Load goes up very high when we traverse the large
 tree
Date: Wed, 17 Feb 2010 11:43:36 GMT
Message-ID: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43358 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab0BQLni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 06:43:38 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1HBhaRS032528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Feb 2010 11:43:36 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341

           Summary: Load goes up very high when we traverse the large tree
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: frederic@juliana-multimedia.com
        Regression: No


Created an attachment (id=25088)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25088)
dmesg of kernel 2.6.32

Hi,

When I do a "find" or a "du" on a large tree the load goes up very high (over
160) to hang the system. A ctrl-C can kill the command and load back down
quietly. I not had this problem with version 2.6.31.

There is no error message in the logs.

Regards.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
