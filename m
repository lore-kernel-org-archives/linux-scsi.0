From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14821] New: No closing brace, in the example parameter tag_info
Date: Mon, 14 May 2012 15:50:36 +0000 (UTC)
Message-ID: <bug-14821-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33534 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab2ENPuj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 May 2012 11:50:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A68E020276
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 15:50:38 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 85A2220371
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 15:50:37 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14821

           Summary: No closing brace, in the example parameter tag_info
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.32-git11
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: alan@lxorguk.ukuu.org.uk
        ReportedBy: pavel@pavlinux.ru
                CC: alan@lxorguk.ukuu.org.uk
        Regression: No



Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
         AssignedTo|linux-scsi@vger.kernel.org  |alan@lxorguk.ukuu.org.uk


No closing brace, in the example parameter tag_info


diff --git a/Documentation/scsi/aic79xx.txt b/Documentation/scsi/aic79xx.txt
index c014ecc..bbb591f 100644
--- a/Documentation/scsi/aic79xx.txt
+++ b/Documentation/scsi/aic79xx.txt
@@ -269,7 +269,7 @@ The following information is available in this file:
                       per controller basis.  Both controllers and targets
                       may be ommitted indicating that they should retain
                       the default tag depth.
-            Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}
+            Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}}
                         On Controller 0
                           specifies a tag depth of 16 for target 0
                           specifies a tag depth of 64 for target 3

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
