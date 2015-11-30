From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108621] New: kernel BUG in drivers/scsi/scsi_lib.c
Date: Mon, 30 Nov 2015 15:06:23 +0000
Message-ID: <bug-108621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58000 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbbK3PG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2015 10:06:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2FED52054C
	for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2015 15:06:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3188620529
	for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2015 15:06:24 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108621

            Bug ID: 108621
           Summary: kernel BUG in drivers/scsi/scsi_lib.c
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.4.-rc3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: ziegler@uni-freiburg.de
        Regression: No

The kernel crashed when I started X, with a BUG in drivers/scsi/scsi_lib.c.
The crash was not immediately reproducible.

Here is a screenshot:
http://home.mathematik.uni-freiburg.de/ziegler/DSCN6480.JPG

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
