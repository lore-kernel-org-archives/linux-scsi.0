From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] New: SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Sun, 20 Jul 2014 00:37:39 +0000
Message-ID: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaGTAhn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2014 20:37:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6C5CF20109
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jul 2014 00:37:42 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A205820120
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jul 2014 00:37:39 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

            Bug ID: 80711
           Summary: SG_FLAG_LUN_INHIBIT is no longer implemented and
                    there's not way to prevent the kernel from using the
                    2nd cdb byte for the LUN
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.16-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: tiziano.bacocco@gmail.com
        Regression: No

-- 
You are receiving this mail because:
You are the assignee for the bug.
