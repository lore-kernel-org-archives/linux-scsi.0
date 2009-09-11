From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14157] New: end_request: I/O error, dev cciss/cXdX, sector 0
Date: Fri, 11 Sep 2009 07:42:18 GMT
Message-ID: <bug-14157-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38466 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZIKHmP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 03:42:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8B7gINi013925
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2009 07:42:18 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14157

           Summary: end_request: I/O error, dev cciss/cXdX, sector 0
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: jiri.harcarik@gmail.com
        Regression: No


After upgrade to the latest stable kernel on HP server with Smart Array
Controller these errors occurs in /var/log/messages :

Sep 10 12:42:45 node2 kernel: [   91.568968] end_request: I/O error, dev
cciss/c0d1, sector 0
Sep 10 12:42:45 node2 kernel: [   91.575688] end_request: I/O error, dev
cciss/c0d1, sector 0
Sep 10 12:42:45 node2 kernel: [   91.719894] end_request: I/O error, dev
cciss/c0d2, sector 0
Sep 10 12:42:45 node2 kernel: [   91.720092] end_request: I/O error, dev
cciss/c0d2, sector 0

Previous working kernel version that I tried is 2.6.30.4 without any errors.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
