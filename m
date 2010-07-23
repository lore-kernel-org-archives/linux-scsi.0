From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16447] New: BUG at drivers/scsi/scsi_lib.c:1113
Date: Fri, 23 Jul 2010 17:16:54 GMT
Message-ID: <bug-16447-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45185 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0GWRQz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2010 13:16:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6NHGtir017466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jul 2010 17:16:55 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16447

           Summary: BUG at drivers/scsi/scsi_lib.c:1113
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.35-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: jirislaby@gmail.com, rjw@sisk.pl,
                    maciej.rutecki@gmail.com
        Regression: Yes


Subject    : BUG at drivers/scsi/scsi_lib.c:1113
Submitter  : Jiri Slaby <jirislaby@gmail.com>
Date       : 2010-07-22 7:04
Message-ID : 4C47ED7B.1050709@gmail.com
References : http://marc.info/?l=linux-kernel&m=127978229512549&w=2

This entry is being used for tracking a regression from 2.6.34. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
