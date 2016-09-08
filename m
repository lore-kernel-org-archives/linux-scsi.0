From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 156411] New: scsi host6: runtime PM trying to activate child
 device host6 but parent (3-4:1.0) is not active
Date: Thu, 08 Sep 2016 21:45:14 +0000
Message-ID: <bug-156411-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751672AbcIHVpS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 17:45:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 4D79C20397
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 21:45:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 3C10420386
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 21:45:15 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=156411

            Bug ID: 156411
           Summary: scsi host6: runtime PM trying to activate child device
                    host6 but parent (3-4:1.0) is not active
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.8.0-040800rc5-lowlatency
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

Created attachment 232711
  --> https://bugzilla.kernel.org/attachment.cgi?id=232711&action=edit
dmesg_4.8.0-040800rc5-lowlatency

dmesg:

[ 8604.247753] scsi host6: runtime PM trying to activate child device host6 but
parent (3-4:1.0) is not active

-- 
You are receiving this mail because:
You are the assignee for the bug.
