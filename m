From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14961] New: Very old and buggy ARCMSR drivers are included
Date: Wed, 30 Dec 2009 12:38:06 GMT
Message-ID: <bug-14961-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35065 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZL3MiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2009 07:38:07 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBUCc6gS012557
	for <linux-scsi@vger.kernel.org>; Wed, 30 Dec 2009 12:38:06 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14961

           Summary: Very old and buggy ARCMSR drivers are included
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.18 etc
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: mikki@hugo.dk
        Regression: No


Created an attachment (id=24377)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24377)
Latest arcmsr

Hello,

Some very buggy ARCMSR drivers are included in the kernels dating from early
2008.

The new drivers with the same version number, but a later date exists and
should be included instead.

This is the latest
ftp://ftp.areca.com.tw/RaidCards/AP_Drivers/Linux/DRIVER/SourceCode/arcmsr.1.20.0X.15-90605.zip

With the older .15 driver i had several system lockups under heavy load.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
