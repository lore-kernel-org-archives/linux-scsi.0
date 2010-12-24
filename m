From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25602] New: [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Date: Fri, 24 Dec 2010 14:01:35 GMT
Message-ID: <bug-25602-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:51925 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0LXOBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Dec 2010 09:01:36 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBOE1ZBF029066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 24 Dec 2010 14:01:35 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25602

           Summary: [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.37-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: Martin@Lichtvoll.de, rjw@sisk.pl,
                    maciej.rutecki@gmail.com
        Regression: Yes


Subject    : [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Submitter  : Martin Steigerwald <Martin@lichtvoll.de>
Date       : 2010-12-20 10:05
Message-ID : 201012201105.08993.Martin@lichtvoll.de
References : http://marc.info/?l=linux-kernel&m=129283954108331&w=2

This entry is being used for tracking a regression from 2.6.36. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
