From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196543] Adaptec 6405H can not understand Queue full message
 from Disks.
Date: Wed, 02 Aug 2017 01:35:28 +0000
Message-ID: <bug-196543-11613-cZ787WmP3M@https.bugzilla.kernel.org/>
References: <bug-196543-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37258 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751825AbdHBBf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 21:35:29 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EDB5628741
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2017 01:35:28 +0000 (UTC)
In-Reply-To: <bug-196543-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196543

--- Comment #2 from Kazufumi Watanabe (kiyomi.kakitsubata@gmail.com) ---
Dear James

Thank you for your message.
I want give you result of sas bus trace,
but company do not give me grant permission of take data outside.

I think sorry to you not give data of bus trace.

Well, I can tell you what is happen.

Environment:
SAS HBA: 
Microsemi Adaptec 6405H/7085H
(Other SAS HBA not happend.ex Broadcom 9300-8E Adaptec 1000-8E)
OS:
Fedora26/CentOS7.3
openSUSE Leap 42.3

At install OS,when format partitions,
HBA send some commands to a SSD device(I don't know what command is send to a
SSD device).

When device's queue is full,it return "queue full" message to HBA,
but it was sending other command  to device.
I think a situation remaining the same,so OS can not install to SSD device.

This problem is SAS HBA continue sending command when receive "queue full"
message,
and kernel can not  detect it.

Cheers
Kazufumi Watanabe

-- 
You are receiving this mail because:
You are the assignee for the bug.
