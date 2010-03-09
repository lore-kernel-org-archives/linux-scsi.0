From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15493] New: [cppcheck] found a memory leak in
 linux-2.6/drivers/scsi/aacraid/commctrl.c
Date: Tue, 9 Mar 2010 15:45:08 GMT
Message-ID: <bug-15493-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44842 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0CIPpJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 10:45:09 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o29Fj8dF022316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 9 Mar 2010 15:45:08 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15493

           Summary: [cppcheck] found a memory leak in
                    linux-2.6/drivers/scsi/aacraid/commctrl.c
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.34 git head
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: ettl.martin@gmx.de
        Regression: No


Created an attachment (id=25425)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25425)
fix 

during a check of the current git head of the linux kernel with the static code
analysis tool cppcheck
(http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page) the
tool discovered a memory leak in linux-2.6/drivers/scsi/aacraid/commctrl.c

Please refer the attached patch, that fixes the issue.

Best regards

Ettl Martin

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
