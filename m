From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60686] New: USB 3.0 disks do not mount
Date: Sun, 04 Aug 2013 07:57:03 +0000
Message-ID: <bug-60686-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab3HDH5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Aug 2013 03:57:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1BE1F20161
	for <linux-scsi@vger.kernel.org>; Sun,  4 Aug 2013 07:57:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D29712015E
	for <linux-scsi@vger.kernel.org>; Sun,  4 Aug 2013 07:57:03 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60686

            Bug ID: 60686
           Summary: USB 3.0 disks do not mount
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: v3.11-rc3-376-g72a67a9
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: ziegler@uni-freiburg.de
        Regression: Yes

My USB-disk
             SCSI Disk
             product: External USB 3.0
             vendor: TOSHIBA
             physical id: 0.0.0
             bus info: scsi@6:0.0.0
             logical name: /dev/sdb
             version: 0201
             serial: D010A553
             size: 465GiB (500GB)
             configuration: ansiversion=6 sectorsize=512

cannot be mounted. /dev/g2 exists, but udev does not generate /dev/sdb.
This seems to be the bug discussed in
http://www.spinics.net/lists/stable/msg15978.html. As described there, the bugs
goes away if one reverts 

  commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d
  Author: Martin K. Petersen <martin.petersen@oracle.com>
  Date:   Thu Jun 6 22:15:55 2013 -0400

    [SCSI] sd: Update WRITE SAME heuristics

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
