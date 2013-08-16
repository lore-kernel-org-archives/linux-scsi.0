From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] New: module scsi_wait_scan not found kernel panic on
 boot
Date: Fri, 16 Aug 2013 19:17:18 +0000
Message-ID: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55109 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab3HQAZI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 20:25:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 19419202AB
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2013 19:17:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C74E820266
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2013 19:17:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

            Bug ID: 60758
           Summary: module scsi_wait_scan not found kernel panic on boot
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.10.6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: zakrzewskim@wp.pl
        Regression: No

Created attachment 107218
  --> https://bugzilla.kernel.org/attachment.cgi?id=107218&action=edit
Kernel panic screenshot

After upgrading kernel 3.10.4-1 to 3.10.5-1 or 3.10.6-1 the system is refusing
to boot with "module scsi_wait_scan not found" long error message. Then comes
kernel panic.

I'm on CentOS 6.4 64-bit.

-- 
You are receiving this mail because:
You are the assignee for the bug.
