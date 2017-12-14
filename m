From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198161] New: incremental patch-4.9.51-52 on sg.c break Nero 4
 nero burning rom application
Date: Thu, 14 Dec 2017 02:35:42 +0000
Message-ID: <bug-198161-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33080 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751798AbdLNCfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 21:35:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ACCA728E91
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2017 02:35:42 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198161

            Bug ID: 198161
           Summary: incremental patch-4.9.51-52 on sg.c break Nero 4 nero
                    burning rom application
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: linux-4.9.52 up to linux-4.9.68
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: luc.bertho@gmail.com
        Regression: No

Hi

Nero 4 Linux can no longer detect devices since the changes in code in sg.c.
It displays the following message: "Warning: no device detected"...

Regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
