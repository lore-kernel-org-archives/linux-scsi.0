From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196543] New: Adaptec 6405H can not understand Queue full
 message from Disks.
Date: Mon, 31 Jul 2017 02:26:50 +0000
Message-ID: <bug-196543-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37664 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751596AbdGaC1R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Jul 2017 22:27:17 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 15FB228506
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2017 02:27:17 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196543

            Bug ID: 196543
           Summary: Adaptec 6405H can not understand Queue full message
                    from Disks.
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.11.11(Fedora26 Kernel)/3.10.0(RHEL 7.3)
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: kiyomi.kakitsubata@gmail.com
        Regression: No

Hi

I happened something different caused by SAS HBA.
Adaptec 6405H can not understand Queue full message send by Disks.

Perhaps, normally, any other HBA receive Queue full message from SAS disks,
it will wait send some command to disks.
But Adaptec 6405H is not wait send command to disks,
so, happen disk time out.

I think driver or firmware's bug,because other HBA like using mpt3sas ,
is not happened.

If you need,perhaps I will give SAS bus trace.

Cheers.

-- 
You are receiving this mail because:
You are the assignee for the bug.
