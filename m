From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41872] New: Kernel crashes after ejecting of Samsung U5 player
 (just a flash stick)
Date: Sun, 28 Aug 2011 14:25:23 GMT
Message-ID: <bug-41872-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42164 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1H1OZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 10:25:24 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7SEPNbP013231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2011 14:25:23 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41872

           Summary: Kernel crashes after ejecting of Samsung U5 player
                    (just a flash stick)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.38-3.0.0
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: wolfram@ritsuka.org
        Regression: No


When I'm ejecting my Samsung U5 player (mounted or umounted with udisks
--unmount or ejected via udisks --eject) I always get null pointer dereference
crash.

Please find attached screenshot with error message and additional details

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
