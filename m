From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Tue, 17 Jan 2017 20:29:24 +0000
Message-ID: <bug-151631-11613-NO7D7t1KQ9@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751051AbdAQU32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 15:29:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3BFD0203EC
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 20:29:27 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 4499F2043C
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 20:29:24 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

Vyacheslav Dikonov <sdiconov@mail.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sdiconov@mail.ru

--- Comment #9 from Vyacheslav Dikonov <sdiconov@mail.ru> ---
I am experiencing the Synchronize Cache problem with both 4.4.43 and 4.8.17.
My dmesg yields:

[  428.593067] sd 5:0:0:0: [sdd] Synchronizing SCSI cache
[  428.716643] sd 5:0:0:0: [sdd] Synchronize Cache(10) failed: Result:
hostbyte=DID_ERROR driverbyte=DRIVER_OK

When I try to attach an external USB3 drive (over an USB2 interface). It work
well for the first time, but later, after I unmount and disconnect it, any
subsequent attempt to attacj the same hdd results in this bug. The disk cannot
be mounted for the second time. Fs is reiserfs. It happens with kernel 4.4.43
too,

-- 
You are receiving this mail because:
You are the assignee for the bug.
