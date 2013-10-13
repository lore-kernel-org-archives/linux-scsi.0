From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62971] New: Kernel 3.11.1 and higher does not boot on VMware VM
Date: Sun, 13 Oct 2013 23:27:08 +0000
Message-ID: <bug-62971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47927 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab3JMX1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Oct 2013 19:27:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AEBAE2025B
	for <linux-scsi@vger.kernel.org>; Sun, 13 Oct 2013 23:27:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 422D120255
	for <linux-scsi@vger.kernel.org>; Sun, 13 Oct 2013 23:27:11 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=62971

            Bug ID: 62971
           Summary: Kernel 3.11.1 and higher does not boot on VMware VM
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.11.1
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: BUSLOGIC
          Assignee: scsi_drivers-buslogic@kernel-bugs.osdl.org
          Reporter: bojan@rexursive.com
        Regression: No

See downstream bug: https://bugzilla.redhat.com/show_bug.cgi?id=1015558

It seems that changes to BusLogic driver in 3.11 may have caused this problem.

An interesting link, including a patch, is here:

http://www.spinics.net/lists/linux-scsi/msg69044.html

AFAICT, it has not been merged into mainline or stable yet.

PS. Note that I am not in a very good position to test, bisect etc., because I
do not control the VMware installation, only the Fedora guest OS. However,
there are folks in the downstream bug that can test.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
