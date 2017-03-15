From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Wed, 15 Mar 2017 07:47:05 +0000
Message-ID: <bug-194837-11613-02wKKRrmw3@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49630 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751068AbdCOHrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 03:47:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EF17428600
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 07:47:10 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 36046285FB
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 07:47:10 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #12 from Thorsten Leemhuis (linux@leemhuis.info) ---
(In reply to Omar Sandoval from comment #11)

> The fix was [...]

Thx for providing details!

> If you are still seeing crashes on -rc2,

Yes, but different ones every few boot attempts. But I just noticed those
crashes happen without virtio-scsi as well. So definitely something else now.
4.10 otoh works well; just retested to be sure. Sigh, I guess I need to take a
closer look to find out what's wrong; that might take a day or two.

-- 
You are receiving this mail because:
You are the assignee for the bug.
