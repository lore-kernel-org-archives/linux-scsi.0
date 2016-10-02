From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 175431] New: scsi host6: runtime PM trying to activate child
 device host6 but parent (3-1:1.0) is not active
Date: Sun, 02 Oct 2016 22:35:59 +0000
Message-ID: <bug-175431-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbcJBWgD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 2 Oct 2016 18:36:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id A04072020F
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 22:36:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 4CD63201EF
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 22:36:00 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=175431

            Bug ID: 175431
           Summary: scsi host6: runtime PM trying to activate child device
                    host6 but parent (3-1:1.0) is not active
           Product: IO/Storage
           Version: 2.5
    Kernel Version: Ubuntu 4.8.0-17.19-lowlatency 4.8.0-rc7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: caravena@gmail.com
        Regression: No

Open bug in lauchpad.net
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1629714

"[ 7434.858833] scsi host6: runtime PM trying to activate child device host6
but parent (3-1:1.0) is not active"

-- 
You are receiving this mail because:
You are the assignee for the bug.
