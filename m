From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 37042] New: linux 3.0.0-rc2 libata-eh.c:4018
 ata_scsi_port_error_handler+0x80/0x53d on s2disk
Date: Thu, 9 Jun 2011 08:22:41 GMT
Message-ID: <bug-37042-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:49384 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1FIIWm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2011 04:22:42 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p598MfKM017783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2011 08:22:41 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=37042

           Summary: linux 3.0.0-rc2 libata-eh.c:4018
                    ata_scsi_port_error_handler+0x80/0x53d on s2disk
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.0.0-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: alex.vizor@gmail.com
        Regression: Yes


Created an attachment (id=61332)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=61332)
kernel.log

Hi,

I'm using linux kernel 3.0.0-rc2 from git and seems s2disk functionality is
broken, s2ram also doesn't work, I suspect that bith these regressions have
same roots. And yes this is a regression because it worked OK in linux 2.6.39

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
