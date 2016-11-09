From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187381] New: 4.9.-rc4 produces hundreds of unusable scsi
 devices.
Date: Wed, 09 Nov 2016 20:20:08 +0000
Message-ID: <bug-187381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752057AbcKIUUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 15:20:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D53F520374
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 20:20:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 93F7C20357
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 20:20:08 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187381

            Bug ID: 187381
           Summary: 4.9.-rc4 produces hundreds of unusable scsi devices.
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.9-rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: samuel.silbory@hds.com
        Regression: No

Created attachment 244091
  --> https://bugzilla.kernel.org/attachment.cgi?id=244091&action=edit
Debian's kernel log file.  Note that this contains functional boots with older
kernels as well earlier in the file.

With both my hand compiled 4.9-rc4 from kernel.org sources and Ubuntu's
4.9.0-040900rc4-generic the kernel creates hundred of useless /dev/sd??
devices.  This system is fine with various 4.4, and 4.8 kernels.

The logs are spammed with messages like these
2016-11-09T12:17:00.021765-08:00 Node001 kernel: [75590.503155] Dev sdjm:
unable to read RDB block 1
2016-11-09T12:17:00.021767-08:00 Node001 kernel: [75590.503188]  sdjm: unable
to read partition table
2016-11-09T12:17:00.021769-08:00 Node001 kernel: [75590.503191] sdjm: partition
table beyond EOD, enabling native capacity
2016-11-09T12:17:00.021776-08:00 Node001 kernel: [75590.504463] sd 1:3:126:0:
[sdjl] Sector size 0 reported, assuming 512.
2016-11-09T12:17:00.021778-08:00 Node001 kernel: [75590.504486] sd 1:3:127:0:
[sdjm] Sector size 0 reported, assuming 512.
2016-11-09T12:17:00.025711-08:00 Node001 kernel: [75590.504624] Dev sdjl:
unable to read RDB block 1
2016-11-09T12:17:00.025720-08:00 Node001 kernel: [75590.504625] Dev sdjm:
unable to read RDB block 1
2016-11-09T12:17:00.025722-08:00 Node001 kernel: [75590.504635]  sdjm: unable
to read partition table
2016-11-09T12:17:00.025724-08:00 Node001 kernel: [75590.504687] sdjm: partition
table beyond EOD, truncated
2016-11-09T12:17:00.025725-08:00 Node001 kernel: [75590.504697]  sdjl: unable
to read partition table
2016-11-09T12:17:00.025727-08:00 Node001 kernel: [75590.504701] sdjl: partition
table beyond EOD, truncated
2016-11-09T12:17:00.025728-08:00 Node001 kernel: [75590.505084] sd 1:3:127:0:
[sdjm] Sector size 0 reported, assuming 512.
2016-11-09T12:17:00.025730-08:00 Node001 kernel: [75590.505088] sd 1:3:126:0:
[sdjl] Sector size 0 reported, assuming 512.
2016-11-09T12:17:00.025732-08:00 Node001 kernel: [75590.505115] sd 1:3:126:0:
[sdjl] Attached SCSI disk
2016-11-09T12:17:00.025733-08:00 Node001 kernel: [75590.505151] sd 1:3:127:0:
[sdjm] Attached SCSI disk

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
