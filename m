From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14572] New: No closing brace. In the example tag_info.
Date: Mon, 9 Nov 2009 22:58:43 GMT
Message-ID: <bug-14572-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44288 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZKIW6j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 17:58:39 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA9Mwh2L007901
	for <linux-scsi@vger.kernel.org>; Mon, 9 Nov 2009 22:58:43 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14572

           Summary: No closing brace. In the example tag_info.
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.32-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: pavel@pavlinux.ru
        Regression: No


No closing brace. In the example tag_info.

diff -ur a/Documentation/scsi/aic79xx.txt b/Documentation/scsi/aic79xx.txt
--- a/Documentation/scsi/aic79xx.txt    2009-11-10 01:37:25.054003554 +0300
+++ b/Documentation/scsi/aic79xx.txt    2009-11-10 01:37:59.575004426 +0300
@@ -269,7 +269,7 @@
                       per controller basis.  Both controllers and targets
                       may be ommitted indicating that they should retain
                       the default tag depth.
-            Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}
+            Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}}
                         On Controller 0
                           specifies a tag depth of 16 for target 0
                           specifies a tag depth of 64 for target 3

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
